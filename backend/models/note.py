from extensions import db
from datetime import datetime

class Note(db.Model):
    __tablename__ = 'notes'

    id = db.Column(db.Integer, primary_key=True)
    notes_title = db.Column(db.String(255), nullable=False)
    notes_description = db.Column(db.Text, nullable=False)
    date = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Foreign keys to doctor and patient
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctors.id'), nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)

    # Relationships (optional but recommended)
    doctor = db.relationship('Doctor', backref=db.backref('notes', lazy=True))
    patient = db.relationship('Patient', backref=db.backref('notes', lazy=True))

    def __repr__(self):
        return f'<Note {self.notes_title} for doctor {self.doctor_id} and patient {self.patient_id}>'
