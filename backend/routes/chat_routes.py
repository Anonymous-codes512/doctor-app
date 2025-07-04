import os
from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity, jwt_required
from sqlalchemy import or_, and_
from extensions import db
from utils.AES_key import generate_aes_key
from werkzeug.utils import secure_filename
from models import Conversation, User,Doctor ,Patient, Message
from datetime import datetime

from flask_socketio import join_room, emit, disconnect
from socket_io_instance import socketio

chat_bp = Blueprint('chat', __name__, url_prefix='/api')

UPLOAD_FOLDER = 'static/uploads/media'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@chat_bp.route('/create_conversation', methods=['POST'])
@jwt_required()
def get_or_create_conversation():
    data = request.get_json()
    current_user_id = data.get('user_id')
    other_user_id = data.get('other_user_id')

    if current_user_id == other_user_id:
        return jsonify({'success': False, 'message': 'Cannot chat with yourself'}), 400

    # Check if conversation exists
    convo = Conversation.query.filter(
        or_(
            and_(Conversation.participant1_id == current_user_id, Conversation.participant2_id == other_user_id),
            and_(Conversation.participant1_id == other_user_id, Conversation.participant2_id == current_user_id)
        )
    ).first()

    if convo:
        return jsonify({'success': True, 'conversation_id': convo.id, 'chat_secret': convo.chat_secret}), 200

    # Create new conversation
    new_secret = generate_aes_key()
    convo = Conversation(
        participant1_id=current_user_id,
        participant2_id=other_user_id,
        chat_secret=new_secret
    )
    db.session.add(convo)
    db.session.commit()

    return jsonify({'success': True, 'conversation_id': convo.id, 'chat_secret': convo.chat_secret}), 201

