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


@invoice_bp.route('/delete_invoice/<string:invoice_number>', methods=['DELETE'])
def delete_invoice(invoice_number):
    """
    Delete an invoice by its invoice_number.
    """
    try:
        invoice = Invoice.query.filter_by(invoice_number=invoice_number).first()
        if not invoice:
            return jsonify({
                'success': False,
                'message': 'Invoice not found.'
            }), 404

        db.session.delete(invoice)
        db.session.commit()
        return jsonify({
            'success': True,
            'message': 'Invoice deleted successfully.'
        }), 200

    except Exception as e:
        db.session.rollback()
        print(f"Error deleting invoice: {e}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while deleting the invoice.',
            'error': str(e)
        }), 500


@invoice_bp.route('/change_invoice_status/<string:invoice_number>', methods=['GET'])
def markAsPaid(invoice_number):
    """
    Mark an invoice as paid by its invoice_number.
    """
    try:
        invoice = Invoice.query.filter_by(invoice_number=invoice_number).first()
        if not invoice:
            return jsonify({
                'success': False,
                'message': 'Invoice not found.'
            }), 404

        invoice.payment_status = 'paid'
        db.session.commit()
        return jsonify({
            'success': True,
            'message': 'Invoice marked as paid successfully.'
        }), 200

    except Exception as e:
        db.session.rollback()
        print(f"Error marking invoice as paid: {e}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while marking the invoice as paid.',
            'error': str(e)
        }), 500