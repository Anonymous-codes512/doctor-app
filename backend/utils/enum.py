from sqlalchemy.dialects.postgresql import ENUM

UserRole = ENUM("DOCTOR", "PATIENT", name="userrole", create_type=True)
Gender = ENUM("male", "female", "other", name="gender", create_type=True)
AppointmentMode = ENUM("online", "in-person", name="appointment_mode", create_type=True)
AppointmentStatus = ENUM("confirmed", "canceled", "pending", name="appointment_status", create_type=True)
AppointmentReason = ENUM("consultation", "follow-up","check-up" ,name="appointment_reason", create_type=True)
PaymentMode = ENUM("cash", "credit card", "bank transfer", "cheque", name="payment_mode", create_type=True)
PaymentStatus = ENUM("paid", "pending", "overdue", name="payment_status", create_type=True)
