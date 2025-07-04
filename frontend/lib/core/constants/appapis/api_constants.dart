class ApiConstants {
  static const String socketUrl = 'http://192.168.100.12:5000';
  static const String imageBaseUrl = 'http://192.168.100.12:5000/';
  static const String baseUrl = 'http://192.168.100.12:5000/api';
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String sendResetCode = '$baseUrl/send-reset-code';
  static const String verifyResetOtp = '$baseUrl/verify-reset-otp';
  static const String resetPassword = '$baseUrl/reset-password';

  static const String fetchInvoices = '$baseUrl/fetch_invoices';
  static const String deleteInvoice = '$baseUrl/delete_invoice';
  static const String changeInvoiceStatus = '$baseUrl/change_invoice_status';

  static const String fetchAppointment = '$baseUrl/doctor_appointments';
  static const String createAppointment = '$baseUrl/create_appointment';

  static const String fetchTasks = '$baseUrl/fetch_tasks';
  static const String createTask = '$baseUrl/create_task';

  static const String fetchPatients = '$baseUrl/fetch_patients';
  static const String createPatient = '$baseUrl/create_patient';
  static const String updatePatientHistory = '$baseUrl/update_patient_history';

  static const String fetchNotes = '$baseUrl/fetch_notes';
  static const String createNote = '$baseUrl/create_note';
  static const String updateNote = '$baseUrl/update_note';

  static const String uploadMedia = '$baseUrl/upload_media';

  static const String createConversation = '$baseUrl/create_conversation';
  static const String getConversations = '$baseUrl/get_conversations';
  static const String getUsersForChat = '$baseUrl/get_users_for_chat';
  static const String sendMessage = '$baseUrl/send_message';
  static const String getMessages = '$baseUrl/get_messages';
}
