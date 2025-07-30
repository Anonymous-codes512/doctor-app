from datetime import datetime
from extensions import db

class HealthTracker(db.Model):
    __tablename__ = 'health_tracker'

    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctors.id'), nullable=False)
    weight = db.Column(db.Numeric(5,2), nullable=True)
    height = db.Column(db.Numeric(5,2), nullable=True)
    BMI = db.Column(db.Numeric(5,2), nullable=True)
    blood_pressure = db.Column(db.String(20), nullable=True)
    pulse_rate = db.Column(db.Integer, nullable=True)
    steps_count = db.Column(db.Integer, nullable=True)
    calories_burned = db.Column(db.Integer, nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    patient = db.relationship('Patient', back_populates='health_records')
    doctor = db.relationship('Doctor', back_populates='health_records')