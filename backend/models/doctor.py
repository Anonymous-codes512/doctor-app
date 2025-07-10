from datetime import datetime
from extensions import db
from utils.enum import Gender
from models.associations import doctor_patient

class Doctor(db.Model):
    __tablename__ = 'doctors'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), unique=True, nullable=False)

    date_of_birth = db.Column(db.Date, nullable=True)
    gender = db.Column(Gender, nullable=True)
    address = db.Column(db.String(200), nullable=True)
    image_path = db.Column(db.String(200), nullable=True)

    specialization = db.Column(db.String(100), nullable=True)
    blood_group = db.Column(db.String(100), nullable=True)
    sub_specialization = db.Column(db.String(100), nullable=True)
    years_of_experience = db.Column(db.String(100), nullable=True)
    qualification = db.Column(db.String(100), nullable=True)
    registration_number = db.Column(db.String(100), nullable=True)
    practice_name = db.Column(db.String(100), nullable=True)
    practice_address = db.Column(db.String(100), nullable=True)
    initial_consultation_fee = db.Column(db.Float, nullable=True)
    session_type = db.Column(db.String(100), nullable=True)
    session_duration = db.Column(db.String(100), nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    user = db.relationship('User', back_populates='doctor')
    patients = db.relationship('Patient', secondary=doctor_patient, back_populates='doctors')
    appointments_as_doctor = db.relationship('Appointment', back_populates='doctor', foreign_keys='Appointment.doctor_id')
    tasks = db.relationship('Task', back_populates='doctor', foreign_keys='Task.doctor_id')


