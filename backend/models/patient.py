from datetime import datetime
from extensions import db
from utils.enum import Gender
from models.associations import doctor_patient

class Patient(db.Model):
    __tablename__ = 'patients'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), unique=True, nullable=False)

    date_of_birth = db.Column(db.Date, nullable=True)
    allergies = db.Column(db.String(200), nullable=True)
    address = db.Column(db.String(200), nullable=True)
    
    weight = db.Column(db.String(200), nullable=True)
    height = db.Column(db.String(200), nullable=True)
    blood_pressure = db.Column(db.String(200), nullable=True)
    pulse = db.Column(db.String(200), nullable=True)

    image_path = db.Column(db.String(200), nullable=True)
    
    gender_born_with = db.Column(Gender, nullable=True)
    gender_identified_with = db.Column(Gender, nullable=True)
    contact = db.Column(db.String(100), nullable=True)
    kin_relation = db.Column(db.String(100), nullable=True)
    kin_full_name = db.Column(db.String(100), nullable=True)
    kin_contact_number = db.Column(db.String(100), nullable=True)
    gp_details = db.Column(db.String(200), nullable=True)
    preferred_language = db.Column(db.String(50), nullable=True)

    has_physical_disabilities = db.Column(db.Boolean, default=False)
    physical_disability_specify = db.Column(db.String(200), nullable=True)
    requires_wheelchair_access = db.Column(db.Boolean, default=False)
    wheelchair_specify = db.Column(db.String(200), nullable=True)
    needs_special_communication = db.Column(db.Boolean, default=False)
    communication_specify = db.Column(db.String(200), nullable=True)
    has_hearing_impairments = db.Column(db.Boolean, default=False)
    hearing_specify = db.Column(db.String(200), nullable=True)
    has_visual_impairments = db.Column(db.Boolean, default=False)
    visual_specify = db.Column(db.String(200), nullable=True)

    environmental_factors = db.Column(db.Text, nullable=True)
    other_accessibility_needs = db.Column(db.Text, nullable=True)

    has_health_insurance = db.Column(db.Boolean, default=False)
    insurance_provider = db.Column(db.String(100), nullable=True)
    policy_number = db.Column(db.String(100), nullable=True)
    insurance_claim_contact = db.Column(db.String(100), nullable=True)
    linked_hospitals = db.Column(db.String(200), nullable=True)
    additional_health_benefits = db.Column(db.String(200), nullable=True)


    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = db.relationship('User', back_populates='patient')
    doctors = db.relationship('Doctor', secondary=doctor_patient, back_populates='patients')

    tasks = db.relationship('Task', back_populates='patient', cascade='all, delete-orphan')
    appointments = db.relationship('Appointment', back_populates='patient', cascade='all, delete-orphan')
    invoices = db.relationship('Invoice', back_populates='patient', cascade='all, delete-orphan')
    health_records = db.relationship('HealthTracker', back_populates='patient', cascade='all, delete-orphan')
    # group_memberships = db.relationship('GroupMember', back_populates='patient', cascade='all, delete-orphan')
