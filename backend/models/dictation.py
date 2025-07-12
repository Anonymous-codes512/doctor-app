from datetime import datetime
from extensions import db
from utils.enum import PaymentStatus


class Dictation(db.Model):
    __tablename__ = 'dictations'

    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctors.id'), nullable=False)
    file_name = db.Column(db.String(255), nullable=False)
    file_path = db.Column(db.Text, nullable=False)
    date = db.Column(db.String(10), nullable=False)
    time = db.Column(db.String(10), nullable=False)
    created_at = db.Column(db.DateTime, server_default=db.func.now())

    patient = db.relationship('Patient', back_populates='dictations')
    doctor = db.relationship('Doctor', back_populates='dictations')
