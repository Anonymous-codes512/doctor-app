import 'dart:convert';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/data/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  Future<String?> _getToken() async {
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

  // ✅ Get conversations for logged-in user
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    final token = await _getToken();
    int? doctorUserId = await _getUserId();
    final response = await http.get(
      Uri.parse('${ApiConstants.getConversations}/$doctorUserId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
        jsonDecode(response.body)['conversations'],
      );
    } else {
      throw Exception('Failed to fetch conversations');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsersForChat() async {
    final token = await _getToken();
    int? userId = await _getUserId();
    print('Token : $token');
    final response = await http.get(
      Uri.parse('${ApiConstants.getUsersForChat}/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
        jsonDecode(response.body)['users'],
      );
    } else {
      throw Exception('Failed to fetch users for new chat');
    }
  }

  // ✅ Get or create a new conversation
  Future<Map<String, dynamic>> getOrCreateConversation(int otherUserId) async {
    final token = await _getToken();
    final userId = await _getUserId();
    final response = await http.post(
      Uri.parse(ApiConstants.createConversation),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'other_user_id': otherUserId, 'user_id': userId}),
    );

    print('🚨 Body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create or fetch conversation');
    }
  }

  // ✅ Send encrypted message
  Future<bool> sendMessage(MessageModel message) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.sendMessage),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(message.toJson()),
    );

    return response.statusCode == 201;
  }

  // ✅ Fetch messages for a conversation
  Future<List<MessageModel>> fetchMessages(int conversationId) async {
    print(conversationId);
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.getMessages}/$conversationId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print('🚨 Body: ${response.body}');

    if (response.statusCode == 200) {
      final messages = jsonDecode(response.body)['messages'];
      return List<MessageModel>.from(
        messages.map((msg) => MessageModel.fromJson(msg)),
      );
    } else {
      throw Exception('Failed to fetch messages');
    }
  }
}
