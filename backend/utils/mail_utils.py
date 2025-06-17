from flask_mail import Message
from flask import render_template
from extensions import mail

def send_confirmation_email(to_email, user_name, token):
    confirm_url = f"http://localhost:5000/api/confirm-email/{token}"  # Adjust for frontend if needed
    html = render_template('emails/confirmation_email.html', name=user_name, confirm_url=confirm_url)
    msg = Message(subject='Confirm Your Email', recipients=[to_email], html=html)
    mail.send(msg)

def send_reset_otp_email(email, name, otp):
    subject = 'Your Password Reset OTP'
    html_body = render_template('emails/reset_otp.html', name=name, otp=otp)
    msg = Message(subject=subject, recipients=[email], html=html_body)
    mail.send(msg)