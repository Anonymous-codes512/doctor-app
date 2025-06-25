import os
from flask import request, jsonify, Blueprint
from werkzeug.utils import secure_filename
from extensions import db
from models import User , Patient, Doctor , Note
from utils.enum import Gender
from datetime import datetime
from models.patient import doctor_patient  # Import the association table

patient_bp = Blueprint('patient', __name__, url_prefix='/api')

UPLOAD_FOLDER = 'static/uploads/patients'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@patient_bp.route('/create_patient', methods=['POST'])
def create_patient():
    try:
        print(f"✅ Incoming request data: {request.form}") # Added print for all form data
        print(f"✅ Incoming request files: {request.files}") # Added print for all files

        image = request.files.get('image')
        image_path = None
        if image:
            filename = secure_filename(image.filename)
            image_path = os.path.join(UPLOAD_FOLDER, filename)
            image.save(image_path)
            print(f"🖼️ Image saved to: {image_path}") # Added print
        else:
            print("🚫 No image file received.") # Added print

        full_name = request.form.get('fullName')
        email = request.form.get('email')
        contact = request.form.get('contact')
        date_of_birth = request.form.get('dateOfBirth')
        gender = request.form.get('gender')
        allergies = request.form.get('allergies')
        address = request.form.get('address')
        weight = request.form.get('weight')
        height = request.form.get('height')
        blood_pressure = request.form.get('bloodPressure')
        pulse = request.form.get('pulse')
        doctor_user_id = request.form.get('doctorUserId') # This should be a string at this point
        password = f'{full_name} 1234' # Consider a more secure password generation in production

        print(f"Received form values:") # Added print
        print(f"  fullName: {full_name}")
        print(f"  email: {email}")
        print(f"  contact: {contact}")
        print(f"  doctorUserId: {doctor_user_id} (Type: {type(doctor_user_id)})") # Added type check

        if not full_name or not email or not contact or not doctor_user_id:
            missing_fields = []
            if not full_name: missing_fields.append('fullName')
            if not email: missing_fields.append('email')
            if not contact: missing_fields.append('contact')
            if not doctor_user_id: missing_fields.append('doctorUserId')
            print(f"🚫 Missing required fields: {missing_fields}") # Added print for missing fields
            return jsonify({'success': False, 'message': f'Name, email, contact & doctor ID are required. Missing: {", ".join(missing_fields)}'}), 400

        allowed_genders = ['male', 'female', 'other']
        if gender and gender not in allowed_genders:
            print(f"🚫 Invalid gender received: {gender}") # Added print
            return jsonify({'success': False, 'message': f"Invalid gender. Allowed: {allowed_genders}"}), 400

        dob = datetime.fromisoformat(date_of_birth).date() if date_of_birth else None

        # Convert doctor_user_id to int AFTER validation
        try:
            doctor_user_id_int = int(doctor_user_id)
        except ValueError:
            print(f"🚫 doctorUserId '{doctor_user_id}' is not a valid integer.") # Added print
            return jsonify({'success': False, 'message': 'Doctor User ID must be a valid number.'}), 400

        doctor = Doctor.query.filter_by(user_id=doctor_user_id_int).first()
        if not doctor:
            print(f"🚫 Doctor with user_id {doctor_user_id_int} not found.") # Added print
            return jsonify({'success': False, 'message': 'Doctor not found.'}), 404

        new_user = User(
            name=full_name,
            email=email,
            phone_number=contact,
            role='PATIENT',
            password=password, # In a real app, hash this password!
        )
        db.session.add(new_user)
        db.session.flush() # Flush to get new_user.id

        new_patient = Patient(
            user_id=new_user.id,
            date_of_birth=dob,
            gender=Gender(gender) if gender else None,
            allergies=allergies,
            address=address,
            weight=weight,
            height=height,
            blood_pressure=blood_pressure,
            pulse=pulse,
            image_path=image_path
        )
        db.session.add(new_patient)
        db.session.flush() # Flush to get new_patient.id

        insert_stmt = doctor_patient.insert().values(
            doctor_id=doctor.id,
            patient_id=new_patient.id
        )
        db.session.execute(insert_stmt)
        db.session.commit()
        print(f"🎉 Patient '{full_name}' added and linked to doctor '{doctor.user.name}'.") # Added print

        return jsonify({'success': True, 'message': 'Patient added and linked to doctor.'}), 201

    except Exception as e:
        db.session.rollback()
        print(f'❌ Error in create_patient: {e}')
        return jsonify({'success': False, 'message': 'Internal server error.'}), 500
    
