import os
from flask import request, jsonify, Blueprint
from werkzeug.utils import secure_filename
from models.doctor import Doctor
from extensions import db
from models.user import User
from models.patient import Patient
from utils.enum import Gender
from datetime import datetime
from models.patient import doctor_patient  # Import the association table

patient_bp = Blueprint('patient', __name__, url_prefix='/api')

UPLOAD_FOLDER = 'static/uploads/patients'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@patient_bp.route('/create_patient', methods=['POST'])
def create_patient():
    try:
        # ✅ Upload Image
        image = request.files.get('image')
        image_path = None
        if image:
            filename = secure_filename(image.filename)
            image_path = os.path.join(UPLOAD_FOLDER, filename)
            image.save(image_path)

        # ✅ Extract form-data fields
        full_name = request.form.get('fullName')
        email = request.form.get('email')
        contact = request.form.get('contact')
        date_of_birth = request.form.get('dateOfBirth')
        gender = request.form.get('gender')
        allergies = request.form.get('allergies')
        address = request.form.get('address')
        doctor_user_id = request.form.get('doctorUserId')  # new field
        password = f'{full_name} 1234'

        # ✅ Validation: Required fields
        if not full_name or not email or not contact or not doctor_user_id:
            return jsonify({'success': False, 'message': 'Name, email, contact & doctor ID are required.'}), 400

        # ✅ Gender Validation
        allowed_genders = ['male', 'female', 'other']
        if gender and gender not in allowed_genders:
            return jsonify({'success': False, 'message': f"Invalid gender. Allowed: {allowed_genders}"}), 400

        # ✅ Convert Date
        dob = datetime.fromisoformat(date_of_birth).date() if date_of_birth else None

        # ✅ Get Doctor
        doctor = Doctor.query.filter_by(user_id=int(doctor_user_id)).first()
        if not doctor:
            return jsonify({'success': False, 'message': 'Doctor not found.'}), 404

        # ✅ Create User
        new_user = User(
            name=full_name,
            email=email,
            phone_number=contact,
            role='PATIENT',
            password=password,
        )
        db.session.add(new_user)
        db.session.flush()

        # ✅ Create Patient
        new_patient = Patient(
            user_id=new_user.id,
            date_of_birth=dob,
            gender=Gender(gender) if gender else None,
            allergies=allergies,
            address=address,
            image_path=image_path 
        )
        db.session.add(new_patient)
        db.session.flush()  # Get patient.id

        # ✅ Associate Doctor ↔ Patient
        insert_stmt = doctor_patient.insert().values(
            doctor_id=doctor.id,
            patient_id=new_patient.id
        )
        db.session.execute(insert_stmt)
        db.session.commit()

        return jsonify({'success': True, 'message': 'Patient added and linked to doctor.'}), 201

    except Exception as e:
        db.session.rollback()
        print(f'❌ Error in create_patient: {e}')
        return jsonify({'success': False, 'message': 'Internal server error.'}), 500

@patient_bp.route('/fetch_patients/<int:user_id>', methods=['GET'])
def fetch_patients(user_id):
    try:
        # ✅ Step 1: Get Doctor by user_id
        doctor = Doctor.query.filter_by(user_id=user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': 'Doctor not found'}), 404

        # ✅ Step 2: Get patients linked via doctor_patient table
        patients = (
            db.session.query(Patient)
            .join(doctor_patient, doctor_patient.c.patient_id == Patient.id)
            .filter(doctor_patient.c.doctor_id == doctor.id)
            .all()
        )

        patients_data = []
        for patient in patients:
            user = User.query.get(patient.user_id)
            patients_data.append({
                'id': patient.id,
                'fullName': user.name,
                'email': user.email,
                'phoneNumber': user.phone_number,
                'address': patient.address,
                'gender': patient.gender.value if patient.gender else None,
                'dateOfBirth': patient.date_of_birth.isoformat() if patient.date_of_birth else None,
                'imagePath': getattr(patient, 'image_path', None),
            })

        return jsonify({'success': True, 'patients': patients_data}), 200

    except Exception as e:
        print(f'❌ Error in fetch_patients: {e}')
        return jsonify({'success': False, 'message': 'Internal server error'}), 500
