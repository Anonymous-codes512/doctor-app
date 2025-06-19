from datetime import datetime
from extensions import db
class Task(db.Model):
    __tablename__ = 'tasks'

    id = db.Column(db.Integer, primary_key=True)
    # user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    task_name = db.Column(db.String(100), nullable=False)
    task_priority = db.Column(db.Enum('low', 'medium', 'high', name='task_priority'))
    task_category = db.Column(db.Enum('consultation', 'check-up', 'follow-up', name='task_category'))
    task_due_date = db.Column(db.Date, nullable=False)
    task_description = db.Column(db.Text, nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # user = db.relationship('User', back_populates='tasks')