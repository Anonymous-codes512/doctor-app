// data/services/call_service.dart
import 'dart:convert';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/data/models/call_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallService {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      return jsonDecode(user)['id'];
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchCallHistory() async {
    final token = await getToken();
    int? doctorUserId = await _getUserId();
    final response = await http.get(
      Uri.parse('${ApiConstants.getCallHistory}/$doctorUserId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
        jsonDecode(response.body)['calls'],
      );
    } else {
      print('Failed to fetch call history: ${response.body}');
      throw Exception('Failed to fetch call history');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsersForCall() async {
    final token = await getToken();
    int? userId = await _getUserId();
    final response = await http.get(
      Uri.parse('${ApiConstants.getUsersForCall}/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
        jsonDecode(response.body)['users'],
      );
    } else {
      throw Exception('Failed to fetch users for new call');
    }
  }

  // ✅ Get or create a new conversation
  Future<Map<String, dynamic>> getOrCreateCallConversation(
    int otherUserId,
  ) async {
    final token = await getToken();
    final userId = await _getUserId();
    final response = await http.post(
      Uri.parse(ApiConstants.createCallConversation),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'other_user_id': otherUserId, 'user_id': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create or fetch call conversation');
    }
  }

  // ✅ Fetch messages for a conversation
  Future<List<CallModel>> fetchCalls(int callConversationId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.getCalls}/$callConversationId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final calls = jsonDecode(response.body)['calls'];
      return List<CallModel>.from(
        calls.map((call) => CallModel.fromJson(call)),
      );
    } else {
      throw Exception('Failed to fetch caalls');
    }
  }
}
