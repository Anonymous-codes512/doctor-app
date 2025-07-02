import eventlet
eventlet.monkey_patch()

from flask import Flask, jsonify
from flask_cors import CORS
from socket_io_instance import socketio, init_socket_io
from routes import init_routes
from config import Config
from extensions import db, migrate, jwt
from models import *
from extensions import mail

app = Flask(__name__)
CORS(app)

app.config.from_object(Config)

app.config['JWT_TOKEN_LOCATION'] = ['headers']
app.config['JWT_COOKIE_CSRF_PROTECT'] = False
app.config['JWT_COOKIE_SECURE'] = False
app.config['JWT_CSRF_IN_COOKIES'] = False

# ✅ Initialize extensions
db.init_app(app)
migrate.init_app(app, db)
jwt.init_app(app)
mail.init_app(app)

@jwt.invalid_token_loader
def invalid_token_response(reason):
    print("❌ Invalid token reason:", reason)
    return jsonify({'success': False, 'message': 'Invalid token'}), 422

@jwt.unauthorized_loader
def unauthorized_response(reason):
    print("❌ Unauthorized reason:", reason)
    return jsonify({'success': False, 'message': 'Missing or invalid token'}), 401


# ✅ Register all route blueprints
init_routes(app)

init_socket_io(app)

# --- Socket.IO Connection/Disconnection Handlers ---
# Yeh handlers add kiye gaye hain taake aapko console mein connection status dikhe.
@socketio.on('connect')
def handle_connect():
    # Is function ko tab call kiya jayega jab koi client Socket.IO se connect hoga.
    # request.sid (session ID) se aap har client ko identify kar sakte hain.
    print(f'✅ Client connected to Socket.IO!')

@socketio.on('disconnect')
def handle_disconnect():
    # Is function ko tab call kiya jayega jab koi client Socket.IO se disconnect hoga.
    print(f'❌ Client disconnected from Socket.IO!')
# --- End of Socket.IO Handlers ---


# ✅ Test route for backend status
@app.route('/')
def home():
    print("✅ Flutter app just pinged the backend!")
    return 'Doctor App Backend is running!'

# ✅ Start server
if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)