@patient_bp.route('/fetch_patients/<int:user_id>', methods=['GET'])
def fetch_patients(user_id):
    try:
        doctor = Doctor.query.filter_by(user_id=user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': 'Doctor not found'}), 404

        patients = (
            db.session.query(Patient)
            .join(doctor_patient, doctor_patient.c.patient_id == Patient.id)
            .filter(doctor_patient.c.doctor_id == doctor.id)
            .all()
        )

        patients_data = []
        for patient in patients:
            user = User.query.get(patient.user_id)

            notes = Note.query.filter_by(
                doctor_id=doctor.id,
                patient_id=patient.id
            ).all()

            notes_data = [{
                'note_id': note.id,
                'doctor_user_id': doctor.user_id,
                'patient_id': patient.id,
                'notes_title': note.notes_title,
                'notes_description': note.notes_description,
                'date': note.date.isoformat() if note.date else None,
            } for note in notes]

            patients_data.append({
                'id': patient.id,
                'user_id': patient.user_id,
                'doctorUserId': doctor.user_id,
                'fullName': user.name if user else None,
                'email': user.email if user else None,
                'contact': patient.contact,
                'address': patient.address,
                'dateOfBirth': patient.date_of_birth.isoformat() if patient.date_of_birth else None,
                'genderBornWith': patient.gender_born_with.name if patient.gender_born_with else None,
                'genderIdentifiedWith': patient.gender_identified_with.name if patient.gender_identified_with else None,
                'weight': patient.weight,
                'height': patient.height,
                'bloodPressure': patient.blood_pressure,
                'pulse': patient.pulse,
                'allergies': patient.allergies,
                'kinRelation': patient.kin_relation,
                'kinFullName': patient.kin_full_name,
                'kinContactNumber': patient.kin_contact_number,
                'gpDetails': patient.gp_details,
                'preferredLanguage': patient.preferred_language,
                'notes': notes_data,
                'hasPhysicalDisabilities': patient.has_physical_disabilities,
                'physicalDisabilitySpecify': patient.physical_disability_specify,
                'requiresWheelchairAccess': patient.requires_wheelchair_access,
                'wheelchairSpecify': patient.wheelchair_specify,
                'needsSpecialCommunication': patient.needs_special_communication,
                'communicationSpecify': patient.communication_specify,
                'hasHearingImpairments': patient.has_hearing_impairments,
                'hearingSpecify': patient.hearing_specify,
                'hasVisualImpairments': patient.has_visual_impairments,
                'visualSpecify': patient.visual_specify,
                'environmentalFactors': patient.environmental_factors,
                'otherAccessibilityNeeds': patient.other_accessibility_needs,
                'hasHealthInsurance': patient.has_health_insurance,
                'insuranceProvider': patient.insurance_provider,
                'policyNumber': patient.policy_number,
                'insuranceClaimContact': patient.insurance_claim_contact,
                'linkedHospitals': patient.linked_hospitals,
                'additionalHealthBenefits': patient.additional_health_benefits,
                
                # ✅ Past medical history
                'hasPastMedicalHistory': patient.has_past_medical_history,
                'pastMedicalHistory': patient.past_medical_history,
                'hasMedicationHistory': patient.has_medication_history,
                'medicationHistory': patient.medication_history,
                'hasFamilyHistory': patient.has_family_history,
                'familyHistory': patient.family_history,
                
                # ✅ Past drug history
                'hasAllergatic' : patient.has_allergies,
                'hasMedicationAllergatic' : patient.has_medication_allergatic,
                'medicationAllergatic' : patient.medication_allergatic,
                'hasTakingMedication' : patient.has_taking_medication,
                'takingMedication' : patient.taking_medication,
                'hasMentalMedication' : patient.has_mental_medication,
                'mentalMedication' : patient.mental_medication,

                # ✅ Past psychiatric history
                'isVisitedPsychiatrist' : patient.is_visited_psychiatrist,
                'hasDiagnosisHistory' : patient.has_diagnosis_history,
                'diagnosisHistory' : patient.diagnosis_history,
                'isPsychiatricallyHospitalized' : patient.is_psychiatrically_hospitalized,
                'is72HourMentallyDetentionOrder' : patient.is_72_hour_mentally_detention_order,
                'hasDetainedMentalHealth' : patient.has_detained_mental_health,
                'numberOfMentallyDetained' : patient.number_of_mentally_detained,
                'detainedMentalHealthTreatment' : patient.detained_mental_health_treatment,
                'hasSeekingHelp' : patient.has_seeking_help,
                'seekingHelp' : patient.seeking_help,
                
                # ✅ Past personal history
                'isPlannedPregnancy' : patient.is_planned_pregnancy,
                'isMaternalSubstanceUseDuringPregnancy' : patient.is_maternal_substance_use_during_pregnancy,
                'isBirthDelayed' : patient.is_birth_delayed,
                'isBirthInduced' : patient.is_birth_induced,
                'isBirthHypoxia' : patient.is_birth_hypoxia,
                'isImmediatePostNatalComplications' : patient.is_immediate_post_natal_complications,
                'isRequireOxygenOrIncubator' : patient.is_require_oxygen_or_incubator,
                'isFeedWellAsNewborn' : patient.is_feed_well_as_newborn,
                'isSleepWellAsNewborn' : patient.is_sleep_well_as_newborn,
                
                # ✅ Past family history
                'hasFamilyMentalHealthHistory' : patient.has_family_mental_health_history,
                'familyRelationshipDetails' : patient.family_relationship_details,
                'familyMentalHealthCondition' : patient.family_mental_health_condition,
                'hasBeenHospitalizedForMentalHealth' : patient.has_been_hospitalized_for_mental_health,
                'numberOfAdmissions' : patient.number_of_admissions,
                'duration' : patient.duration,
                'outcome' : patient.outcome,
                
                'hasFamilyMentalHealthHistory': patient.has_family_history,
                'hasADLDifficulty': patient.has_activities_of_daily_living,
                'pastDrugHistory': patient.medication_history,  # assuming same as medication history
                'pastPsychiatricHistory': None,  # not in model yet
                'personalHistory': None,
                'activitiesOfDailyLiving': None,
                'depressiveIllness': None,
                'feelLowFrequency': None,
                'moodLevel': patient.mood_scale,
                'selfEsteemLevel': None,
                'cryToggle': None,
                'cryFrequency': None,
                'suicidalToggle': None,
                'suicidalFrequency': None,
                'notWantToBeHereToggle': None,
                'notWantToBeHereFrequency': None,
                'isWorthLiving': None,
                'isEndingLife': None,
                'isEndingThoughts': None,
                'lifeEndingThoughts': None,
                'isInjured': None,
                'injuredDetails': None,
                'admittedToHospital': None,
                'admittedToHospitalDetails': None,
                'selfHarmed': None,
                'selfHarmedDetails': None,
                'acquiredInjury': None,
                'acquiredInjuryDetails': None,
                'blameYourself': None,
                'blameYourselfDetails': None,
                'moodRelatedQuestions': None,
                'endingYourLifeRelatedQuestions': None,
                'abnormalBehaviorsRelatedQuestions': None,
                'believesInSpecialPurposeRelatedQuestions': None,
                'overlyHappy': None,
                'selectedAngerLevel': None,
                'selectedAgitatedLevel': None,
                'selectedFeelLow': None,
                'selectedFeelElated': None,
                'selectedCategory': patient.selected_category,
                'moodScale': patient.mood_scale,
                'moodAffectLife': patient.mood_affect_life,
                'extremeEnergy': patient.extreme_energy,
                'recklessSpending': patient.reckless_spending,
                'alcoholDrugUse': patient.alcohol_drug_use,
                'medicalConditionMoodCause': patient.medical_condition_mood_cause,
                'imagePath': patient.image_path,
                'createdAt': patient.created_at.isoformat() if patient.created_at else None,
                'updatedAt': patient.updated_at.isoformat() if patient.updated_at else None,
            })

        return jsonify({'success': True, 'patients': patients_data}), 200

    except Exception as e:
        print(f'❌ Error in fetch_patients: {e}')
        return jsonify({'success': False, 'message': 'Internal server error'}), 500


@patient_bp.route('/update_patient_history/<int:patient_id>', methods=['PUT'])
def update_patient_history(patient_id):
    data = request.get_json()

    patient = Patient.query.get_or_404(patient_id)

    try:
        for key, value in data.items():
            if hasattr(patient, key):
                setattr(patient, key, value)
            else:
                print(f"⚠️ Unknown field: {key} ignored")

        db.session.commit()
        return jsonify({'success': True, 'message': 'Patient history updated successfully'}), 200

    except Exception as e:
        print(f"❌ Exception in updating patient history: {e}")
        db.session.rollback()
        return jsonify({'success': False, 'message': f'Update failed: {str(e)}'}), 500
