import 'dart:convert';

import 'package:doctor_app/data/models/message_model.dart';
import 'package:doctor_app/data/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/data/services/chat_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();

  List<Map<String, dynamic>> _conversations = [];
  List<MessageModel> _messages = [];

  int? _selectedConversationId;
  String? _chatSecret;
  int? _otherUserId;

  int? _currentUserId; // Current user ID ko bhi store karein

  bool _isLoading = false;

  List<Map<String, dynamic>> get conversations => _conversations;
  List<MessageModel> get messages => _messages;

  int? get selectedConversationId => _selectedConversationId;
  String? get chatSecret => _chatSecret;
  bool get isLoading => _isLoading;
  ChatProvider() {
    _socketService.onNewMessageReceived = _handleNewRealtimeMessage;
  }

  // ✅ Real-time message receive hone par call hoga
  void _handleNewRealtimeMessage(Map<String, dynamic> messageData) {
    // Check karein kya yeh message current conversation ka hai
    if (messageData['conversation_id'] == _selectedConversationId) {
      final newMessage = MessageModel.fromJson(messageData);
      // Agar message current user ne bheja hai to usko dobara add na karein
      // Kyunki woh pehle hi UI mein add ho chuka hoga send karte waqt.
      // Agar woh doosre user ka hai, ya current user ka hai lekin uski ID
      // list mein nahi hai, tab hi add karein.

      // Better approach: Check if message with this ID already exists
      // Assuming 'id' is unique for messages
      bool messageExists = _messages.any((msg) => msg.id == newMessage.id);

      if (!messageExists) {
        _messages.add(newMessage);
        _messages.sort(
          (a, b) => a.timestamp!.compareTo(b.timestamp!),
        ); // Sort by timestamp
        notifyListeners();
      }
    }
    // Har naye message par conversations list ko refresh karein
    // taake last message aur unread count update ho sakein.
    loadConversations();
  }

  String encryptMessage(String plainText, String key) {
    String normalizedKey = key.padRight(32, '0').substring(0, 32);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        encrypt.Key.fromUtf8(normalizedKey),
        mode: encrypt.AESMode.cbc,
      ),
    );

    final iv = encrypt.IV.fromUtf8(
      '1234567890123456',
    ); // MUST be same on decrypt
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptMessage(String encryptedText, String key) {
    String normalizedKey = key.padRight(32, '0').substring(0, 32);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        encrypt.Key.fromUtf8(normalizedKey),
        mode: encrypt.AESMode.cbc,
      ),
    );

    final iv = encrypt.IV.fromUtf8('1234567890123456'); // Same IV as encryption
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

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
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      _currentUserId = jsonDecode(user)['id'];
    }

    if (_selectedConversationId == null ||
        _otherUserId == null ||
        _currentUserId == null) {
      print(
        "⚠️ Cannot send message: Missing conversation ID = $_selectedConversationId, other user ID = $_otherUserId, or current user ID = $_currentUserId.",
      );
      return;
    }

    // Temporary message bana kar UI mein add karein for instant display
    final tempMessage = MessageModel(
      conversationId: _selectedConversationId!,
      senderId: _currentUserId,
      receiverId: _otherUserId,
      encryptedMessage: encryptedText,
      messageType: messageType,
      timestamp:
          DateTime.now()
              .toIso8601String(), // Local timestamp for immediate display
      isRead: false, // Initially false
    );
    _messages.add(tempMessage);
    _messages.sort(
      (a, b) => a.timestamp!.compareTo(b.timestamp!),
    ); // Keep sorted
    notifyListeners();

    // Socket.IO ke zariye message bhejen
    final messageData = {
      "conversation_id": _selectedConversationId,
      "sender_id": _currentUserId,
      "receiver_id": _otherUserId,
      "encrypted_message": encryptedText,
      "message_type": messageType,
    };
    _socketService.sendMessageViaSocket(
      messageData,
    ); // ✅ Ab Socket.IO se send ho raha hai

    // Agar aapko HTTP fallback chahiye to yahan call kar sakte hain
    // final success = await _chatService.sendMessage(newMessage);
    // if (success) {
    //   await loadMessages(); // Refresh messages from API if HTTP is used
    // }
  }

  // ✅ Clear current selection (optional)
  void clearChat() {
    _selectedConversationId = null;
    _chatSecret = null;
    _messages = [];
    _otherUserId = null;
    _currentUserId = null;
    notifyListeners();
  }
}
