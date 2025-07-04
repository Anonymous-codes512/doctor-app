import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/presentation/widgets/audio_message_widget.dart';
import 'package:doctor_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  late ChatProvider _chatProvider;

  // Voice recording variables
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  bool _isLockedRecording = false;
  bool _isRecordingCancelled = false;
  int _recordingDuration = 0;
  Timer? _recordTimer;
  String? _recordingPath;

  // Gesture tracking variables
  double _initialPressDy = 0.0;
  double _currentPressDy = 0.0;
  double _dragOffsetX = 0.0;
  double _deleteButtonOpacity = 0.0;

  // Animation controllers
  late AnimationController _micAnimationController;
  late Animation<double> _micScaleAnimation;
  late Animation<double> _micSlideAnimation;

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _chatProvider.selectUserForChat(widget.user['user_id']);
    });

    _initRecorder();
    _initAnimations();
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ToastHelper.showError(context, 'Microphone permission not granted!');
    } else {
      await _recorder!.openRecorder();
    }
  }

  void _initAnimations() {
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _micScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeOut),
    );

    _micSlideAnimation = Tween<double>(begin: 0.0, end: -50.0).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeOut),
    );
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

  Future<void> _startAudioRecording(LongPressStartDetails details) async {
    if (!await _recorder!.isEncoderSupported(Codec.aacADTS)) {
      ToastHelper.showError(
        context,
        'Audio codec not supported on this device',
      );
      return;
    }

    _isRecordingCancelled = false;
    _isLockedRecording = false;
    _recordingDuration = 0;
    _dragOffsetX = 0.0;
    _deleteButtonOpacity = 0.0;
    _initialPressDy = details.globalPosition.dy;

    final dir = await getTemporaryDirectory();
    _recordingPath =
        '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.aac';

    try {
      await _recorder!.startRecorder(
        toFile: _recordingPath,
        codec: Codec.aacADTS,
        audioSource: AudioSource.microphone,
      );

      setState(() {
        _isRecording = true;
        _messageController.clear();
        _isTyping = false;
        _micAnimationController.forward();
      });

      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_isRecording) {
          timer.cancel();
          return;
        }
        setState(() {
          _recordingDuration++;
          if (_isLockedRecording && _recordingDuration >= 1) {
            _deleteButtonOpacity = 1.0;
          }
        });
      });
    } catch (e) {
      ToastHelper.showError(context, 'Failed to start recording: $e');
      _resetRecordingState();
    }
  }

  Future<void> _stopAndSendAudio() async {
    if (!_isRecording) return;

    _micAnimationController.reverse();
    _recordTimer?.cancel();
    final finalPath = await _recorder?.stopRecorder();

    setState(() {
      _isRecording = false;
      _isLockedRecording = false;
      _recordingDuration = 0;
      _dragOffsetX = 0.0;
      _deleteButtonOpacity = 0.0;
    });

    if (finalPath != null && !_isRecordingCancelled) {
      final audioBytes = await File(finalPath).readAsBytes();
      final uniqueFileName =
          'voice_note_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _chatProvider.sendMediaMessage(
        bytes: audioBytes,
        fileName: uniqueFileName,
        type: 'audio',
        context: context,
      );
      File(finalPath).delete();
    } else {
      if (_recordingPath != null && await File(_recordingPath!).exists()) {
        File(_recordingPath!).delete();
      }
    }
    _isRecordingCancelled = false;
    _recordingPath = null;
  }

  void _cancelRecording() async {
    if (!_isRecording) return;

    _micAnimationController.reverse();
    _recordTimer?.cancel();
    await _recorder?.stopRecorder();

    setState(() {
      _isRecording = false;
      _isLockedRecording = false;
      _isRecordingCancelled = true;
      _recordingDuration = 0;
      _dragOffsetX = 0.0;
      _deleteButtonOpacity = 0.0;
    });

    if (_recordingPath != null && await File(_recordingPath!).exists()) {
      File(_recordingPath!).delete();
    }
    _recordingPath = null;
    ToastHelper.showInfo(context, 'Recording cancelled');
  }

  void _lockRecording() {
    setState(() {
      _isLockedRecording = true;
      _micAnimationController.reverse();
    });
  }

  void _resetRecordingState() {
    _micAnimationController.reverse();
    _recordTimer?.cancel();
    setState(() {
      _isRecording = false;
      _isLockedRecording = false;
      _isRecordingCancelled = false;
      _recordingDuration = 0;
      _dragOffsetX = 0.0;
      _deleteButtonOpacity = 0.0;
    });
    if (_recordingPath != null && File(_recordingPath!).existsSync()) {
      File(_recordingPath!).deleteSync();
    }
    _recordingPath = null;
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _recorder?.closeRecorder();
    _recorder = null;
    _recordTimer?.cancel();
    _micAnimationController.dispose();
    super.dispose();
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
            if (_isTyping && !_isRecording) _buildTypingIndicator(),
            _buildInputArea(context),
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

                String decryptedMessage;
                if (msg.messageType == 'text') {
                  decryptedMessage = _chatProvider.decryptMessage(
                    msg.encryptedMessage!,
                    _chatProvider.chatSecret!,
                  );
                } else {
                  decryptedMessage = msg.encryptedMessage!;
                }

                return _buildMessageItem(
                  decryptedMessage,
                  isMe,
                  msg.messageType!,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMessageItem(String text, bool isMe, String type) {
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isMe ? 12 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 12),
    );

    Widget content;

    String? fixedImagePath;
    String? mediaUrl;

    if (text.isNotEmpty) {
      fixedImagePath = text.replaceAll(r'\', '/');
    }

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
      mediaUrl = '$fullUrl/$cleanedPath';
    } else {
      mediaUrl = null;
    }

    if (type == 'image') {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:
            mediaUrl != null
                ? Image.network(
                  mediaUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                )
                : const Icon(Icons.broken_image),
      );
    } else if (type == 'audio') {
      content = AudioMessageWidget(
        audioUrl: mediaUrl ?? '',
        isMe: isMe,
        backgroundColor: isMe ? AppColors.primaryColor : AppColors.cardColor,
        textColor: isMe ? AppColors.backgroundColor : AppColors.textColor,
      );
    } else if (type == 'file') {
      content = Row(
        children: [
          const Icon(Icons.insert_drive_file),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.split('/').last,
              style: TextStyle(
                color: isMe ? AppColors.backgroundColor : AppColors.textColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    } else {
      content = Text(
        text,
        style: TextStyle(
          color: isMe ? AppColors.backgroundColor : AppColors.textColor,
          fontSize: 14,
        ),
      );
    }

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
              child: content,
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
            backgroundImage: const NetworkImage(
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

  Widget _buildInputArea(BuildContext context) {
    // Calculate mic button offset based on drag
    double micButtonOffsetY = 0;
    if (_isRecording && !_isLockedRecording) {
      micButtonOffsetY = (_initialPressDy - _currentPressDy).clamp(0, 100);
      micButtonOffsetY = -micButtonOffsetY;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      constraints: const BoxConstraints(
        minHeight: 50, // Add minimum height constraint
      ),
      child: SizedBox(
        height: 50, // Fixed height for the input area
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            // Normal input field (hidden during recording)
            if (!_isRecording)
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: AppColors.textColor.withOpacity(0.7),
                      ),
                      onPressed: () => _chatProvider.pickFile(context),
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 35,
                          maxHeight: 150,
                        ),
                        child: TextField(
                          controller: _messageController,
                          onChanged:
                              (text) =>
                                  setState(() => _isTyping = text.isNotEmpty),
                          maxLines: null,
                          minLines: 1,
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
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: AppColors.textColor.withOpacity(0.7),
                      ),
                      onPressed: () async {
                        final text = _messageController.text.trim();
                        if (text.isEmpty || _chatProvider.chatSecret == null) {
                          return;
                        }

                        final encrypted = _chatProvider.encryptMessage(
                          text,
                          _chatProvider.chatSecret!,
                        );
                        await _chatProvider.sendMessage(encrypted, 'text');
                        _messageController.clear();
                        setState(() {
                          _isTyping = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.photo_camera_outlined,
                        color: AppColors.textColor.withOpacity(0.7),
                      ),
                      onPressed: () => _chatProvider.openCamera(context),
                    ),
                  ],
                ),
              ),

            // Recording UI (shown during recording)
            if (_isRecording)
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Delete button (shown when locked)
                      AnimatedOpacity(
                        opacity: _deleteButtonOpacity,
                        duration: const Duration(milliseconds: 200),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: AppColors.errorColor,
                            size: 24,
                          ),
                          onPressed:
                              _isLockedRecording ? _cancelRecording : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Recording timer
                      Text(
                        _formatDuration(_recordingDuration),
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      // Slide to cancel text
                      if (!_isLockedRecording)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            _dragOffsetX < -80
                                ? 'Release to cancel'
                                : 'Slide to cancel <',
                            style: TextStyle(
                              color:
                                  _dragOffsetX < -80
                                      ? AppColors.errorColor
                                      : AppColors.textColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      // Lock icon (shown when sliding up)
                      if (_isRecording &&
                          !_isLockedRecording &&
                          micButtonOffsetY < -50)
                        Icon(
                          Icons.lock,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      const SizedBox(width: 10),
                      // Space for mic button
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
              ),

            // Mic button (always positioned at the right)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onLongPressStart: (details) {
                  if (!_isRecording) _startAudioRecording(details);
                },
                onLongPressEnd: (details) {
                  if (_isRecording && !_isLockedRecording) {
                    _stopAndSendAudio();
                  }
                },
                onLongPressMoveUpdate: (details) {
                  if (_isRecording && !_isLockedRecording) {
                    setState(() {
                      _currentPressDy = details.globalPosition.dy;
                      _dragOffsetX =
                          details.globalPosition.dx -
                          (MediaQuery.of(context).size.width - 12 - 25);
                    });

                    // Cancel if dragged left
                    if (_dragOffsetX < -80) {
                      _cancelRecording();
                    }

                    // Lock if dragged up
                    final dragAmount = _initialPressDy - _currentPressDy;
                    if (dragAmount > 100) {
                      _lockRecording();
                    }
                  }
                },
                child: AnimatedBuilder(
                  animation: _micAnimationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, micButtonOffsetY),
                      child: ScaleTransition(
                        scale: _micScaleAnimation,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(
                            _isRecording && _isLockedRecording
                                ? Icons.send
                                : Icons.mic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Send button (shown when recording is locked)
            if (_isLockedRecording)
              Positioned(
                right: 60,
                bottom: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                  onPressed: _stopAndSendAudio,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
