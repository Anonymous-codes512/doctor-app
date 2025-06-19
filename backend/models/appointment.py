from datetime import datetime
from extensions import db
from utils.enum import AppointmentMode, AppointmentStatus, AppointmentReason, PaymentMode

class Appointment(db.Model):
    __tablename__ = 'appointments'

    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctors.id'), nullable=False)  # ✅

    appointment_date = db.Column(db.Date, nullable=False)
    appointment_time = db.Column(db.Time, nullable=False)
    appointment_mode = db.Column(AppointmentMode, nullable=False)
    status = db.Column(AppointmentStatus, nullable=False)
    duration = db.Column(db.Integer, nullable=True)
    reason = db.Column(AppointmentReason, nullable=False)
    fee = db.Column(db.Numeric(10, 2), nullable=False)
    payment_mode = db.Column(PaymentMode, nullable=False)
    description = db.Column(db.Text, nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    patient = db.relationship('Patient', back_populates='appointments')
    doctor = db.relationship('Doctor', back_populates='appointments_as_doctor')