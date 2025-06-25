from datetime import datetime
from flask import json
from sqlalchemy.types import TypeDecorator, Text
from sqlalchemy import TypeDecorator
from extensions import db
from utils.enum import Gender
from models.associations import doctor_patient

class JSONEncodedList(TypeDecorator):
    impl = Text

    def process_bind_param(self, value, dialect):
        return json.dumps(value) if value is not None else None

    def process_result_value(self, value, dialect):
        return json.loads(value) if value is not None else None
    
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

    # ✅ Patient medical history
    has_past_medical_history = db.Column(db.Boolean, default=False)
    past_medical_history = db.Column(JSONEncodedList, nullable=True)
    has_family_history = db.Column(db.Boolean, default=False)
    family_history = db.Column(JSONEncodedList, nullable=True)
    has_medication_history = db.Column(db.Boolean, default=False)
    medication_history = db.Column(JSONEncodedList, nullable=True)

    # ✅ Patient drug history
    has_allergies = db.Column(db.Boolean, default=False)
    has_medication_allergatic = db.Column(db.Boolean, default=False)
    medication_allergatic = db.Column(db.String(100), nullable=True)
    has_taking_medication = db.Column(db.Boolean, default=False)
    taking_medication = db.Column(db.String(100), nullable=True)
    has_mental_medication = db.Column(db.Boolean, default=False)
    mental_medication = db.Column(db.String(100), nullable=True)

    # ✅ Patient psychiatric history
    is_visited_psychiatrist = db.Column(db.String(100), default='No')
    has_diagnosis_history = db.Column(db.Boolean, default=False)
    diagnosis_history = db.Column(JSONEncodedList, nullable=True)
    is_psychiatrically_hospitalized = db.Column(db.String(100), default='No')
    is_72_hour_mentally_detention_order = db.Column(db.String(100), default='No')
    has_detained_mental_health = db.Column(db.Boolean, default=False)
    number_of_mentally_detained = db.Column(db.String(100), nullable=True)
    detained_mental_health_treatment = db.Column(db.String(100), nullable=True)
    has_seeking_help = db.Column(db.Boolean, default=False)
    seeking_help = db.Column(db.String(100), nullable=True)

    # ✅ Patient personal history
    is_planned_pregnancy = db.Column(db.String(100), default='No')
    is_maternal_substance_use_during_pregnancy = db.Column(db.String(100), default='No')
    is_birth_delayed = db.Column(db.String(100), default='No')
    is_birth_induced = db.Column(db.String(100), default='No')
    is_birth_hypoxia = db.Column(db.String(100), default='No')
    is_immediate_post_natal_complications = db.Column(db.String(100), default='No')
    is_require_oxygen_or_incubator = db.Column(db.String(100), default='No')
    is_feed_well_as_newborn = db.Column(db.String(100), default='No')
    is_sleep_well_as_newborn = db.Column(db.String(100), default='No')
    
    # ✅ Patient family history
    has_family_mental_health_history = db.Column(db.Boolean, default=False)
    family_relationship_details = db.Column(db.String(100), nullable=True)
    family_mental_health_condition = db.Column(db.String(100), nullable=True)
    has_been_hospitalized_for_mental_health = db.Column(db.Boolean, default=False)
    number_of_admissions = db.Column(db.String(100), nullable=True)
    duration = db.Column(db.String(100), nullable=True)
    outcome = db.Column(db.String(100), nullable=True)
    
    
    has_activities_of_daily_living = db.Column(db.Boolean, default=False)
    # Mood assessment
    selected_category = db.Column(db.String(100), nullable=True)
    mood_scale = db.Column(db.Float, nullable=True)
    mood_affect_life = db.Column(db.String(100), nullable=True)
    extreme_energy = db.Column(db.String(100), nullable=True)
    reckless_spending = db.Column(db.String(100), nullable=True)
    taking_medications = db.Column(db.Boolean, default=False)
    alcohol_drug_use = db.Column(db.String(100), nullable=True)
    medical_condition_mood_cause = db.Column(db.String(300), nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # relationships
    user = db.relationship('User', back_populates='patient')
    doctors = db.relationship('Doctor', secondary=doctor_patient, back_populates='patients')
    tasks = db.relationship('Task', back_populates='patient', cascade='all, delete-orphan')
    appointments = db.relationship('Appointment', back_populates='patient', cascade='all, delete-orphan')
    invoices = db.relationship('Invoice', back_populates='patient', cascade='all, delete-orphan')
    health_records = db.relationship('HealthTracker', back_populates='patient', cascade='all, delete-orphan')
