from flask import request, jsonify, Blueprint
from datetime import datetime
from models import Appointment, Patient, User, Doctor, Invoice
from extensions import db
from sqlalchemy.exc import IntegrityError
from utils.enum import AppointmentMode, AppointmentStatus, AppointmentReason, PaymentMode

appointment_bp = Blueprint('appointment', __name__, url_prefix='/api')

@appointment_bp.route('/create_appointment', methods=['POST'])
def createAppointment():
    data = request.get_json()

    required_fields = ['doctor_id', 'patient_name', 'patient_email', 'appointment_date', 'appointment_time', 'mode', 'reason', 'fee', 'payment_mode', 'duration']
    missing_fields = [f for f in required_fields if f not in data]
    if missing_fields:
        return jsonify({'success': False, 'message': f'Missing required fields: {", ".join(missing_fields)}'}), 400

    try:
        appointment_date = datetime.strptime(data['appointment_date'], '%Y-%m-%d').date()
        appointment_time = datetime.strptime(data['appointment_time'], '%H:%M').time()
        fee = float(data['fee'])
        if fee < 0:
            raise ValueError()
    except ValueError:
        return jsonify({'success': False, 'message': 'Invalid date, time, or fee format'}), 400

    patient_name = data['patient_name'].strip()
    patient_email = data['patient_email'].strip().lower()

    if not patient_name or not patient_email:
        return jsonify({'success': False, 'message': 'Patient name and email cannot be empty'}), 400

    doctor = Doctor.query.filter_by(user_id=data['doctor_id']).first()
    if not doctor:
        return jsonify({'success': False, 'message': f'Doctor with user ID {data["doctor_id"]} not found'}), 400

    # Check if user (patient) exists
    user = User.query.filter_by(email=patient_email).first()
    if not user:
        username = patient_name.replace(" ", "").lower()
        user = User(
            name=patient_name,
            email=patient_email,
            role='PATIENT',
            password=f"{username}1234"
        )
        db.session.add(user)
        db.session.flush()

        patient = Patient(user_id=user.id)
        db.session.add(patient)
        db.session.flush()

        doctor.patients.append(patient)
    else:
        patient = Patient.query.filter_by(user_id=user.id).first()
        if not patient:
            patient = Patient(user_id=user.id)
            db.session.add(patient)
            db.session.flush()

        if patient not in doctor.patients:
            doctor.patients.append(patient)

    try:
        appointment_mode = get_enum_value(AppointmentMode, data['mode'])
        payment_mode = get_enum_value(PaymentMode, data['payment_mode'])
        reason = get_enum_value(AppointmentReason, data['reason'])
    except ValueError as e:
        return jsonify({'success': False, 'message': str(e)}), 400

    try:
        # Create appointment
        appointment = Appointment(
            doctor_id=doctor.id,
            patient_id=patient.id,
            appointment_date=appointment_date,
            appointment_time=appointment_time,
            appointment_mode=appointment_mode,
            duration=data['duration'],
            status='confirmed',
            reason=reason,
            fee=fee,
            payment_mode=payment_mode,
            description=data.get('description')
        )
        db.session.add(appointment)
        db.session.flush()

        # Fetch last global invoice and generate next invoice number
        last_invoice = Invoice.query.order_by(Invoice.id.desc()).first()
        if last_invoice and last_invoice.invoice_number.startswith("INV-"):
            last_number = int(last_invoice.invoice_number.split('-')[1])
            new_invoice_number = f"INV-{last_number + 1:03d}"
        else:
            new_invoice_number = "INV-001"

        # Create invoice
        invoice = Invoice(
            patient_id=patient.id,
            invoice_number=new_invoice_number,
            amount_due=fee,
            due_date=appointment_date,
            payment_status='Pending'
        )
        db.session.add(invoice)
        db.session.commit()

        return jsonify({
            'success': True,
            'message': 'Appointment and invoice created successfully',
            'appointment_id': appointment.id,
            'invoice_number': new_invoice_number
        }), 201

    except IntegrityError as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': 'Database integrity error', 'error': str(e)}), 400

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': 'Failed to create appointment', 'error': str(e)}), 500

@appointment_bp.route('/doctor_appointments/<int:user_id>', methods=['GET'])
def get_doctor_appointments(user_id):
    try:
        doctor = Doctor.query.filter_by(user_id=user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': f'Doctor not found for user_id: {user_id}'}), 404

        appointments = Appointment.query.filter_by(doctor_id=doctor.id).all()
        if not appointments:
            return jsonify({'success': True, 'appointments': [], 'message': 'No appointments found'}), 200

        result = []
        for appt in appointments:
            patient_name = ''
            patient_email = ''
            if appt.patient and appt.patient.user:
                patient_name = appt.patient.user.name
                patient_email = appt.patient.user.email

            result.append({
                'id': appt.id,
                'doctor_id': appt.doctor_id,
                'patient_id': appt.patient_id,
                'patient_name': patient_name,
                'patient_email': patient_email,
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