from flask.cli import FlaskGroup
from app import app
import click
from flask.cli import with_appcontext
from models.password_reset_otp import PasswordResetOTP

cli = FlaskGroup(app)

if __name__ == '__main__':
    cli()

@click.command('cleanup-expired-otps')
@with_appcontext
def cleanup_expired_otps():
    PasswordResetOTP.clean_expired()
    print("Expired OTPs cleaned up.")