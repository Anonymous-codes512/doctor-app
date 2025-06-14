from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash , check_password_hash
from models.user import User, UserRole
from extensions import db
from flask_jwt_extended import create_access_token


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
        role=UserRole(role.lower())
    )

    db.session.add(new_user)
    db.session.commit()

    return jsonify({'success': True, 'message': 'User registered successfully'}), 201


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
            'role': user.role.value
        }
    }), 200
