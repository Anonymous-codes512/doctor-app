import 'package:doctor_app/data/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/data/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<Map<String, dynamic>> _conversations = [];
  List<MessageModel> _messages = [];

  int? _selectedConversationId;
  String? _chatSecret;
  int? _otherUserId;

  bool _isLoading = false;

  List<Map<String, dynamic>> get conversations => _conversations;
  List<MessageModel> get messages => _messages;

  int? get selectedConversationId => _selectedConversationId;
  String? get chatSecret => _chatSecret;
  bool get isLoading => _isLoading;

  // ✅ Load all past conversations
  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await _chatService.fetchConversations();
    } catch (e) {
      print("🔴 Error loading conversations: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchUsersForNewChat() async {
    return await _chatService.fetchUsersForChat();
  }

  // ✅ Select user to chat (either new or existing conversation)
  Future<void> selectUserForChat(int otherUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final convo = await _chatService.getOrCreateConversation(otherUserId);
      _selectedConversationId = convo['conversation_id'];
      _chatSecret = convo['chat_secret'];
      _otherUserId = otherUserId;

      await loadMessages();
    } catch (e) {
      print("🔴 Error selecting user for chat: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Load messages for current conversation
  Future<void> loadMessages() async {
    if (_selectedConversationId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _messages = await _chatService.fetchMessages(_selectedConversationId!);
    } catch (e) {
      print("🔴 Error loading messages: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Send new message (already encrypted)
  Future<void> sendMessage(String encryptedText, String messageType) async {
    if (_selectedConversationId == null || _otherUserId == null) return;

    final newMessage = MessageModel(
      conversationId: _selectedConversationId!,
      encryptedMessage: encryptedText,
      messageType: messageType,
    );

    final success = await _chatService.sendMessage(newMessage);
    if (success) {
      await loadMessages();
    }
  }

  // ✅ Clear current selection (optional)
  void clearChat() {
    _selectedConversationId = null;
    _chatSecret = null;
    _messages = [];
    _otherUserId = null;
    notifyListeners();
  }
}
