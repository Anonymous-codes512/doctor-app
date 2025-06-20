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
            'user_id', 'patient_name', 'task_title', 'task_priority',
            'task_category', 'task_due_date', 'task_due_time'
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
        if not patient_name:
            return jsonify({'success': False, 'message': 'Patient name cannot be empty'}), 400

        patient = Patient.query.join(Patient.user).filter(User.name == patient_name).first()

        # Date parsing, fallback to current date if fails
        try:
            due_date = datetime.strptime(data['task_due_date'], "%Y-%m-%d").date()
        except Exception:
            due_date = datetime.utcnow().date()

        # Time parsing, fallback to current time if fails
        try:
            due_time = datetime.strptime(data['task_due_time'], "%H:%M").time()
        except Exception:
            due_time = datetime.utcnow().time().replace(second=0, microsecond=0)

        try:
            task_priority = get_enum_value(taskPriority, data['task_priority'], 'task_priority')
            task_category = get_enum_value(taskCategory, data['task_category'], 'task_category')
        except ValueError as e:
            return jsonify({'success': False, 'message': str(e)}), 400

        task = Task(
            patient_id=patient.id if patient else 1,
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
        return jsonify({
            'success': False,
            'message': 'Server error. Please try again later.'
        }), 500
        
@task_bp.route('/fetch_tasks/<int:user_id>', methods=['GET'])
def fetch_tasks(user_id):
    try:
        # Validate user_id
        if user_id <= 0:
            return jsonify({'success': False, 'message': 'Invalid user_id provided'}), 400

        doctor = Doctor.query.filter_by(user_id=user_id).first()
        if not doctor:
            return jsonify({'success': False, 'message': f"No doctor found for user_id {user_id}"}), 404

        tasks = Task.query.filter_by(doctor_id=doctor.id).all()

        result = []
        for task in tasks:
            patient_name = ''
            if task.patient and task.patient.user:
                patient_name = task.patient.user.name

            result.append({
                'task_id': task.id,
                'user_id': user_id,
                'patient_name': patient_name,
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
