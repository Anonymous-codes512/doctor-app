import os
from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity, jwt_required
from sqlalchemy import or_, and_
from extensions import db
from utils.AES_key import generate_aes_key
from utils.agora_token import generate_agora_token
from werkzeug.utils import secure_filename
from models import Conversation, User,Doctor ,Patient, Message, CallConversation, CallRecord
from datetime import datetime

from flask_socketio import join_room, emit, disconnect
from socket_io_instance import socketio

call_bp = Blueprint('call', __name__, url_prefix='/api')

UPLOAD_FOLDER = 'static/uploads/media'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


@call_bp.route('/create_call_conversation', methods=['POST'])
@jwt_required()
def get_or_create_call_conversation():
    data = request.get_json()
    current_user_id = data.get('user_id')
    other_user_id = data.get('other_user_id')

    if current_user_id == other_user_id:
        return jsonify({'success': False, 'message': 'Cannot call yourself'}), 400

    # Check if conversation exists
    call = CallConversation.query.filter(
        or_(
            and_(CallConversation.user1_id == current_user_id, CallConversation.user2_id == other_user_id),
            and_(CallConversation.user1_id == other_user_id, CallConversation.user2_id == current_user_id)
        )
    ).first()
    
    print(f"DEBUG: current_user_id type: {type(current_user_id)}, value: {current_user_id}")
    
    if call:
        # Token already stored?
        if not call.token or not call.channal_name:
            channel_name = f"call_{call.id}"
            token = generate_agora_token(channel_name, uid=current_user_id)
            call.channal_name = channel_name
            call.token = token
            db.session.commit()

        return jsonify({
            'success': True,
            'call_conversation_id': call.id,
            'channel_name': call.channal_name,
            'token': call.token
        }), 200

    # Create new conversation
    new_call = CallConversation(
        user1_id=current_user_id,
        user2_id=other_user_id
    )
    db.session.add(new_call)
    db.session.commit()

    # Generate token after saving to get ID
    channel_name = f"call_{new_call.id}"
    token = generate_agora_token(channel_name, uid=current_user_id)

    new_call.channal_name = channel_name
    new_call.token = token
    db.session.commit()

    return jsonify({
        'success': True,
        'call_conversation_id': new_call.id,
        'channel_name': channel_name,
        'token': token
    }), 201


@call_bp.route('/get_call_history/<int:user_id>', methods=['GET'])
@jwt_required()
def get_call_history(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({'success': False, 'message': 'User not found'}), 404

    call_conversations = CallConversation.query.filter(
        or_(
            CallConversation.user1_id == user_id,
            CallConversation.user2_id == user_id
        )
    ).all()

    formatted_conversations = []
    seen_user_ids = set() 

    for conversation in call_conversations:
        other_user_id = conversation.user1_id if conversation.user2_id == user_id else conversation.user2_id

        if other_user_id in seen_user_ids:
            continue
                
        other_user = User.query.get(other_user_id)
        if not other_user:
            continue

        conversation_call_records = CallRecord.query.filter_by(call_conversation_id=conversation.id).order_by(CallRecord.timestamp.desc()).all()
  
        formatted_conversation_records = []
        for record in conversation_call_records:
            formatted_conversation_records.append({
                'call_id': record.id,
                'caller_id': record.caller_id,
                'receiver_id': record.receiver_id,
                'call_status': record.call_status,
                'duration': record.duration,
                'timestamp': record.timestamp.strftime('%Y-%m-%d %I:%M %p')
            })

        last_call = conversation_call_records[0] if conversation_call_records else None 

        image_path = ''
        if other_user.role.lower() == 'doctor' and other_user.doctor: 
            image_path = other_user.doctor.image_path or ''
        elif other_user.role.lower() == 'patient' and other_user.patient: 
            image_path = other_user.patient.image_path or ''

        formatted_conversations.append({
            'user_id': other_user.id,
            'name': other_user.name,
            'phone_number': other_user.phone_number,
            'avatar': image_path,
            'is_online': False,  
            'last_call_status': last_call.call_status if last_call else '',
            'last_call_timestamp': last_call.timestamp.strftime('%B %d, %I:%M %p') if last_call else '', # ✅ last_call ki maujoodgi check karein
            'conversation_id': conversation.id,
            'call_history': formatted_conversation_records
        })
        seen_user_ids.add(other_user_id) 

    return jsonify({
        'success': True, 
        'calls_with_history': formatted_conversations 
    }), 200


@call_bp.route('/get_users_for_call/<int:user_id>', methods=['GET'])
@jwt_required()
def get_users_for_call(user_id):
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
                'phone_number': patient_user.phone_number,
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
            'phone_number': doc_user.phone_number,
            'role': doc_user.role,
            'avatar': doc.image_path if hasattr(doc, 'image_path') else '',
            'is_online': False
        })

    return jsonify({'success': True, 'users': result}), 200

