from datetime import datetime
from extensions import db

class Report(db.Model):
    __tablename__ = 'reports'

    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctor.id'), nullable=False)
    report_name = db.Column(db.String(100), nullable=False)
    report_type = db.Column(db.String(50), nullable=False)
    report_date = db.Column(db.String(50), nullable=False)
    report_time = db.Column(db.String(50), nullable=False)
    file_url = db.Column(db.String(200), nullable=False)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    doctor = db.relationship('Doctor', back_populates='reports')
    patient = db.relationship('Patient', back_populates='reports')
    payment = db.relationship('Payment', back_populates='report', uselist=False)
