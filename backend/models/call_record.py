from extensions import db
from datetime import datetime

class CallRecord(db.Model):
    __tablename__ = 'call_records'

    id = db.Column(db.Integer, primary_key=True)
    call_conversation_id = db.Column(db.Integer, db.ForeignKey('call_conversations.id'), nullable=False) # Nayi field
    caller_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    receiver_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    start_time = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    end_time = db.Column(db.DateTime, nullable=True)
    call_status = db.Column(db.String(50), nullable=False)
    call_type = db.Column(db.String(50), nullable=False)
    duration = db.Column(db.Integer, nullable=True)

    caller = db.relationship('User', foreign_keys=[caller_id], backref='initiated_calls')
    receiver = db.relationship('User', foreign_keys=[receiver_id], backref='received_calls')
    call_conversation = db.relationship('CallConversation', back_populates='calls')

    def __repr__(self):
        return f'<CallRecord {self.id} from {self.caller_id} to {self.receiver_id} status: {self.call_status}>'

    def to_dict(self):
        return {
            'id': self.id,
            'call_conversation_id': self.call_conversation_id,
            'caller_id': self.caller_id,
            'receiver_id': self.receiver_id,
            'start_time': self.start_time.isoformat() if self.start_time else None,
            'end_time': self.end_time.isoformat() if self.end_time else None,
            'call_status': self.call_status,
            'call_type': self.call_type,
            'duration': self.duration,
        }