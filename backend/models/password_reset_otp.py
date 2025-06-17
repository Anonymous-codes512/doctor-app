from datetime import datetime
from extensions import db

class PasswordResetOTP(db.Model):
    __tablename__ = 'password_reset_otps'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    email = db.Column(db.String(120), nullable=False)
    otp = db.Column(db.String(6), nullable=False)
    expires_at = db.Column(db.DateTime, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    user = db.relationship('User', back_populates='reset_otps')

    def is_expired(self):
        return datetime.utcnow() > self.expires_at

    @classmethod
    def clean_expired(cls):
        expired = cls.query.filter(cls.expires_at < datetime.utcnow()).all()
        for otp in expired:
            db.session.delete(otp)
        db.session.commit()
