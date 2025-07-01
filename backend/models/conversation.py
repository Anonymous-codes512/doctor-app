from extensions import db
from datetime import datetime

class Conversation(db.Model):
    __tablename__ = 'conversations'

    id = db.Column(db.Integer, primary_key=True)
    participant1_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    participant2_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    chat_secret = db.Column(db.String(500), nullable=False)  # Encrypted AES key
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    messages = db.relationship('Message', back_populates='conversation', cascade='all, delete-orphan')
