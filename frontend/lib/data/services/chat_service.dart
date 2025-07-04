import 'dart:convert';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/data/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
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

  // ✅ Get conversations for logged-in user
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    final token = await getToken();
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
    final token = await getToken();
    int? userId = await _getUserId();
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
    final token = await getToken();
    final userId = await _getUserId();
    final response = await http.post(
      Uri.parse(ApiConstants.createConversation),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'other_user_id': otherUserId, 'user_id': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create or fetch conversation');
    }
  }

  // ✅ Send encrypted message
  Future<bool> sendMessage(MessageModel message) async {
    try {
      final token = await getToken();
      final userId = await _getUserId();

      if (token == null) {
        print('🔴 Error: Token not found');
        return false;
      }

      if (userId == null) {
        print('🔴 Error: User ID not found');
        return false;
      }

      // 🔐 Embed senderId before sending
      final updatedMessage = MessageModel(
        conversationId: message.conversationId,
        encryptedMessage: message.encryptedMessage,
        messageType: message.messageType,
        senderId: userId,
        receiverId: message.receiverId,
        senderImage: message.senderImage,
        receiverImage: message.receiverImage,
        isRead: message.isRead,
        readAt: message.readAt,
        timestamp: message.timestamp,
        id: message.id,
      );

      final response = await http.post(
        Uri.parse(ApiConstants.sendMessage),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedMessage.toJson()),
      );

      if (response.statusCode == 201) {
        print('✅ Message sent successfully');
        return true;
      } else {
        print('🔴 Server Error [${response.statusCode}]: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      print('🔴 Exception sending message: $e');
      print('🔍 StackTrace: $stackTrace');
      return false;
    }
  }

  // ✅ Fetch messages for a conversation
  Future<List<MessageModel>> fetchMessages(int conversationId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.getMessages}/$conversationId'),
      headers: {'Authorization': 'Bearer $token'},
    );

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
