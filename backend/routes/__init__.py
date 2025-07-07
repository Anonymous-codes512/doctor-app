from .auth_routes import auth_bp
from .appointment_routes import appointment_bp
from .task_routes import task_bp
from .patient_routes import patient_bp
from .doctor_routes import doctor_bp
from .invoice_routes import invoice_bp
from .chat_routes import chat_bp
from .call_routes import call_bp

def init_routes(app):
    app.register_blueprint(auth_bp)
    app.register_blueprint(appointment_bp)
    app.register_blueprint(task_bp)
    app.register_blueprint(patient_bp)
    app.register_blueprint(doctor_bp)
    app.register_blueprint(invoice_bp)
    app.register_blueprint(chat_bp)
    app.register_blueprint(call_bp)