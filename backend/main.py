import eventlet
eventlet.monkey_patch()


from socket_io_instance import socketio
from app_factory import create_app

app = create_app()

@socketio.on('connect')
def handle_connect():
    print(f'✅ Client connected to Socket.IO!')

@socketio.on('disconnect')
def handle_disconnect():
    print(f'❌ Client disconnected from Socket.IO!')

# ✅ Start server
if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)