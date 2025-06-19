class ApiConstants {
  static const String baseUrl = 'http://192.168.100.12:5000/api';
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String sendResetCode = '$baseUrl/send-reset-code';
  static const String verifyResetOtp = '$baseUrl/verify-reset-otp';
  static const String resetPassword = '$baseUrl/reset-password';

  static const String fetchAppointment = '$baseUrl/doctor_appointments';
  static const String createAppointment = '$baseUrl/create_appointment';
}
