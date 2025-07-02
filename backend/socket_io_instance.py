from flask_socketio import SocketIO

socketio = SocketIO(async_mode="eventlet", cors_allowed_origins="*")

def init_socket_io(app):
    socketio.init_app(app)
