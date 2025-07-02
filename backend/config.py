from datetime import timedelta

class Config:
    SECRET_KEY = 'my-dev-secret-key'
    JWT_SECRET_KEY = 'my-jwt-secret-key'
    
    JWT_TOKEN_LOCATION = ['headers']
    JWT_COOKIE_CSRF_PROTECT = False
    JWT_COOKIE_SECURE = False
    JWT_CSRF_IN_COOKIES = False
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=12)

    SOCKETIO_CORS_ALLOWED_ORIGINS = "*"  # or list of specific origins

    DEBUG = True
    HOST = '0.0.0.0'
    PORT = 5000
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:3264@localhost:5432/doctor_app'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # ✉️ E mail setup
    MAIL_SERVER = 'smtp.titan.email'
    MAIL_PORT = 587
    MAIL_USE_TLS = True
    MAIL_USERNAME = 'danish@goftechsolutions.com'
    MAIL_PASSWORD = '#Hk/2e3)*!p6?eJ'
    MAIL_DEFAULT_SENDER = 'danish@goftechsolutions.com'

