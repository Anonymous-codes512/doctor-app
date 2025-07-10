from dateutil import parser
import os
from flask import request, jsonify, Blueprint
from werkzeug.utils import secure_filename
from flask_jwt_extended import jwt_required
from utils.enum import Gender
from models.note import Note
from models.doctor import Doctor
from extensions import db
from models.patient import Patient
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError


doctor_bp = Blueprint('doctor', __name__, url_prefix='/api')

UPLOAD_FOLDER = 'static/uploads/doctors'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@doctor_bp.route('/create_note', methods=['POST'])
def create_note():
    try:
        data = request.get_json()

        # ✅ Step 1: Validate input
        required_fields = ['patient_id', 'doctor_user_id', 'notes_title', 'notes_description', 'date']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'success': False, 'message': f'{field} is required'}), 400

        patient_id = data['patient_id']
        doctor_user_id = data['doctor_user_id']

        # ✅ Step 2: Check if doctor exists
        doctor = Doctor.query.filter_by(user_id=doctor_user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': 'Doctor not found'}), 404

        # ✅ Step 3: Check if patient exists
        patient = Patient.query.get(patient_id)
        if not patient:
            return jsonify({'success': False, 'message': 'Patient not found'}), 404

        # ✅ Step 4: Parse date safely
        try:
            note_date = datetime.strptime(data['date'], '%B %d, %Y')  # e.g., "June 23, 2025"
        except ValueError:
            return jsonify({'success': False, 'message': 'Invalid date format. Use "Month DD, YYYY"'}), 400

        # ✅ Step 5: Create and save the note
        new_note = Note(
            notes_title=data['notes_title'],
            notes_description=data['notes_description'],
            date=note_date,
            doctor_id=doctor.id,
            patient_id=patient.id
        )
        db.session.add(new_note)
        db.session.commit()

        return jsonify({'success': True, 'message': 'Note created successfully'}), 201

    except SQLAlchemyError as db_err:
        db.session.rollback()
        print(f'Database Error: {db_err}')
        return jsonify({'success': False, 'message': 'Database error'}), 500

    except Exception as e:
        print(f'Unexpected Error: {e}')
        return jsonify({'success': False, 'message': 'Internal server error'}), 500

@doctor_bp.route('/fetch_doctor/<int:user_id>', methods=['GET'])
@jwt_required()
def fetch_doctor(user_id):
    try:
        doctor = Doctor.query.filter_by(user_id=user_id).first()

        if not doctor or not doctor.user:
            return jsonify({'success': False, 'message': 'Doctor not found'}), 404

        user = doctor.user

        doctor_data = {
            'id': doctor.id,
            'doctorUserId': user.id,
            'fullName': user.name,
            'email': user.email,
            'contact': user.phone_number,
            'gender': doctor.gender,
            'dateOfBirth': doctor.date_of_birth.strftime('%Y-%m-%d') if doctor.date_of_birth else None,
            'bloodGroup': doctor.blood_group,
            'specialization': doctor.specialization,
            'subSpecialization': doctor.sub_specialization,
            'yearsOfExperience': doctor.years_of_experience,
            'qualification': doctor.qualification,
            'registrationNumber': doctor.registration_number,
            'practiceName': doctor.practice_name,
            'practiceAddress': doctor.practice_address,
            'initialConsultationFee': doctor.initial_consultation_fee,
            'sessionType': doctor.session_type,
            'sessionDuration': doctor.session_duration,
            'imagePath': doctor.image_path,
        }

        return jsonify({'success': True, 'doctor': doctor_data})

    except Exception as e:
        print(f"❌ Error fetching doctor: {e}")
        return jsonify({'success': False, 'message': 'Server error while fetching doctor'}), 500

@doctor_bp.route('/upload_doctor_image', methods=['POST'])
@jwt_required()
def upload_image():
    if 'image' not in request.files:
        return jsonify({'success': False, 'message': 'No image part'}), 400

    image = request.files['image']
    if image.filename == '':
        return jsonify({'success': False, 'message': 'No selected file'}), 400

    try:
        filename = secure_filename(image.filename)
        image_path = os.path.join(UPLOAD_FOLDER, filename)
        image.save(image_path)

        # Ensure URL has proper folder path
        image_url = image_path
        return jsonify({'success': True, 'image_url': image_url})
        
    except Exception as e:
        print(f'❌ Error saving image: {e}')
        return jsonify({'success': False, 'message': 'Failed to upload image'}), 500
    
@doctor_bp.route('/update_doctor', methods=['PUT'])
@jwt_required()
def update_doctor():
    try:
        data = request.get_json()
        required_fields = ['doctorUserId', 'fullName']

        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'success': False, 'message': f'Missing field: {field}'}), 400

        # Get doctor + user
        doctor = Doctor.query.filter_by(user_id=data['doctorUserId']).first()
        if not doctor or not doctor.user:
            return jsonify({'success': False, 'message': 'Doctor not found'}), 404

        user = doctor.user

        # ✅ Update user info (excluding email)
        user.name = data.get('fullName')
        user.phone_number = data.get('contact')

        # ✅ Update doctor info
        doctor.blood_group = data.get('bloodGroup')
        doctor.specialization = data.get('specialization')
        doctor.sub_specialization = data.get('subSpecialization')
        doctor.years_of_experience = data.get('yearsOfExperience')
        doctor.qualification = data.get('qualification')
        doctor.registration_number = data.get('registrationNumber')
        doctor.practice_name = data.get('practiceName')
        doctor.practice_address = data.get('practiceAddress')
        doctor.initial_consultation_fee = data.get('initialConsultationFee')
        doctor.session_type = data.get('sessionType')
        doctor.session_duration = data.get('sessionDuration')
        doctor.image_path = data.get('imagePath')

        # ✅ Parse & validate gender
        gender_str = data.get('gender')
        if gender_str:
            gender_str = gender_str.lower()
            if gender_str not in Gender.enums:
                return jsonify({'success': False, 'message': 'Invalid gender'}), 400
            doctor.gender = gender_str

        # ✅ Parse & validate date_of_birth
        dob_str = data.get('dateOfBirth')
        if dob_str:
            try:
                parsed_dob = parser.parse(dob_str).date()
                doctor.date_of_birth = parsed_dob
            except (ValueError, TypeError):
                return jsonify({'success': False, 'message': 'Invalid date format'}), 400

        db.session.commit()
        return jsonify({'success': True, 'message': 'Doctor profile updated successfully'})

    except Exception as e:
        db.session.rollback()
        print(f"❌ Error updating doctor: {e}")
        return jsonify({'success': False, 'message': 'Server error'}), 500

