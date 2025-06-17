from flask import Blueprint, render_template, request, jsonify
from werkzeug.security import generate_password_hash , check_password_hash
from models.user import User, UserRole
from extensions import db
from flask_jwt_extended import create_access_token
from utils.token_utils import generate_confirmation_token
from utils.mail_utils import send_confirmation_email, send_reset_otp_email
from utils.token_utils import confirm_token
from models.password_reset_otp import PasswordResetOTP
from datetime import datetime, timedelta
import random
import string

auth_bp = Blueprint('auth', __name__, url_prefix='/api')

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()

    name = data.get('name')
    email = data.get('email')
    phone = data.get('phone_number')
    password = data.get('password')
    role = data.get('role')

    if not all([name, email, password, role]):
        return jsonify({'success': False, 'message': 'Missing required fields'}), 400

    # Check if user already exists
    if User.query.filter_by(email=email).first():
        return jsonify({'success': False, 'message': 'Email already registered'}), 409

    # Hash password
    hashed_password = generate_password_hash(password)

    # Create user
    new_user = User(
        name=name,
        email=email,
        phone_number=phone,
        password=hashed_password,
        role=role.upper()
    )

    db.session.add(new_user)
    db.session.commit()

    token = generate_confirmation_token(email)
    send_confirmation_email(email, name, token)

    return jsonify({
        'success': True,
        'message': 'User registered successfully & confirmation mail is sent'
    }), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'success': False, 'message': 'Email and password are required'}), 400

    user = User.query.filter_by(email=email).first()

    if not user or not check_password_hash(user.password, password):
        return jsonify({'success': False, 'message': 'Invalid credentials'}), 401
    
    access_token = create_access_token(identity=user.id)

    return jsonify({
        'success': True,
        'message': 'Login successful',
        'token': access_token,
        'user': {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'role': user.role
        }
    }), 200

@auth_bp.route('/confirm-email/<token>', methods=['GET'])
def confirm_email(token):
    email = confirm_token(token)
    if not email:
        return render_template('emails/confirmation_success.html', message='❌ Invalid or expired token')

    user = User.query.filter_by(email=email).first()
    if not user:
        return render_template('emails/confirmation_success.html', message='❌ User not found')

    if user.email_confirmed:
        return render_template('emails/confirmation_success.html', message='✅ Email already confirmed')

    user.email_confirmed = True
    db.session.commit()
    return render_template('emails/confirmation_success.html', message='🎉 Email confirmed successfully!')


def generate_otp(length=4):
    return ''.join(random.choices(string.digits, k=length))


@auth_bp.route('/send-reset-code', methods=['POST'])
def send_reset_code():
    data = request.get_json()
    email = data.get('email')
    if not email:
        return jsonify({'success': False, 'message': 'Email is required'}), 400

    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({'success': False, 'message': 'User not found'}), 404

    # Remove any old OTPs for this email
    PasswordResetOTP.query.filter_by(email=email).delete()

    otp = generate_otp()
    expiry = datetime.utcnow() + timedelta(minutes=15)
    new_otp = PasswordResetOTP(
        user_id=user.id,
        email=email,
        otp=otp,
        expires_at=expiry
    )
    db.session.add(new_otp)
    db.session.commit()

    send_reset_otp_email(email, user.name, otp)

    return jsonify({'success': True, 'message': 'Reset OTP sent to your email'}), 200

@auth_bp.route('/verify-reset-otp', methods=['POST'])
def verify_reset_otp():
    data = request.get_json()
    email = data.get('email')
    otp = data.get('otp')
    if not email or not otp:
        return jsonify({'success': False, 'message': 'Email and OTP are required'}), 400

    otp_record = PasswordResetOTP.query.filter_by(email=email, otp=otp).first()
    if not otp_record:
        return jsonify({'success': False, 'message': 'Invalid OTP'}), 400

    if otp_record.is_expired():
        db.session.delete(otp_record)
        db.session.commit()
        return jsonify({'success': False, 'message': 'OTP expired'}), 400

    # Valid OTP - delete after verification
    db.session.delete(otp_record)
    db.session.commit()

    return jsonify({'success': True, 'message': 'OTP verified successfully'}), 200

@auth_bp.route('/reset-password', methods=['POST'])
def reset_password():
    data = request.get_json()
    email = data.get('email')
    new_password = data.get('password')

    if not email or not new_password:
        return jsonify({'success': False, 'message': 'Email and new password are required'}), 400

    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({'success': False, 'message': 'User not found'}), 404

    # Hash the new password (assuming you're using werkzeug.security)
    from werkzeug.security import generate_password_hash
    user.password = generate_password_hash(new_password)
    db.session.commit()

    return jsonify({'success': True, 'message': 'Password has been reset successfully'}), 200
