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
        # Corrected: Removed exc_info=True as it's not valid for print()
        print(f'❌ Error in create_patient: {e}')
        # If you still want a full traceback, you can import sys and use traceback.print_exc()
        # import traceback
        # traceback.print_exc() # This will print the full traceback to stderr
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

            # ✅ Fetch notes for this doctor-patient pair
            notes = Note.query.filter_by(
                doctor_id=doctor.id,
                patient_id=patient.id
            ).all()

            notes_data = []
            for note in notes:
                notes_data.append({
                    'note_id': note.id,
                    'doctor_user_id': doctor.user_id,  # use `user_id`, not `id`
                    'patient_id': patient.id,
                    'notes_title': note.notes_title,
                    'notes_description': note.notes_description,
                    'date': note.date.isoformat(),
                })

            patients_data.append({
                'id': patient.id,
                'fullName': user.name,
                'email': user.email,
                'phoneNumber': user.phone_number,
                'address': patient.address,
                'weight': patient.weight,
                'height': patient.height,
                'bloodPressure': patient.blood_pressure,
                'pulse': patient.pulse,
                'allergies': patient.allergies,
                'gender': patient.gender if patient.gender else None,
                'dateOfBirth': patient.date_of_birth.isoformat() if patient.date_of_birth else None,
                'imagePath': getattr(patient, 'image_path', None),
                'notes': notes_data  # ✅ Add notes here
            })

        return jsonify({'success': True, 'patients': patients_data}), 200

    except Exception as e:
        print(f'❌ Error in fetch_patients: {e}')
        return jsonify({'success': False, 'message': 'Internal server error'}), 500

