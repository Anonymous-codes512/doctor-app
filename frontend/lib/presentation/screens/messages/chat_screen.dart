import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await _chatProvider.selectUserForChat(widget.user['id']);
    });
  }

  final List<_ChatMessage> messages = [
    _ChatMessage(
      text: "Hi, Mandy",
      isMe: true,
      avatarUrl: "https://randomuser.me/api/portraits/men/75.jpg",
    ),
    _ChatMessage(
      text: "I've tried the app",
      isMe: true,
      avatarUrl: "https://randomuser.me/api/portraits/men/75.jpg",
    ),
    _ChatMessage(
      text: "Really?",
      isMe: false,
      avatarUrl: "https://randomuser.me/api/portraits/women/65.jpg",
    ),
    _ChatMessage(
      text: "Yeah, It's really good!",
      isMe: true,
      avatarUrl: "https://randomuser.me/api/portraits/men/75.jpg",
    ),
  ];
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user);
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
      fixedImagePath = widget.user['avatar']?.replaceAll(r'\', '/');
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
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.textColor.withOpacity(0.3)),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                  color: AppColors.primaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
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
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: Icon(
                Icons.person_add_alt_1_outlined,
                size: 22,
                color: AppColors.primaryColor,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                '09:41 AM',
                style: TextStyle(
                  color: AppColors.backgroundColor.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        final msg = messages[messages.length - 1 - index];
        return _buildMessageItem(msg);
      },
    );
  }

  Widget _buildMessageItem(_ChatMessage msg) {
    final borderRadiusMe = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(msg.isMe ? 12 : 4),
      bottomRight: Radius.circular(msg.isMe ? 4 : 12),
    );

    final borderRadiusOther = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(msg.isMe ? 4 : 12),
      bottomRight: Radius.circular(msg.isMe ? 12 : 4),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!msg.isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(msg.avatarUrl),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: msg.isMe ? AppColors.primaryColor : AppColors.cardColor,
                borderRadius: msg.isMe ? borderRadiusMe : borderRadiusOther,
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  color:
                      msg.isMe
                          ? AppColors.backgroundColor
                          : AppColors.textColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (msg.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(msg.avatarUrl),
            ),
          ],
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
            onPressed: () {},
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

class _ChatMessage {
  final String text;
  final bool isMe;
  final String avatarUrl;

  _ChatMessage({
    required this.text,
    required this.isMe,
    required this.avatarUrl,
  });
}