@call_bp.route('/get_calls/<int:conversation_id>', methods=['GET'])
@jwt_required()
def get_calls(conversation_id):
    call = CallConversation.query.get(conversation_id)
    if not call:
        return jsonify({'success': False, 'message': 'call Conversation not found'}), 404

    calls = CallRecord.query.filter_by(call_conversation_id=conversation_id).order_by(CallRecord.timestamp.asc()).all()
    result = []

    for call in calls:
        # Fetch sender image
        caller_user = User.query.get(call.caller_id)
        receiver_user = User.query.get(call.receiver_id)

        caller_image = '' # Default empty string
        receiver_image = '' # Default empty string

        if caller_user.role.lower() == 'doctor' and caller_user.doctor:
            caller_image = caller_user.doctor.image_path or ''
        elif caller_user.role.lower() == 'patient' and caller_user.patient:
            caller_image = caller_user.patient.image_path or ''

        if receiver_user.role.lower() == 'doctor' and receiver_user.doctor:
            receiver_image = receiver_user.doctor.image_path or ''
        elif receiver_user.role.lower() == 'patient' and receiver_user.patient:
            receiver_image = receiver_user.patient.image_path or ''


        result.append({
            'id': call.id,
            'caller_id': call.caller_id,
            'receiver_id': call.receiver_id,
            'caller_image': caller_image,
            'receiver_image': receiver_image,
            'start_time': call.start_time.isoformat() if call.start_time else None,
            'end_time': call.end_time.isoformat() if call.end_time else None,
            'call_status': call.call_status,
            'call_type': call.call_type,
            'timestamp': call.timestamp.isoformat(),
            'call_conversation_id': call.call_conversation_id,
        })

    return jsonify({'success': True, 'calls': result}), 200


@socketio.on('join')
def handle_join(data):
    user_id = data.get('user_id')
    if user_id:
        join_room(f"user_{user_id}")
        print(f"✅ User {user_id} joined room user_{user_id} (Socket.IO)")
    else:
        print("❌ Join event received without user_id")
        # disconnect() # Agar user_id na ho to disconnect bhi kar sakte hain


# In events ko backend mein handle karne ke liye, aapko Flask-SocketIO ka use karna hoga.
@socketio.on('start_call')
def handle_start_call(data):
    receiver_id = data.get('receiver_id')
    caller_id = data.get('caller_id')
    caller_name = data.get('caller_name')
    call_type = data.get('call_type', 'audio') # 'audio' ya 'video' ho sakta hai

    if not receiver_id or not caller_id:
        print("❌ Missing caller or receiver info for start_call.")
        emit('call_error', {'message': 'Missing caller or receiver info'}, room=request.sid)
        return

    try:
        # Puraani ya nayi CallConversation dhoondhen ya banayen
        call_conversation = CallConversation.query.filter(
            ((CallConversation.user1_id == caller_id) & (CallConversation.user2_id == receiver_id)) |
            ((CallConversation.user1_id == receiver_id) & (CallConversation.user2_id == caller_id))
        ).first()

        if not call_conversation:
            call_conversation = CallConversation(user1_id=caller_id, user2_id=receiver_id)
            db.session.add(call_conversation)
            db.session.flush() # ID generate karne ke liye

        # Naya CallRecord banayen
        new_call_record = CallRecord(
            call_conversation_id=call_conversation.id,
            caller_id=caller_id,
            receiver_id=receiver_id,
            start_time=datetime.utcnow(),
            call_status='ringing', # Call abhi ring ho rahi hai
            call_type=call_type
        )
        db.session.add(new_call_record)
        db.session.commit()

        # Receiver ko incoming call ki notification bhejen
        emit('incoming_call', {
            'caller_id': caller_id,
            'caller_name': caller_name,
            'call_record_id': new_call_record.id, # Call record ID client ko bhejen
            'call_type': call_type
        }, room=f"user_{receiver_id}")
        print(f"📞 Incoming call ({call_type}) sent to user_{receiver_id} from user_{caller_id}. CallRecord ID: {new_call_record.id}")

    except Exception as e:
        db.session.rollback()
        print(f'❌ Error handling start_call: {e}')
        emit('call_error', {'message': 'Server error starting call'}, room=request.sid)


# call_routes.py mein

