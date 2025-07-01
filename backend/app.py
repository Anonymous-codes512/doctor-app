from flask import Flask, jsonify
from routes import init_routes
from config import Config
from extensions import db, migrate, jwt
from models import *  # Ensure models are registered (e.g., User)
from extensions import mail


app = Flask(__name__)
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

# ✅ Test route for backend status
@app.route('/')
def home():
    print("✅ Flutter app just pinged the backend!")
    return 'Doctor App Backend is running!'

# ✅ Start server
if __name__ == '__main__':
    app.run(
        host=app.config['HOST'],
        port=app.config['PORT'],
        debug=app.config['DEBUG']
    )
