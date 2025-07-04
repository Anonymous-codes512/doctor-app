import 'dart:convert';
import 'dart:typed_data';

import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/message_model.dart';
import 'package:doctor_app/data/services/socket_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/data/services/chat_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();

  List<Map<String, dynamic>> _conversations = [];
  List<MessageModel> _messages = [];

  int? _selectedConversationId;
  String? _chatSecret;
  int? _otherUserId;

  int? _currentUserId; // Current user ID ko bhi store karein

  ChatProvider() {
    _socketService.onNewMessageReceived = _handleNewRealtimeMessage;
    _initCurrentUserId(); // ✅ Add this call
  }

  bool _isLoading = false;

  List<Map<String, dynamic>> get conversations => _conversations;
  List<MessageModel> get messages => _messages;

  int? get selectedConversationId => _selectedConversationId;
  String? get chatSecret => _chatSecret;
  bool get isLoading => _isLoading;

  Future<void> _initCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _currentUserId = jsonDecode(userJson)['id'];
      print('✅ ChatProvider: Current user ID set to $_currentUserId');
    } else {
      print('🔴 ChatProvider: User data not found in SharedPreferences.');
    }
  }

  // ✅ Real-time message receive hone par call hoga
  void _handleNewRealtimeMessage(Map<String, dynamic> messageData) {
    if (_currentUserId == null) {
      print(
        '🔴 Warning: _currentUserId is null when handling new real-time message.',
      );
      return;
    }

    if (messageData['conversation_id'] == _selectedConversationId) {
      final newMessage = MessageModel.fromJson(messageData);

      bool messageExistsById = _messages.any(
        (msg) => msg.id == newMessage.id && newMessage.id != null,
      );

      if (newMessage.senderId == _currentUserId) {
        int indexToUpdate = _messages.indexWhere(
          (msg) =>
              msg.senderId == _currentUserId &&
              msg.encryptedMessage == newMessage.encryptedMessage &&
              msg.id == null,
        );

        if (indexToUpdate != -1) {
          _messages[indexToUpdate] = newMessage;
          print('✅ Own sent message updated with server ID: ${newMessage.id}');
        } else {
          if (!messageExistsById) {
            _messages.add(newMessage);
            print(
              '✅ Own message added as it was not found as temp: ${newMessage.id}',
            );
          }
        }
      } else {
        if (!messageExistsById) {
          _messages.add(newMessage);
          print('✅ Received new message from other user: ${newMessage.id}');
        } else {
          print(
            'ℹ️ Received duplicate message by ID from other user. Not adding.',
          );
        }
      }
      _messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
      notifyListeners();
    }
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

    final iv = encrypt.IV.fromUtf8('1234567890123456'); // Same on IV as decrypt
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

    final tempMessage = MessageModel(
      conversationId: _selectedConversationId!,
      senderId: _currentUserId,
      receiverId: _otherUserId,
      encryptedMessage: encryptedText,
      messageType: messageType,
      timestamp: DateTime.now().toIso8601String(),
      isRead: false,
    );
    _messages.add(tempMessage);
    _messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
    notifyListeners();

    // Socket.IO ke zariye message bhejen
    final messageData = {
      "conversation_id": _selectedConversationId,
      "sender_id": _currentUserId,
      "receiver_id": _otherUserId,
      "encrypted_message": encryptedText,
      "message_type": messageType,
    };

    try {
      _socketService.sendMessageViaSocket(messageData);
    } catch (e) {
      print('❌ Error sending message via socket: $e');
      _messages.remove(tempMessage);
      notifyListeners();
    }
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

  // --- File/Camera/Audio Handling Functions (Moved to Provider) ---

  Future<void> pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(withData: true);

    if (result == null) return;

    final file = result.files.first;
    Uint8List? finalBytes = file.bytes;

    // If image file, compress it
    if (file.extension != null &&
        ['jpg', 'jpeg', 'png'].contains(file.extension!.toLowerCase())) {
      final decodedImage = img.decodeImage(file.bytes!);
      if (decodedImage != null) {
        finalBytes = Uint8List.fromList(
          img.encodeJpg(decodedImage, quality: 50),
        ); // Compress to 50% quality
      }
    }

    if (finalBytes != null && finalBytes.lengthInBytes <= 2 * 1024 * 1024) {
      final fileName = file.name;
      await sendMediaMessage(
        bytes: finalBytes,
        fileName: fileName,
        type: 'file',
        context: context,
      );
    } else {
      ToastHelper.showError(
        context,
        'File too large even after compression (max 2MB)',
      );
    }
  }

  Future<void> openCamera(BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      if (bytes.lengthInBytes <= 3 * 1024 * 1024) {
        await sendMediaMessage(
          bytes: bytes,
          fileName: pickedImage.name,
          type: 'image',
          context: context,
        );
      } else {
        ToastHelper.showError(context, 'Image too large (max 3MB)');
      }
    }
  }

  // This is a new function in ChatProvider to handle sending files/images/audio
  Future<void> sendMediaMessage({
    required Uint8List bytes,
    required String fileName,
    required String type,
    required BuildContext context,
  }) async {
    if (_chatSecret == null ||
        _selectedConversationId == null ||
        _otherUserId == null ||
        _currentUserId == null) {
      ToastHelper.showError(context, 'Chat session not initialized');
      return;
    }

    try {
      final token = await _chatService.getToken();
      var uri = Uri.parse(ApiConstants.uploadMedia);
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
          contentType: _getMediaType(type),
        ),
      );

      var response = await request.send();

      if (response.statusCode != 200) {
        ToastHelper.showError(
          context,
          'Upload failed (${response.statusCode})',
        );
        return;
      }

      final responseBody = await response.stream.bytesToString();
      final fileUrl = jsonDecode(responseBody)['file_url'];

      // Step 3: Create and show dummy message
      final message = MessageModel(
        conversationId: _selectedConversationId!,
        senderId: _currentUserId,
        receiverId: _otherUserId,
        encryptedMessage: fileUrl,
        messageType: type,
        timestamp: DateTime.now().toIso8601String(),
        isRead: false,
      );

      _messages.add(message);
      _messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
      notifyListeners();

      // Step 4: Send via socket
      _socketService.sendMessageViaSocket({
        "conversation_id": _selectedConversationId,
        "sender_id": _currentUserId,
        "receiver_id": _otherUserId,
        "encrypted_message": fileUrl,
        "message_type": type,
      });
    } catch (e) {
      print('❌ Error sending media message: $e');
      ToastHelper.showError(context, 'Failed to send media');
    }
  }

  MediaType _getMediaType(String type) {
    switch (type) {
      case 'image':
        return MediaType('image', 'jpeg');
      case 'audio':
        return MediaType('audio', 'aac');
      case 'file':
      default:
        return MediaType('application', 'octet-stream');
    }
  }
}
