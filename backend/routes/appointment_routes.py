from flask import request, jsonify, Blueprint
from datetime import datetime
from models import Appointment, Patient, User, Doctor
from extensions import db
from sqlalchemy.exc import IntegrityError
from utils.enum import AppointmentMode, AppointmentStatus, AppointmentReason, PaymentMode

appointment_bp = Blueprint('appointment', __name__, url_prefix='/api')

@appointment_bp.route('/create_appointment', methods=['POST'])
def createAppointment():
    data = request.get_json()

    required_fields = ['doctor_id', 'patient_name', 'appointment_date', 'appointment_time', 'mode', 'reason', 'fee', 'payment_mode']
    missing_fields = [f for f in required_fields if f not in data]
    if missing_fields:
        return jsonify({'success': False, 'message': f'Missing required fields: {", ".join(missing_fields)}'}), 400

    # Parse and validate date
    try:
        appointment_date = datetime.strptime(data['appointment_date'], '%Y-%m-%d').date()
    except ValueError:
        return jsonify({'success': False, 'message': 'Invalid appointment_date format, expected YYYY-MM-DD'}), 400

    # Parse and validate time
    try:
        appointment_time = datetime.strptime(data['appointment_time'], '%H:%M').time()
    except ValueError:
        return jsonify({'success': False, 'message': 'Invalid appointment_time format, expected HH:MM (24-hour)'}), 400

    # Validate fee
    try:
        fee = float(data['fee'])
        if fee < 0:
            raise ValueError()
    except (ValueError, TypeError):
        return jsonify({'success': False, 'message': 'Invalid fee, must be a positive number'}), 400

    patient_name = data['patient_name'].strip()
    if not patient_name:
        return jsonify({'success': False, 'message': 'Patient name cannot be empty'}), 400

    doctor = Doctor.query.filter_by(user_id=data['doctor_id']).first()
    if not doctor:
        return jsonify({'success': False, 'message': f'Doctor with user ID {data["doctor_id"]} not found'}), 400

    patient = Patient.query.join(Patient.user).filter(User.name == patient_name).first()
    try:
        appointment_mode = get_enum_value(AppointmentMode, data['mode'])
        payment_mode = get_enum_value(PaymentMode, data['payment_mode'])
        reason = get_enum_value(AppointmentReason, data['reason'])
        status = 'confirmed'
    except ValueError as e:
        return jsonify({'success': False, 'message': str(e)}), 400

    try:
        appointment = Appointment(
            doctor_id=doctor.id,
            patient_id=patient.id if patient else 1,
            appointment_date=appointment_date,
            appointment_time=appointment_time,
            appointment_mode=appointment_mode,
            duration= data['duration'],
            status=status,
            reason=reason,
            fee=fee,
            payment_mode=payment_mode,
            description=data.get('description')
        )
        db.session.add(appointment)
        db.session.commit()

        return jsonify({'success': True, 'message': 'Appointment created successfully', 'appointment_id': appointment.id}), 201

    except IntegrityError as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': 'Database integrity error', 'error': str(e)}), 400

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': 'Failed to create appointment', 'error': str(e)}), 500

@appointment_bp.route('/doctor_appointments/<int:user_id>', methods=['GET'])
def get_doctor_appointments(user_id):
    try:
        # Step 1: Find Doctor by user_id
        doctor = Doctor.query.filter_by(user_id=user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': f'Doctor not found for user_id: {user_id}'}), 404

        # Step 2: Fetch appointments for this doctor
        appointments = Appointment.query.filter_by(doctor_id=doctor.id).all()
        if not appointments:
            return jsonify({'success': True, 'appointments': [], 'message': 'No appointments found'}), 200

        # Step 3: Prepare response list
        result = []
        for appt in appointments:
            patient_name = ''
            if appt.patient and appt.patient.user:
                patient_name = appt.patient.user.name

            result.append({
                'id': appt.id,
                'doctor_id': appt.doctor_id,
                'patient_name': patient_name,
                'duration': appt.duration,
                'reason': appt.reason,
                'mode': appt.appointment_mode,
                'fee': float(appt.fee),
                'payment_mode': appt.payment_mode,
                'description': appt.description,
                'appointment_date': appt.appointment_date.strftime('%Y-%m-%d') if appt.appointment_date else None,
                'appointment_time': appt.appointment_time.strftime('%H:%M') if appt.appointment_time else None,
            })

        return jsonify({'success': True, 'appointments': result}), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': 'Internal server error',
            'error': str(e)
        }), 500


def get_enum_value(enum_type, value):
    try:
        val = value.lower()
        if val in enum_type.enums:
            return val
        else:
            raise ValueError(f"Invalid enum value '{value}' for {enum_type.name}")
    except Exception as e:
        raise e