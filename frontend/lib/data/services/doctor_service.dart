import 'dart:convert';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();

    print("🔍 Fetching SharedPreferences...");
    print("📦 Raw JSON: ${prefs.getString('user')}");

    final userJson = prefs.getString('user');
    if (userJson == null) return 'User';

    final userMap = jsonDecode(userJson);
    return userMap['name'] ?? 'User';
  }

  Future<Map<String, String>> getHomeHeaderData() async {
    final name = await getUserName();
    final greeting = getGreetingMessage();
    return {'name': name, 'greeting': greeting};
  }

  Future<Map<String, dynamic>> createAppointment(
    AppointmentModel appointment,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.createAppointment),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(appointment.toJson()),
      );
      final body = jsonDecode(response.body);
      print('🚨🚨$body🚨🚨');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': body['message'] ?? 'Appointment created successfully.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Failed to create appointment.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  Future<List<AppointmentModel>> fetchAppointments(int doctorId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.fetchAppointment}/$doctorId'),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success']) {
        final List data = body['appointments'];
        return data.map((e) => AppointmentModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('❌ Error fetching appointments: $e');
      return [];
    }
  }
}
