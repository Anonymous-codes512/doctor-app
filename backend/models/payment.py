from datetime import datetime
from extensions import db

class Payment(db.Model):
    __tablename__ = 'payments'
    
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctor.id'), nullable=False)
    report_id = db.Column(db.Integer, db.ForeignKey('reports.id'), nullable=False)
    amount = db.Column(db.Float, nullable=False)
    status = db.Column(db.String(20), nullable=False)  # Paid/Unpaid
    method = db.Column(db.String(20), nullable=False)  # Cash/Card/Online

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    doctor = db.relationship('Doctor', back_populates='payments')
    patient = db.relationship('Patient', back_populates='payments')
    report = db.relationship('Report', back_populates='payment')
    invoice = db.relationship('Invoice', back_populates='payment', uselist=False)
