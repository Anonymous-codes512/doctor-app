from extensions import db
from datetime import datetime

class CallConversation(db.Model):
    __tablename__ = 'call_conversations'

    id = db.Column(db.Integer, primary_key=True)
    user1_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    user2_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    
    last_call_time = db.Column(db.DateTime, default=datetime.utcnow)
    unread_calls_count = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    user1 = db.relationship('User', foreign_keys=[user1_id])
    user2 = db.relationship('User', foreign_keys=[user2_id])

    calls = db.relationship('CallRecord', back_populates='call_conversation', lazy=True, cascade='all, delete-orphan')

    def __repr__(self):
        return f'<CallConversation {self.id} between {self.user1_id} and {self.user2_id}>'

    def to_dict(self):
        return {
            'id': self.id,
            'user1_id': self.user1_id,
            'user2_id': self.user2_id,
            'last_call_time': self.last_call_time.isoformat() if self.last_call_time else None,
            'unread_calls_count': self.unread_calls_count
        }