// FINAL VERSION - Custom Audio Call Integration with Agora and Socket.io

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:provider/provider.dart';
import 'package:doctor_app/data/services/socket_service.dart';
import 'package:doctor_app/provider/call_provider.dart';

class CallingScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const CallingScreen({super.key, required this.user});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  late CallProvider _callProvider;
  late SocketService _socketService;
  late RtcEngine _engine;

  bool isTranscribing = false;
  bool isJoined = false;
  late String _channelName;
  late String _token;

  final String agoraAppId = "71ecc755b7734f29a9b621718daa394e";

  @override
  void initState() {
    super.initState();
    _callProvider = Provider.of<CallProvider>(context, listen: false);
    _socketService = Provider.of<SocketService>(context, listen: false);
    _socketService.onCallEnded = _handleCallEnded;
    _channelName = _callProvider.agoraChannelName!;
    _token = _callProvider.agoraToken!;
    initAgora();
    // _socketService.onCallEnded = _handleCallEnded;
  }

  Future<void> initAgora() async {
    await [Permission.microphone].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: agoraAppId));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (conn, uid) {
          setState(() => isJoined = true);
        },
        onUserOffline: (conn, remoteUid, reason) {
          Navigator.of(context).pop();
        },
        onLeaveChannel: (conn, stats) {
          setState(() => isJoined = false);
        },
      ),
    );

    await _engine.enableAudio();
    await _engine.joinChannel(
      token: _token,
      channelId: _channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void _handleCallEnded(Map<String, dynamic> data) {
    print('📞 Call ended received: $data');

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    _socketService.onCallEnded = null;
    super.dispose();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : parts[0][0].toUpperCase();
  }

  void _toggleTranscribe(bool value) async {
    setState(() {
      isTranscribing = value;
    });

    if (value) {
      await _showTranscriptionSheet();
    }
  }

  Future<void> _showTranscriptionSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TranscriptionBottomSheet(),
    );
    // Do NOT turn off toggle when sheet closes
  }

  void _openTranscriptionAgain() {
    if (isTranscribing) {
      _showTranscriptionSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? fixedImagePath;
    if (widget.user['avatar'] != null && widget.user['avatar'].isNotEmpty) {
      fixedImagePath = widget.user['avatar'].replaceAll(r'\', '/');
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

    return Scaffold(
      backgroundColor: const Color(0xFFEEE9F5),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'Calling...',
                style: TextStyle(fontSize: 14, color: AppColors.textColor),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Transcribe',
                    style: TextStyle(fontSize: 14, color: AppColors.textColor),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: isTranscribing,
                    onChanged: _toggleTranscribe,
                    activeColor: AppColors.primaryColor,
                  ),
                  if (isTranscribing)
                    IconButton(
                      icon: const Icon(Icons.subdirectory_arrow_left),
                      tooltip: 'Open Transcription',
                      onPressed: _openTranscriptionAgain,
                    ),
                ],
              ),
              const SizedBox(height: 50),
              CircleAvatar(
                backgroundImage: avatarImage,
                radius: 75,
                backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                child:
                    avatarImage == null
                        ? Text(
                          _getInitials(widget.user['name']),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.primaryColor,
                          ),
                        )
                        : null,
              ),
              const SizedBox(height: 20),
              Text(
                widget.user['phone_number'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAction(Icons.mic_rounded, 'Record'),
                    _buildAction(Icons.mic_off, 'Mute'),
                    _buildAction(Icons.volume_up, 'Speaker'),
                    // _buildAction(Icons.person_add, 'Add'),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () async {
                  await _engine.leaveChannel();
                  _callProvider.endCall(
                    callStatus: 'cancelled',
                    context: context,
                  );
                  Navigator.popAndPushNamed(
                    context,
                    Routes.allVoiceCallsScreen,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18),
                ),
                child: const Icon(Icons.call_end, color: Colors.white),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildAction(IconData icon, String label) {
  return Column(
    children: [
      CircleAvatar(
        backgroundColor: AppColors.iconBackgroundColor,
        child: Icon(icon, color: AppColors.textColor),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.textColor),
      ),
    ],
  );
}

class TranscriptionBottomSheet extends StatelessWidget {
  const TranscriptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Align(
              //   alignment: Alignment.topRight,
              //   child: GestureDetector(
              //     onTap: () => Navigator.pop(context),
              //     child: const Icon(
              //       Icons.close,
              //       size: 28,
              //       color: AppColors.textColor,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),

              const Text(
                'Date: May 25, 2025',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Time: 10:30 AM',
                style: TextStyle(fontSize: 16, color: AppColors.textColor),
              ),
              const SizedBox(height: 4),
              const Text(
                'Patient: Sarah Ahmed',
                style: TextStyle(fontSize: 16, color: AppColors.textColor),
              ),
              const SizedBox(height: 4),
              const Text(
                'Psychiatrist: Dr. Khalid Mehmood',
                style: TextStyle(fontSize: 16, color: AppColors.textColor),
              ),

              const SizedBox(height: 24),

              const Text(
                'Call Transcription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.infoColor),
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.backgroundColor,
                  ),
                  child: const SingleChildScrollView(
                    child: Text(
                      '''Patient: I'm a bit anxious, to be honest. I had trouble sleeping last night.

Psychiatrist: I see. Can you tell me what was on your mind while trying to sleep?

Patient: I kept replaying some past conversations and worrying about work deadlines.

Psychiatrist: That's understandable. Let's talk through those thoughts one at a time.''',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
