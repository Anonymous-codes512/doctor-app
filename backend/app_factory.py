from flask import Flask, jsonify
from flask_cors import CORS
from config import Config
from extensions import db, migrate, jwt, mail
from routes import init_routes
from socket_io_instance import init_socket_io
from models import *

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    CORS(app)

    app.config['JWT_TOKEN_LOCATION'] = ['headers']
    app.config['JWT_COOKIE_CSRF_PROTECT'] = False
    app.config['JWT_COOKIE_SECURE'] = False
    app.config['JWT_CSRF_IN_COOKIES'] = False

    # Init extensions
    db.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)
    mail.init_app(app)
    init_routes(app)
    init_socket_io(app)

    @jwt.invalid_token_loader
    def invalid_token_response(reason):
        return jsonify({'success': False, 'message': 'Invalid token'}), 422

    @jwt.unauthorized_loader
    def unauthorized_response(reason):
        return jsonify({'success': False, 'message': 'Missing or invalid token'}), 401

    @app.route('/')
    def home():
        return 'Doctor App Backend is running!'

    return app
