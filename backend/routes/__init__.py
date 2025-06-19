from .auth_routes import auth_bp
from .appointment_routes import appointment_bp

def init_routes(app):
    app.register_blueprint(auth_bp)
    app.register_blueprint(appointment_bp)