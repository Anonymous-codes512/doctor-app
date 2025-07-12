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
        # gender = request.form.get('gender')
        allergies = request.form.get('allergies')
        address = request.form.get('address')
        weight = request.form.get('weight')
        height = request.form.get('height')
        blood_pressure = request.form.get('bloodPressure')
        pulse = request.form.get('pulse')
        doctor_user_id = request.form.get('doctorUserId') # This should be a string at this point
        password = f'{full_name} 1234' # Consider a more secure password generation in production

        if not full_name or not email or not contact or not doctor_user_id:
            missing_fields = []
            if not full_name: missing_fields.append('fullName')
            if not email: missing_fields.append('email')
            if not contact: missing_fields.append('contact')
            if not doctor_user_id: missing_fields.append('doctorUserId')
            print(f"🚫 Missing required fields: {missing_fields}") # Added print for missing fields
            return jsonify({'success': False, 'message': f'Name, email, contact & doctor ID are required. Missing: {", ".join(missing_fields)}'}), 400

        # allowed_genders = ['male', 'female', 'other']
        # if gender and gender not in allowed_genders:
        #     print(f"🚫 Invalid gender received: {gender}") # Added print
        #     return jsonify({'success': False, 'message': f"Invalid gender. Allowed: {allowed_genders}"}), 400

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
            # gender=Gender(gender) if gender else None,
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
                'contact': patient.user.phone_number,
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

                # ✅ Activities of daily living
                'showerAbility' : patient.shower_ability,
                'showerFrequency' : patient.shower_frequency,
                'dressingAbility' : patient.dressing_ability,
                'eatingAbility' : patient.eating_ability,
                'foodType' : patient.food_type,
                'toiletingAbility' : patient.toileting_ability,
                'groomingAbility' : patient.grooming_ability,
                'menstrualManagement' : patient.menstrual_management,
                'householdTasks' : patient.household_tasks,
                'dailyAffairs' : patient.daily_affairs,
                'safetyMobility' : patient.safety_mobility,
              
                # ✅ Mood info  
                'hasDepressiveIllness': patient.has_depressive_illness,
                'depressiveFrequency': patient.depressive_frequency,
                'moodLevel': patient.mood_level,
                'moodWorseInMorning': patient.mood_worse_in_morning,
                'moodConstantlyLow': patient.mood_constantly_low,
                'canSmile': patient.can_smile,
                'canLaugh': patient.can_laugh,
                'hasNormalAppetiteAndEnjoyment': patient.has_normal_appetite_and_enjoyment,
                'enjoymentActivitiesDescription': patient.enjoyment_activities_description,
                'hasCrying': patient.has_crying,
                'cryFrequency': patient.cry_frequency,
                'feelsLifeWorth': patient.feels_life_worth,
                'hasSuicidalThoughts': patient.has_suicidal_thoughts,
                'suicidalFrequency': patient.suicidal_frequency,
                'feelsNotWantToBeHere': patient.feels_not_want_to_be_here,
                'notWantToBeHereFrequency': patient.not_want_to_be_here_frequency,
                'wantToDie': patient.want_to_die,
                'wantToDieFrequency': patient.want_to_die_frequency,
                'hasEndingLifeThoughts': patient.has_ending_life_thoughts,
                'hasTriedEndingLife': patient.has_tried_ending_life,
                'lifeEndingMethodsDetails': patient.life_ending_methods_details,
                'hasInjuries': patient.has_injuries,
                'injuriesDescription': patient.injuries_description,
                'hasHospitalAdmission': patient.has_hospital_admission,
                'hospitalAdmissionDetails': patient.hospital_admission_details,
                'hasSelfHarmed': patient.has_self_harmed,
                'selfHarmedMethods': patient.self_harmed_methods,
                'hasAcquiredInjury': patient.has_acquired_injury,
                'acquiredInjuryDescription': patient.acquired_injury_description,
                'hasGuilt': patient.has_guilt,
                'guiltReason': patient.guilt_reason,
                'bloodVesselDamage': patient.blood_vessel_damage,
                'nerveDamage': patient.nerve_damage,
                'requiredStitches': patient.required_stitches,
                'requiredSurgery': patient.required_surgery,
                'permanentDamageFromSelfHarm': patient.permanent_damage_from_self_harm,
                'hasConfidenceAndSelfEsteem': patient.has_confidence_and_self_esteem,
                'selfEsteemLevel': patient.self_esteem_level,
                'overlyHappyFrequency': patient.overly_happy_frequency,
                'excessivelyFlirty': patient.excessively_flirty,
                'increasedSexDrive': patient.increased_sex_drive,
                'recklessSpending': patient.reckless_spending,
                'undressedInPublic': patient.undressed_in_public,
                'buysBeyondMeans': patient.buys_beyond_means,
                'highRiskActivities': patient.high_risk_activities,
                'inflatedSelfEsteem': patient.inflated_self_esteem,
                'feelsSuperior': patient.feels_superior,
                'believesInPowers': patient.believes_in_powers,
                'feelsWealthyOrGenius': patient.feels_wealthy_or_genius,
                'angerLevel': patient.anger_level,
                'agitationLevel': patient.agitation_level,
                'lowMoodDuration': patient.low_mood_duration,
                'elatedMoodDuration': patient.elated_mood_duration,

                # ✅ Mood Assessment
                'selectedPhysicalSymptom' : patient.selected_physical_symptom,
                'moodLevels' : patient.mood_levels,
                'moodAffectLife' : patient.mood_affect_life,
                'extremeEnergyPeriods' : patient.extreme_energy_periods,
                'recklessSpendingFrequency' : patient.reckless_spending_frequency,
                'isTakingMedications' : patient.is_taking_medications,
                'alcoholDrugUseFrequency' : patient.alcohol_drug_use_frequency,
                'medicalConditions' : patient.medical_conditions,
                
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
