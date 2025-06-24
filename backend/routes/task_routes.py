from flask import request, jsonify, Blueprint
from models.task import Task
from models.patient import Patient
from models import Doctor, User
from extensions import db
from datetime import datetime
from utils.enum import taskPriority, taskCategory


def get_enum_value(enum_class, value, field_name):
    val = value.lower()
    if val in enum_class.enums:
        return val
    raise ValueError(f"Invalid value '{value}' for {field_name}")


task_bp = Blueprint('task', __name__, url_prefix='/api')

@task_bp.route('/create_task', methods=['POST'])
def create_task():
    try:
        data = request.get_json()
        print(f'📩 Incoming Task Data: {data}')

        required_fields = [
            'user_id', 'patient_name', 'patient_email', 'task_title',
            'task_priority', 'task_category', 'task_due_date', 'task_due_time'
        ]
        missing = [f for f in required_fields if f not in data or not data[f]]
        if missing:
            return jsonify({
                'success': False,
                'message': f'Missing required field(s): {", ".join(missing)}'
            }), 400

        doctor = Doctor.query.filter_by(user_id=data['user_id']).first()
        if not doctor:
            return jsonify({
                'success': False,
                'message': f"No doctor found for user_id {data['user_id']}"
            }), 404

        patient_name = data['patient_name'].strip()
        patient_email = data['patient_email'].strip().lower()
        if not patient_name or not patient_email:
            return jsonify({'success': False, 'message': 'Patient name and email cannot be empty'}), 400

        # Check if user with this email exists
        user = User.query.filter_by(email=patient_email).first()
        if not user:
            username = patient_name.replace(" ", "").lower()
            user = User(
                name=patient_name,
                email=patient_email,
                role='PATIENT',
                password=f"{username}1234"
            )
            db.session.add(user)
            db.session.flush()

            patient = Patient(user_id=user.id)
            db.session.add(patient)
            db.session.flush()

            doctor.patients.append(patient)
        else:
            patient = Patient.query.filter_by(user_id=user.id).first()
            if not patient:
                patient = Patient(user_id=user.id)
                db.session.add(patient)
                db.session.flush()

            if patient not in doctor.patients:
                doctor.patients.append(patient)

        # Parse due date
        try:
            due_date = datetime.strptime(data['task_due_date'], "%Y-%m-%d").date()
        except Exception:
            due_date = datetime.utcnow().date()

        # Parse due time
        try:
            due_time = datetime.strptime(data['task_due_time'], "%H:%M").time()
        except Exception:
            due_time = datetime.utcnow().time().replace(second=0, microsecond=0)

        # Enum checks
        try:
            task_priority = get_enum_value(taskPriority, data['task_priority'], 'task_priority')
            task_category = get_enum_value(taskCategory, data['task_category'], 'task_category')
        except ValueError as e:
            return jsonify({'success': False, 'message': str(e)}), 400

        task = Task(
            patient_id=patient.id,
            doctor_id=doctor.id,
            task_title=data['task_title'],
            task_priority=task_priority,
            task_category=task_category,
            task_due_date=due_date,
            task_due_time=due_time,
            task_description=data.get('task_description')
        )

        db.session.add(task)
        db.session.commit()

        return jsonify({'success': True, 'message': 'Task created successfully'}), 201

    except Exception as e:
        print(f'❌ Exception while creating task: {e}')
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': 'Server error. Please try again later.'
        }), 500

        
@task_bp.route('/fetch_tasks/<int:user_id>', methods=['GET'])
def fetch_tasks(user_id):
    try:
        if user_id <= 0:
            return jsonify({'success': False, 'message': 'Invalid user_id provided'}), 400

        doctor = Doctor.query.filter_by(user_id=user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': f"No doctor found for user_id {user_id}"}), 404

        tasks = Task.query.filter_by(doctor_id=doctor.id).all()

        result = []
        for task in tasks:
            patient_name = ''
            patient_email = ''
            if task.patient and task.patient.user:
                patient_name = task.patient.user.name
                patient_email = task.patient.user.email

            result.append({
                'task_id': task.id,
                'user_id': user_id,
                'patient_id': task.patient_id,
                'patient_name': patient_name,
                'patient_email': patient_email,
                'task_title': task.task_title,
                'task_priority': task.task_priority,
                'task_category': task.task_category,
                'task_due_date': task.task_due_date.strftime('%Y-%m-%d') if task.task_due_date else None,
                'task_due_time': task.task_due_time.strftime('%H:%M') if task.task_due_time else None,
                'task_description': task.task_description,
            })

        return jsonify({'success': True, 'tasks': result}), 200

    except Exception as e:
        print(f'❌ Exception in fetch_tasks: {e}')
        return jsonify({'success': False, 'message': 'Internal server error while fetching tasks'}), 500
