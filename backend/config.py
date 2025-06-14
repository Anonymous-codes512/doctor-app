class Config:
    SECRET_KEY = 'my-dev-secret-key'
    JWT_SECRET_KEY = 'my-jwt-secret-key'  # 🔐 Used to sign JWT tokens
    DEBUG = True
    HOST = '0.0.0.0'
    PORT = 5000
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:3264@localhost:5432/doctor_app'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
