from datetime import datetime
from extensions import db
from utils.enum import Gender
from models.associations import doctor_patient

class Patient(db.Model):
    __tablename__ = 'patients'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), unique=True, nullable=False)

    date_of_birth = db.Column(db.Date, nullable=True)
    gender = db.Column(Gender, nullable=True)
    allergies = db.Column(db.String(200), nullable=True)
    address = db.Column(db.String(200), nullable=True)

    image_path = db.Column(db.String(200), nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = db.relationship('User', back_populates='patient')
    doctors = db.relationship('Doctor', secondary=doctor_patient, back_populates='patients')

    tasks = db.relationship('Task', back_populates='patient', cascade='all, delete-orphan')
    appointments = db.relationship('Appointment', back_populates='patient', cascade='all, delete-orphan')
    invoices = db.relationship('Invoice', back_populates='patient', cascade='all, delete-orphan')
    health_records = db.relationship('HealthTracker', back_populates='patient', cascade='all, delete-orphan')
    # group_memberships = db.relationship('GroupMember', back_populates='patient', cascade='all, delete-orphan')