@socketio.on('accept_call')
def handle_accept_call(data):
    caller_id = data.get('caller_id')
    receiver_id = data.get('receiver_id')
    call_record_id = data.get('call_record_id')

    print(data)

    if not caller_id or not receiver_id or not call_record_id:
        print("❌ Missing info for accept_call.")
        emit('call_error', {'message': 'Missing call info for acceptance'}, room=request.sid)
        return

    try:
        call_record = CallRecord.query.get(call_record_id)
        if call_record:
            call_record.call_status = 'ongoing'
            call_record.start_time = datetime.utcnow()
            db.session.commit()

            call_conversation = CallConversation.query.get(call_record.call_conversation_id)
            if call_conversation:
                call_conversation.last_call_time = datetime.utcnow()
                db.session.commit()

                channel_name = call_conversation.channel_name
                call_type = call_record.call_type # CallRecord se call_type len

                # Caller aur Receiver dono ke liye Agora token generate karein
                caller_token = generate_agora_token(channel_name, caller_id)
                receiver_token = generate_agora_token(channel_name, receiver_id)

                # Caller ko inform karein ke call accept ho gayi
                emit('call_accepted', {
                    'caller_id': caller_id, # Caller ki ID
                    'receiver_id': receiver_id, # Receiver ki ID
                    'call_record_id': call_record_id,
                    'call_type': call_type, # Call Type shamil karein
                    'channel_name': channel_name, # Channel Name shamil karein
                    'token': caller_token # Caller ke liye Token shamil karein
                }, room=f"user_{caller_id}")
                print(f"✅ Call {call_record_id} accepted by user_{receiver_id}. Notifying user_{caller_id} with channel {channel_name} and token.")

                # Receiver ko bhi Agora details bhejen (jo abhi call accept kar raha hai)
                emit('call_accepted', {
                    'caller_id': caller_id, # Receiver ko pata chale kisne call ki thi
                    'receiver_id': receiver_id, # Receiver ki ID
                    'call_record_id': call_record_id,
                    'call_type': call_type, # Call Type shamil karein
                    'channel_name': channel_name, # Channel Name shamil karein
                    'token': receiver_token # Receiver ke liye Token shamil karein
                }, room=f"user_{receiver_id}")
                print(f"✅ Call {call_record_id} accepted. Notifying receiver user_{receiver_id} with channel {channel_name} and token.")

            else:
                print(f"⚠️ Call Conversation for CallRecord ID {call_record_id} not found.")
                emit('call_error', {'message': 'Call conversation not found for Agora details'}, room=request.sid)

        else:
            print(f"❌ CallRecord with ID {call_record_id} not found for acceptance.")
            emit('call_error', {'message': 'Call record not found'}, room=request.sid)

    except Exception as e:
        db.session.rollback()
        print(f'❌ Error handling accept_call: {e}')
        emit('call_error', {'message': 'Server error accepting call'}, room=request.sid)
        
        
@socketio.on('end_call')
def handle_end_call(data):
    call_record_id = data.get('call_record_id') # Client se call record ID lenge
    ender_id = data.get('ender_id') # Call end karne wale ki ID (caller ya receiver)
    call_status = data.get('call_status', 'completed') # 'completed', 'cancelled', 'rejected', 'missed'

    if not call_record_id or not ender_id:
        print("❌ Missing call_record_id or ender_id for end_call.")
        emit('call_error', {'message': 'Missing call record ID or ender ID'}, room=request.sid)
        return

    try:
        call_record = CallRecord.query.get(call_record_id)
        if call_record:
            if not call_record.end_time: # Agar end_time pehle se set nahi hai
                call_record.end_time = datetime.utcnow()
                call_record.call_status = call_status # Status set karein
                if call_record.start_time and call_record.end_time and call_record.call_status == 'ongoing':
                    # Sirf 'ongoing' calls ke liye duration calculate karein
                    duration = (call_record.end_time - call_record.start_time).total_seconds()
                    call_record.duration = int(duration)
                elif call_record.call_status == 'ringing' and call_status in ['missed', 'rejected', 'cancelled']:
                    # Missed/Rejected/Cancelled calls ke liye duration 0
                    call_record.duration = 0
                else:
                    # Agar call ongoing nahi thi ya start_time nahi hai, duration 0
                    call_record.duration = 0
            
            db.session.commit()

            # Doosre participant ko inform karein ke call end ho gayi
            other_participant_id = None
            if ender_id == call_record.caller_id:
                other_participant_id = call_record.receiver_id
            else:
                other_participant_id = call_record.caller_id
            
            if other_participant_id:
                emit('call_ended', {
                    'call_record_id': call_record_id,
                    'status': call_status,
                    'ender_id': ender_id
                }, room=f"user_{other_participant_id}")
                print(f"🛑 Call {call_record_id} ended by user_{ender_id}. Status: {call_status}. Notifying user_{other_participant_id}.")
            else:
                 print(f"⚠️ No other participant found for call {call_record_id} to notify.")
        else:
            print(f"❌ CallRecord with ID {call_record_id} not found for ending.")
            emit('call_error', {'message': 'Call record not found'}, room=request.sid)

    except Exception as e:
        db.session.rollback()
        print(f'❌ Error handling end_call: {e}')
        emit('call_error', {'message': 'Server error ending call'}, room=request.sid)
