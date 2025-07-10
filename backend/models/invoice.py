from datetime import datetime
from extensions import db
from utils.enum import PaymentStatus

class Invoice(db.Model):
    __tablename__ = 'invoices'

    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctor.id'), nullable=False)
    payment_id = db.Column(db.Integer, db.ForeignKey('payments.id'), nullable=False)
    
    invoice_number = db.Column(db.String(50), unique=True, nullable=False)
    amount_due = db.Column(db.Numeric(10, 2), nullable=False)
    due_date = db.Column(db.Date, nullable=False)
    payment_status = db.Column(PaymentStatus, nullable=False)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    patient = db.relationship('Patient', back_populates='invoices')
    doctor = db.relationship('Doctor', back_populates='invoices')
    payment = db.relationship('Payment', back_populates='invoice')
