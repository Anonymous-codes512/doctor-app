from flask import request, jsonify, Blueprint
from models import Doctor, Invoice, Patient
from extensions import db
from sqlalchemy.orm import joinedload

invoice_bp = Blueprint('invoice', __name__, url_prefix='/api')

@invoice_bp.route('/fetch_invoices/<int:user_id>', methods=['GET'])
def fetch_invoices(user_id):
    """
    Fetch all invoices of patients associated with the doctor linked to the given user_id.
    """
    try:
        # Load doctor with patients and their invoices eagerly
        doctor = Doctor.query.options(
            joinedload(Doctor.patients)
            .joinedload(Patient.invoices)
        ).filter_by(user_id=user_id).first()

        if not doctor:
            return jsonify({
                'success': False,
                'message': 'No doctor found for this user.'
            }), 404

        invoices_data = []
        for patient in doctor.patients:
            if not patient.user:
                continue  # avoid crash if patient.user is None
            for invoice in patient.invoices:
                invoices_data.append({
                    'id': invoice.id,
                    'patient_id': invoice.patient_id,
                    'patient_name': patient.user.name,
                    'invoice_number': invoice.invoice_number,
                    'amount_due': float(invoice.amount_due),
                    'due_date': invoice.due_date.isoformat(),
                    'payment_status': invoice.payment_status,
                })

        if not invoices_data:
            return jsonify({
                'success': False,
                'message': 'No invoices found for the doctor\'s patients.'
            }), 404

        return jsonify({
            'success': True,
            'invoices': invoices_data
        }), 200

    except Exception as e:
        print(f"Error fetching invoices: {e}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while fetching invoices.',
            'error': str(e)
        }), 500
