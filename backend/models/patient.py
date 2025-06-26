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
    
    # ✅ Activities of daily living
    shower_ability = db.Column(db.String(100), default='No')
    shower_frequency = db.Column(db.String(100), default='No')
    dressing_ability = db.Column(db.String(100), default='No')
    eating_ability = db.Column(db.String(100), default='No')
    food_type = db.Column(db.String(100), default='No')
    toileting_ability = db.Column(db.String(100), default='No')
    grooming_ability = db.Column(db.String(100), default='No')
    menstrual_management = db.Column(db.String(100), default='No')
    household_tasks = db.Column(db.String(100), default='No')
    daily_affairs = db.Column(db.String(100), default='No')
    safety_mobility = db.Column(db.String(100), default='No')

    # ✅ Mood info
    has_depressive_illness = db.Column(db.Boolean, default=False)
    depressive_frequency = db.Column(db.String(100), nullable=True)
    mood_level = db.Column(db.Float, default=0.0)
    mood_worse_in_morning = db.Column(db.Boolean, default=False)
    mood_constantly_low = db.Column(db.Boolean, default=False)
    can_smile = db.Column(db.Boolean, default=False)
    can_laugh = db.Column(db.Boolean, default=False)
    has_normal_appetite_and_enjoyment = db.Column(db.Boolean, default=False)
    enjoyment_activities_description = db.Column(db.String(500), nullable=True)
    has_crying = db.Column(db.Boolean, default=False)
    cry_frequency = db.Column(db.String(100), nullable=True)
    feels_life_worth = db.Column(db.Boolean, default=False)
    has_suicidal_thoughts = db.Column(db.Boolean, default=False)
    suicidal_frequency = db.Column(db.String(100), nullable=True)
    feels_not_want_to_be_here = db.Column(db.Boolean, default=False)
    not_want_to_be_here_frequency = db.Column(db.String(100), nullable=True)
    want_to_die = db.Column(db.Boolean, default=False)
    want_to_die_frequency = db.Column(db.String(100), nullable=True)
    has_ending_life_thoughts = db.Column(db.Boolean, default=False)
    has_tried_ending_life = db.Column(db.Boolean, default=False)
    life_ending_methods_details = db.Column(db.String(500), nullable=True)
    has_injuries = db.Column(db.Boolean, default=False)
    injuries_description = db.Column(db.String(500), nullable=True)
    has_hospital_admission = db.Column(db.Boolean, default=False)
    hospital_admission_details = db.Column(db.String(500), nullable=True)
    has_self_harmed = db.Column(db.Boolean, default=False)
    self_harmed_methods = db.Column(db.String(500), nullable=True)
    has_acquired_injury = db.Column(db.Boolean, default=False)
    acquired_injury_description = db.Column(db.String(500), nullable=True)
    has_guilt = db.Column(db.Boolean, default=False)
    guilt_reason = db.Column(db.String(500), nullable=True)
    blood_vessel_damage = db.Column(db.Boolean, default=False)
    nerve_damage = db.Column(db.Boolean, default=False)
    required_stitches = db.Column(db.Boolean, default=False)
    required_surgery = db.Column(db.Boolean, default=False)
    permanent_damage_from_self_harm = db.Column(db.Boolean, default=False)
    has_confidence_and_self_esteem = db.Column(db.Boolean, default=False)
    self_esteem_level = db.Column(db.Float, default=0.0)
    overly_happy_frequency = db.Column(db.String(100), nullable=True)
    excessively_flirty = db.Column(db.Boolean, default=False)
    increased_sex_drive = db.Column(db.Boolean, default=False)
    reckless_spending = db.Column(db.Boolean, default=False)
    undressed_in_public = db.Column(db.Boolean, default=False)
    buys_beyond_means = db.Column(db.Boolean, default=False)
    high_risk_activities = db.Column(db.Boolean, default=False)
    inflated_self_esteem = db.Column(db.Boolean, default=False)
    feels_superior = db.Column(db.Boolean, default=False)
    believes_in_powers = db.Column(db.Boolean, default=False)
    feels_wealthy_or_genius = db.Column(db.Boolean, default=False)
    anger_level = db.Column(db.String(100), nullable=True)
    agitation_level = db.Column(db.String(100), nullable=True)
    low_mood_duration = db.Column(db.String(100), nullable=True)
    elated_mood_duration = db.Column(db.String(100), nullable=True)

    # ✅ Mood Assessment
    selected_physical_symptom = db.Column(db.String(100), nullable=True)
    mood_levels = db.Column(db.Float, default=0.0)
    mood_affect_life = db.Column(db.String(100), nullable=True)
    extreme_energy_periods = db.Column(db.String(100), nullable=True)
    reckless_spending_frequency = db.Column(db.String(100), nullable=True)
    is_taking_medications = db.Column(db.Boolean, default=False)
    alcohol_drug_use_frequency = db.Column(db.String(100), nullable=True)
    medical_conditions = db.Column(db.String(100), nullable=True)
    
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # relationships
    user = db.relationship('User', back_populates='patient')
    doctors = db.relationship('Doctor', secondary=doctor_patient, back_populates='patients')
    tasks = db.relationship('Task', back_populates='patient', cascade='all, delete-orphan')
    appointments = db.relationship('Appointment', back_populates='patient', cascade='all, delete-orphan')
    invoices = db.relationship('Invoice', back_populates='patient', cascade='all, delete-orphan')
    health_records = db.relationship('HealthTracker', back_populates='patient', cascade='all, delete-orphan')
