import 'dart:convert';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/data/models/notes_model.dart';
import 'package:doctor_app/data/models/task_model.dart';
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

  Future<Map<String, dynamic>> createTask(TaskModel task) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.createTask),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      final body = jsonDecode(response.body);
      print('🚨🚨$body🚨🚨');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': body['message'] ?? 'Task created successfully.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Failed to create task.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  Future<List<TaskModel>> fetchTasks(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.fetchTasks}/$userId'),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success']) {
        final List data = body['tasks'];
        return data.map((e) => TaskModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('❌ Error fetching tasks: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createNote(Note note, int doctorId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.createNote}/$doctorId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(note.toJson()),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': body['message'] ?? 'Note created successfully.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Failed to create note.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  Future<Map<String, dynamic>> updateNote(Note note, int noteId) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.updateNote}/$noteId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(note.toJson()),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': body['message'] ?? 'Note updated successfully.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Failed to update note.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }
}
