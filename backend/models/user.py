import enum
from extensions import db

class UserRole(enum.Enum):
    DOCTOR = 'doctor'
    PATIENT = 'patient'

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    phone_number = db.Column(db.BigInteger, unique=True, nullable=True)
    role = db.Column(db.Enum(UserRole), nullable=False)
    profile_picture = db.Column(db.String(200), nullable=True)
    password = db.Column(db.String(200), nullable=False)

    def __repr__(self):
        return f'<User {self.email}>'
