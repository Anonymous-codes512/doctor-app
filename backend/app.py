from flask import Flask
from routes import init_routes
from config import Config
from extensions import db, migrate, jwt
from models import *  # Ensure models are registered (e.g., User)
from extensions import mail


app = Flask(__name__)
app.config.from_object(Config)

# ✅ Initialize extensions
db.init_app(app)
migrate.init_app(app, db)
jwt.init_app(app)
mail.init_app(app)

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
