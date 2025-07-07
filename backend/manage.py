# manage.py

from flask.cli import FlaskGroup
from app_factory import create_app 
import click
from flask.cli import with_appcontext
from models.password_reset_otp import PasswordResetOTP

# 🔥 This is the missing piece
cli = FlaskGroup(create_app=create_app)

@click.command('cleanup-expired-otps')
@with_appcontext
def cleanup_expired_otps():
    PasswordResetOTP.clean_expired()
    print("Expired OTPs cleaned up.")

cli.add_command(cleanup_expired_otps)

if __name__ == '__main__':
    cli()
