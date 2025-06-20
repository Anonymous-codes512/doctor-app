from .auth_routes import auth_bp
from .appointment_routes import appointment_bp
from .task_routes import task_bp

def init_routes(app):
    app.register_blueprint(auth_bp)
    app.register_blueprint(appointment_bp)
    app.register_blueprint(task_bp)