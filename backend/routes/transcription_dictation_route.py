from datetime import datetime
import os
from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required
from werkzeug.utils import secure_filename
import whisper
from models.doctor import Doctor
from models.patient import Patient
from utils.pdf_helper import generate_dictation_pdf
from models.dictation import Dictation
from extensions import db


transcribe_bp = Blueprint('transcribe', __name__, url_prefix='/api')

UPLOAD_FOLDER = 'static/uploads'
UPLOAD_TRANSCRIPTION_FOLDER = 'static/uploads/transcriptions'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

model = whisper.load_model("small")

@transcribe_bp.route('/send_audio_file_for_transcription', methods=['POST'])
def transcribe_audio():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    file = request.files['file']
    filename = secure_filename(file.filename)
    file_path = os.path.join(UPLOAD_FOLDER, filename)
    file.save(file_path)
    # 🔎 Check file size
    size = os.path.getsize(file_path)
    print(f"📦 Saved file: {file_path} ({size} bytes)")
    if size == 0:
        return jsonify({'error': 'Empty audio file'}), 400
    
    try:
        result = model.transcribe(file_path , language='en')
        print(result)
        os.remove(file_path)
        return jsonify({'text': result['text']})
    except Exception as e:
        print("❌ Error during transcription:", e)
        return jsonify({'error': str(e)}), 500

@transcribe_bp.route('/save_new_transcripted_dictation', methods=['POST'])
@jwt_required()
def saveTranscription():
    try:
        data = request.get_json()

        patient_id = data['patient_id']
        doctor_user_id = data['doctorUserId']
        dictation_text = data['dictation_text']
        file_name = data['fileName']
        date = data['date']
        time = data['time']

        # ✅ Validate doctor and patient
        doctor = Doctor.query.get(doctor_user_id)
        if not doctor:
            return jsonify({
                'success' : False,
                'message': 'Doctor not found'
            }), 404

        patient = Patient.query.get(patient_id)
        if not patient:
            return jsonify({
                'success' : False,
                'message': 'Patient not found'
            }), 404

        # ✅ Generate PDF using helper
        file_path = generate_dictation_pdf(
            file_name=file_name,
            doctor_name=doctor.user.name,
            doctor_email=doctor.user.email,
            doctor_practice=doctor.practice_name,  # 🔧 fixed typo here
            doctor_practice_address=doctor.practice_address,
            patient_name=patient.user.name,
            patient_email=patient.user.email,
            date=date,
            time=time,
            dictation_text=dictation_text,
        )

        # ✅ Save metadata to DB
        new_dictation = Dictation(
            patient_id=patient_id,
            doctor_id=doctor.id,
            file_name=file_name,
            file_path=file_path,
            date=date,
            time=time,
        )
        db.session.add(new_dictation)
        db.session.commit()

        return jsonify({
            'success' : True,
            'message': 'Dictation saved successfully as PDF',
            'file_path': file_path
        }), 201

    except Exception as e:
        print("❌ Error saving dictation:", e)
        return jsonify({
            'success' : False,
            'message': 'Something went wrong',
            'details': str(e)
        }), 500


@transcribe_bp.route('/fetch_dictations/<int:user_id>/<int:patient_id>', methods=['GET'])
@jwt_required()
def fetchTranscription(user_id, patient_id):
    try:
        doctor = Doctor.query.filter_by(user_id=user_id).first()
        if not doctor:
            return jsonify({'error': '❌ Doctor not found'}), 404

        patient = Patient.query.get(patient_id)
        if not patient:
            return jsonify({'error': '❌ Patient not found'}), 404

        # 📂 Fetch matching dictations
        dictations = Dictation.query.filter_by(
            doctor_id=doctor.id,
            patient_id=patient_id
        ).order_by(Dictation.id.desc()).all()


        result = [{
            'fileName': d.file_name,
            'date': d.date,
            'time': d.time,
            'fileUrl': d.file_path
        } for d in dictations]

        return jsonify({'message': 'Dictations fetched', 'dictations': result}), 200

    except Exception as e:
        print("❌ Error fetching dictations:", e)
        return jsonify({'error': 'Something went wrong', 'details': str(e)}), 500
    
    