@chat_bp.route('/get_conversations/<int:user_id>', methods=['GET'])
@jwt_required()
def get_conversations(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({'success': False, 'message': 'User not found'}), 404

    conversations = Conversation.query.filter(
        or_(
            Conversation.participant1_id == user_id,
            Conversation.participant2_id == user_id
        )
    ).all()

    formatted = []
    for convo in conversations:
        other_user_id = convo.participant1_id if convo.participant2_id == user_id else convo.participant2_id
        other_user = User.query.get(other_user_id)

        last_message = Message.query.filter_by(conversation_id=convo.id).order_by(Message.timestamp.desc()).first()

        image_path = ''
        if other_user.role.lower() == 'doctor' and other_user.doctor:
            image_path = other_user.doctor.image_path or ''
        elif other_user.role.lower() == 'patient' and other_user.patient:
            image_path = other_user.patient.image_path or ''

        formatted.append({
            'user_id': other_user.id,
            'name': other_user.name,
            'avatar': image_path,
            'is_online': False,
            'last_message': last_message.encrypted_message if last_message else '',
            'last_time': last_message.timestamp.strftime('%H:%M') if last_message else '',
            'unread_count': Message.query.filter_by(conversation_id=convo.id, receiver_id=user_id, is_read=False).count()
        })

    # Fetch related patients if user is a doctor
    patient_users = []
    if user.role == 'doctor':
        doctor = Doctor.query.filter_by(user_id=user_id).first()
        if doctor:
            patients = Patient.query.filter_by(doctor_id=doctor.id).all()
            for p in patients:
                patient_user = User.query.get(p.user_id)
                if patient_user and patient_user.id != user_id:
                    patient_users.append({
                        'user_id': patient_user.id,
                        'name': patient_user.name,
                        'avatar': patient_user.patient.image_path if patient_user.patient else '',
                        'is_online': False,
                        'last_message': '',
                        'last_time': '',
                        'unread_count': 0
                    })

    # Add other doctors
    other_doctors = Doctor.query.filter(Doctor.user_id != user_id).all()
    for doc in other_doctors:
        doc_user = User.query.get(doc.user_id)
        if doc_user and doc_user.id != user_id:
            patient_users.append({
                'user_id': doc_user.id,
                'name': doc_user.name,
                'avatar': doc_user.doctor.image_path if doc_user.doctor else '',
                'is_online': False,
                'last_message': '',
                'last_time': '',
                'unread_count': 0
            })

    # Merge without duplicates
    seen_ids = set(item['user_id'] for item in formatted)
    for p in patient_users:
        if p['user_id'] not in seen_ids:
            formatted.append(p)
    print(f'\n\n conversations : {formatted}')

    return jsonify({'success': True, 'conversations': formatted}), 200

@chat_bp.route('/get_users_for_chat/<int:user_id>', methods=['GET'])
@jwt_required()
def get_users_for_chat(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({'success': False, 'message': 'User not found'}), 404

    result = []

    # ✅ Add patients if current user is a doctor
    if user.role.lower() == 'doctor' and user.doctor:
        doctor = user.doctor
        for patient in doctor.patients:
            patient_user = patient.user
            result.append({
                'user_id': patient_user.id,
                'name': patient_user.name,
                'role': patient_user.role,
                'avatar': patient.image_path or '',
                'is_online': False
            })

    # ✅ Add all other doctors (excluding current one)
    other_doctors = Doctor.query.filter(Doctor.user_id != user_id).all()
    for doc in other_doctors:
        doc_user = doc.user
        result.append({
            'user_id': doc_user.id,
            'name': doc_user.name,
            'role': doc_user.role,
            'avatar': doc.image_path if hasattr(doc, 'image_path') else '',
            'is_online': False
        })

    return jsonify({'success': True, 'users': result}), 200

@chat_bp.route('/get_messages/<int:conversation_id>', methods=['GET'])
@jwt_required()
def get_messages(conversation_id):
    convo = Conversation.query.get(conversation_id)
    if not convo:
        return jsonify({'success': False, 'message': 'Conversation not found'}), 404

    messages = Message.query.filter_by(conversation_id=conversation_id).order_by(Message.timestamp.asc()).all()
    result = []

    for msg in messages:
        # Fetch sender image
        sender_user = User.query.get(msg.sender_id)
        receiver_user = User.query.get(msg.receiver_id)

        sender_image = None
        receiver_image = None

        if sender_user.role.lower() == 'doctor' and sender_user.doctor:
            sender_image = sender_user.doctor.image_path
        elif sender_user.role.lower() == 'patient' and sender_user.patient:
            sender_image = sender_user.patient.image_path

        if receiver_user.role.lower() == 'doctor' and receiver_user.doctor:
            receiver_image = receiver_user.doctor.image_path
        elif receiver_user.role.lower() == 'patient' and receiver_user.patient:
            receiver_image = receiver_user.patient.image_path

        result.append({
            'id': msg.id,
            'sender_id': msg.sender_id,
            'receiver_id': msg.receiver_id,
            'encrypted_message': msg.encrypted_message,
            'message_type': msg.message_type,
            'timestamp': msg.timestamp.isoformat(),
            'is_read': msg.is_read,
            'read_at': msg.read_at.isoformat() if msg.read_at else None,
            'sender_image': sender_image,
            'receiver_image': receiver_image,
        })

    return jsonify({'success': True, 'messages': result}), 200

@chat_bp.route('/send_message', methods=['POST'])
@jwt_required()
def send_message():
    try:
        data = request.get_json()
        sender_id = get_jwt_identity()  # sender is the logged-in user

        if not data:
            return jsonify({"error": "Missing data"}), 400

        conversation_id = data.get('conversation_id')
        encrypted_message = data.get('encrypted_message')
        message_type = data.get('message_type', 'text')
        receiver_id = data.get('receiver_id')

        if not conversation_id or not encrypted_message or not receiver_id:
            return jsonify({"error": "Missing required fields"}), 400

        # Create message object
        message = Message(
            sender_id=sender_id,
            receiver_id=receiver_id,
            conversation_id=conversation_id,
            encrypted_message=encrypted_message,
            message_type=message_type,
            timestamp=datetime.utcnow()
        )

        db.session.add(message)
        db.session.commit()
        
        socketio.emit('new_message', {
            "conversation_id": message.conversation_id,
            "sender_id": message.sender_id,
            "receiver_id": message.receiver_id,
            "message": message.encrypted_message,
            "message_type": message.message_type,
            "timestamp": message.timestamp.isoformat(),
        }, room=f"user_{receiver_id}")

        return jsonify({"message": "Message sent successfully", "id": message.id}), 201

    except Exception as e:
        db.session.rollback()
        print(f'❌ Error sending message: {e}')
        return jsonify({"error": "Server error", "details": str(e)}), 500
    
    # Existing @socketio.on('join') handler


@chat_bp.route('/upload_media', methods=['POST'])
@jwt_required()
def upload_media():
    file = request.files.get('file')
    file_path = None

    if file:
        filename = secure_filename(file.filename)
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        file.save(file_path)
        print(f"🖼️ File saved to: {file_path}")
    else:
        print("🚫 No image file received.")

    if not file:
        return jsonify({'error': 'No file uploaded'}), 400

    return jsonify({'success': True, 'file_url': file_path}), 200


@socketio.on('join')
def handle_join(data):
    user_id = data.get('user_id')
    if user_id:
        join_room(f"user_{user_id}")
        print(f"✅ User {user_id} joined room user_{user_id} (Socket.IO)")
    else:
        print("❌ Join event received without user_id")
        # disconnect() # Agar user_id na ho to disconnect bhi kar sakte hain

# ✅ Naya Socket.IO event handler for sending messages
@socketio.on('send_message') # Yeh woh event name hai jo frontend emit karega
def handle_send_message(data):
    try:
        # Backend mein JWT required hone ki wajah se, yahan get_jwt_identity()
        # direct Socket.IO event mein kaam nahi karega jab tak aap token ko
        # connection query params mein na bhejen aur phir use validate na karein.
        # Simple test ke liye, hum data se sender_id le rahe hain,
        # lekin production mein isko secure banana zaroori hai.
        sender_id = data.get('sender_id') # Frontend se aayega
        conversation_id = data.get('conversation_id')
        encrypted_message = data.get('encrypted_message')
        message_type = data.get('message_type', 'text')
        receiver_id = data.get('receiver_id')

        if not all([sender_id, conversation_id, encrypted_message, receiver_id]):
            print("❌ Missing data for real-time message.")
            return # Acha hoga ke client ko error emit karein

        # Database mein message save karein
        message = Message(
            sender_id=sender_id,
            receiver_id=receiver_id,
            conversation_id=conversation_id,
            encrypted_message=encrypted_message,
            message_type=message_type,
            timestamp=datetime.utcnow()
        )
        db.session.add(message)
        db.session.commit()

        # Message ko receiver ke room mein emit karein (real-time delivery)
        # MessageModel.fromJson() ko use kar sakein frontend par
        message_to_emit = {
            "id": message.id,
            "sender_id": message.sender_id,
            "receiver_id": message.receiver_id,
            "conversation_id": message.conversation_id, # Yeh bhi bhej dein
            "encrypted_message": message.encrypted_message,
            "message_type": message.message_type,
            "timestamp": message.timestamp.isoformat(),
            "is_read": message.is_read,
            "read_at": message.read_at.isoformat() if message.read_at else None,
            # 'sender_image' aur 'receiver_image' yahan se fetch karna complex hoga
            # Agar chahiye, to alag se fetch ya cached data use karein
        }
        
        # Sender ko bhi message bhejen taake uska UI update ho
        emit('new_message', message_to_emit, room=f"user_{sender_id}")
        # Receiver ko message bhejen
        emit('new_message', message_to_emit, room=f"user_{receiver_id}")
        
        print(f"✅ Real-time message sent from {sender_id} to {receiver_id} in conversation {conversation_id}")

    except Exception as e:
        db.session.rollback()
        print(f'❌ Error in real-time message handling: {e}')
        # emit('error', {'message': 'Server error sending message'}) # Client ko error bhejen
