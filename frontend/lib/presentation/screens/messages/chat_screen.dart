import 'dart:convert';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  late ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _chatProvider.selectUserForChat(widget.user['user_id']);
    });
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  Future<int?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      return jsonDecode(user)['id'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 10),
            Expanded(child: _buildMessageList()),
            if (_isTyping) _buildTypingIndicator(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    String? fixedImagePath;
    if (widget.user['avatar'] != null && widget.user['avatar']!.isNotEmpty) {
      fixedImagePath = widget.user['avatar']?.replaceAll(r'\\', '/');
    }
    ImageProvider? avatarImage;
    if (fixedImagePath != null && fixedImagePath.isNotEmpty) {
      final fullUrl =
          ApiConstants.imageBaseUrl.endsWith('/')
              ? ApiConstants.imageBaseUrl.substring(
                0,
                ApiConstants.imageBaseUrl.length - 1,
              )
              : ApiConstants.imageBaseUrl;
      final cleanedPath =
          fixedImagePath.startsWith('/')
              ? fixedImagePath.substring(1)
              : fixedImagePath;
      final imageUrl = '$fullUrl/$cleanedPath';
      avatarImage = NetworkImage(imageUrl);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 15,
              color: AppColors.primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 12,
            backgroundImage: avatarImage,
            backgroundColor: AppColors.primaryColor.withOpacity(0.3),
            child:
                avatarImage == null
                    ? Text(
                      _getInitials(widget.user['name']),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: 12),
          Text(
            widget.user['name'],
            style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.person_add_alt_1_outlined,
              size: 22,
              color: AppColors.primaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return FutureBuilder<int?>(
      future: _getCurrentUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final userId = snapshot.data;

        return Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            final messages = chatProvider.messages;

            return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                final isMe = msg.senderId == userId;
                final decryptedMessage = _chatProvider.decryptMessage(
                  msg.encryptedMessage!,
                  _chatProvider.chatSecret!,
                );
                return _buildMessageItem(decryptedMessage, isMe);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMessageItem(String text, bool isMe) {
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isMe ? 12 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 12),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primaryColor : AppColors.cardColor,
                borderRadius: borderRadius,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? AppColors.backgroundColor : AppColors.textColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, bottom: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(
              "https://randomuser.me/api/portraits/women/65.jpg",
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Typing...',
            style: TextStyle(
              color: AppColors.textColor.withOpacity(0.8),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(color: AppColors.backgroundColor),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.textColor.withOpacity(0.7)),
            onPressed: () {},
          ),
          Expanded(
            child: SizedBox(
              height: 35,
              child: Center(
                child: TextField(
                  controller: _messageController,
                  onChanged: (text) {
                    setState(() {
                      _isTyping = text.isNotEmpty;
                    });
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type your message',
                    hintStyle: TextStyle(
                      color: AppColors.textColor.withOpacity(0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  style: TextStyle(fontSize: 15, color: AppColors.textColor),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.textColor.withOpacity(0.7)),
            onPressed: () async {
              final text = _messageController.text.trim();
              if (text.isEmpty || _chatProvider.chatSecret == null) return;

              final encrypted = _chatProvider.encryptMessage(
                text,
                _chatProvider.chatSecret!,
              );

              // ✅ Ab sendMessage ChatProvider ke zariye call hoga
              // Aur ChatProvider khud hi decide karega ke Socket.IO se bhejna hai
              await _chatProvider.sendMessage(encrypted, 'text');
              _messageController.clear();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.photo_camera_outlined,
              color: AppColors.textColor.withOpacity(0.7),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.mic_none,
              color: AppColors.textColor.withOpacity(0.7),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
