from datetime import datetime
from extensions import db
from utils.enum import taskPriority, taskCategory
class Task(db.Model):
    __tablename__ = 'tasks'

    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctors.id'), nullable=False)

    # user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    task_title = db.Column(db.String(100), nullable=False)

    task_priority = db.Column(taskPriority, nullable=False)
    task_category = db.Column(taskCategory, nullable=False)
     
    task_due_date = db.Column(db.Date, nullable=False)
    task_due_time = db.Column(db.Time, nullable=False)
    task_description = db.Column(db.Text, nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    patient = db.relationship('Patient', back_populates='tasks')
    doctor = db.relationship('Doctor', back_populates='tasks')

    # user = db.relationship('User', back_populates='tasks')