@doctor_bp.route('/update_note/<int:note_id>', methods=['PUT'])
def update_note(note_id):
    try:
        data = request.get_json()

        # ✅ Validate input fields
        required_fields = ['patient_id', 'doctor_user_id', 'notes_title', 'notes_description', 'date']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'success': False, 'message': f'{field} is required'}), 400

        patient_id = data['patient_id']
        doctor_user_id = data['doctor_user_id']

        # ✅ Check if doctor exists
        doctor = Doctor.query.filter_by(user_id=doctor_user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': 'Doctor not found'}), 404

        # ✅ Check if patient exists
        patient = Patient.query.get(patient_id)
        if not patient:
            return jsonify({'success': False, 'message': 'Patient not found'}), 404

        # ✅ Find the existing note
        note = Note.query.get(note_id)
        if not note:
            return jsonify({'success': False, 'message': 'Note not found'}), 404

        # ✅ Parse and format date
        try:
            parsed_date = datetime.strptime(data['date'], '%B %d, %Y')  # e.g., "June 23, 2025"
        except ValueError:
            return jsonify({'success': False, 'message': 'Invalid date format. Use "Month DD, YYYY"'}), 400

        # ✅ Update fields
        note.notes_title = data['notes_title']
        note.notes_description = data['notes_description']
        note.date = parsed_date
        note.doctor_id = doctor.id
        note.patient_id = patient.id

        db.session.commit()

        return jsonify({'success': True, 'message': 'Note updated successfully'}), 200

    except SQLAlchemyError as db_err:
        db.session.rollback()
        print(f'Database Error: {db_err}')
        return jsonify({'success': False, 'message': 'Database error'}), 500

    except Exception as e:
        print(f'Unexpected Error: {e}')
        return jsonify({'success': False, 'message': 'Internal server error'}), 500


@doctor_bp.route('/fetch_notes', methods=['GET'])
def fetch_notes():
    try:
        patient_id = request.args.get('patient_id', type=int)
        doctor_user_id = request.args.get('doctor_user_id', type=int)

        # ✅ Validate presence
        if not patient_id or not doctor_user_id:
            return jsonify({'success': False, 'message': 'Both patient_id and doctor_user_id are required'}), 400

        # ✅ Validate doctor
        doctor = Doctor.query.filter_by(user_id=doctor_user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': 'Doctor not found'}), 404

        # ✅ Validate patient
        patient = Patient.query.get(patient_id)
        if not patient:
            return jsonify({'success': False, 'message': 'Patient not found'}), 404

        # ✅ Fetch notes for the given doctor and patient
        notes = Note.query.filter_by(doctor_id=doctor.id, patient_id=patient.id).all()

        # ✅ Serialize notes
        notes_list = [{
            'note_id': note.id,
            'notes_title': note.notes_title,
            'notes_description': note.notes_description,
            'date': note.date.strftime('%B %d, %Y'),
            'doctor_user_id': doctor_user_id,
            'patient_id': patient_id
        } for note in notes]

        return jsonify({'success': True, 'notes': notes_list}), 200

    except Exception as e:
        print(f'❌ Unexpected error in fetch_notes: {e}')
        return jsonify({'success': False, 'message': 'Internal server error'}), 500