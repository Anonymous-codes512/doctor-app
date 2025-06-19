from datetime import datetime
from extensions import db
from utils.enum import UserRole

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    phone_number = db.Column(db.String(15), unique=True, nullable=True)
    role = db.Column(UserRole, nullable=False)
    email_confirmed = db.Column(db.Boolean, default=False)
    password = db.Column(db.String(200), nullable=False)
    
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    reset_otps = db.relationship('PasswordResetOTP', back_populates='user', cascade='all, delete-orphan')
    doctor = db.relationship('Doctor', back_populates='user', cascade='all, delete-orphan', uselist=False)
    patient = db.relationship('Patient', back_populates='user', cascade='all, delete-orphan', uselist=False)

    def __repr__(self):
        return f'<User {self.email}>'
