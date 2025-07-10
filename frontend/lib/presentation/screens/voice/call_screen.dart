// import 'package:doctor_app/core/assets/colors/app_colors.dart';
// import 'package:doctor_app/presentation/screens/video/video_calling_screen.dart';
// import 'package:doctor_app/presentation/screens/voice/calling_screen.dart';
// import 'package:doctor_app/provider/call_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CallScreen extends StatefulWidget {
//   final Map<String, dynamic> user;
//   const CallScreen({super.key, required this.user});

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> with WidgetsBindingObserver {
//   final TextEditingController _controller = TextEditingController(text: '+92');

//   late CallProvider _callProvider; // CallProvider ka instance

//   @override
//   void initState() {
//     super.initState();
//     _callProvider = Provider.of<CallProvider>(context, listen: false);
//     WidgetsBinding.instance.addObserver(this);
//     _listenToCallEventsAndNavigate();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _controller.dispose();
//     super.dispose();
//   }

//   void _listenToCallEventsAndNavigate() {
//     _callProvider.addListener(() {
//       if (_callProvider.isIncomingCall) {
//         print("UI: Incoming call detected by provider!");
//       } else if (_callProvider.currentCallRecordId != null &&
//           _callProvider.incomingCallData == null) {
//         final currentRoute = ModalRoute.of(context);
//         if (currentRoute == null ||
//             (currentRoute.settings.name != '/callingScreen' &&
//                 currentRoute.settings.name != '/videoCallingScreen')) {
//           if (_callProvider.currentCallType == 'video') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (context) => VideoCallingScreen(
//                       callRecordId: _callProvider.currentCallRecordId!,
//                       callerId: _callProvider.currentUserId!,
//                       receiverId: widget.user['user_id'],
//                     ),
//               ),
//             );
//           } else if (_callProvider.currentCallType == 'audio') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (context) => CallingScreen(
//                       callRecordId: _callProvider.currentCallRecordId!,
//                       callerId: _callProvider.currentUserId!,
//                       receiverId: widget.user['user_id'],
//                     ),
//               ),
//             );
//           }
//         }
//       } else if (_callProvider.currentCallRecordId == null &&
//           _callProvider.incomingCallData == null &&
//           !_callProvider.isIncomingCall) {
//         if (Navigator.canPop(context) &&
//             (ModalRoute.of(context)?.settings.name == '/callingScreen' ||
//                 ModalRoute.of(context)?.settings.name ==
//                     '/videoCallingScreen')) {
//           Navigator.pop(context);
//         }
//       }
//     });
//   }

//   void _onKeyPressed(String value) {
//     setState(() {
//       _controller.text += value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dialpadData = [
//       ['1', ''],
//       ['2', 'ABC'],
//       ['3', 'DEF'],
//       ['4', 'GHI'],
//       ['5', 'JKL'],
//       ['6', 'MNO'],
//       ['7', 'PQRS'],
//       ['8', 'TUV'],
//       ['9', 'WXYZ'],
//       ['*', ''],
//       ['0', '+'],
//       ['#', ''],
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF8F8F8),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: AppColors.textColor),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text('Call', style: TextStyle(color: AppColors.textColor)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             // User info display
//             CircleAvatar(
//               radius: 50,
//               // backgroundImage: NetworkImage(widget.user['image_path'] ?? ''),
//               backgroundColor: AppColors.primaryColor.withOpacity(0.3),
//               child: Text(
//                 widget.user['name'] != null
//                     ? widget.user['name'][0].toUpperCase()
//                     : '',
//                 style: const TextStyle(
//                   fontSize: 40,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               widget.user['name'] ?? 'Unknown User',
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textColor,
//               ),
//             ),
//             Text(
//               widget.user['role'] != null
//                   ? widget.user['role'].toUpperCase()
//                   : '',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppColors.textColor.withOpacity(0.7),
//               ),
//             ),
//             const SizedBox(height: 30),

//             TextField(
//               controller: _controller,
//               readOnly: true,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Enter number',
//                 hintStyle: TextStyle(color: AppColors.textColor),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 1.5,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: dialpadData.length,
//                 itemBuilder: (context, index) {
//                   return _buildDialpadButton(
//                     dialpadData[index][0],
//                     dialpadData[index][1],
//                     () => _onKeyPressed(dialpadData[index][0]),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildBottomButton(Icons.videocam, () {
//                     // ✅ Video call start karein
//                     _callProvider.startCall(
//                       // Ab CallProvider use karein
//                       receiverId: widget.user['user_id'],
//                       receiverName: widget.user['name'],
//                       callType: 'video',
//                       context: context,
//                     );
//                   }, 'Video call'),
//                   _buildBottomButton(Icons.message, () {}, 'Message'),
//                   _buildBottomButton(
//                     Icons.call,
//                     () {
//                       _callProvider.startCall(
//                         receiverId: widget.user['user_id'],
//                         receiverName: widget.user['name'],
//                         callType: 'audio',
//                         context: context,
//                       );
//                     },
//                     'Voice call',
//                     color: AppColors.successColor,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDialpadButton(
//     String mainText,
//     String subText,
//     VoidCallback onPressed,
//   ) {
//     return InkWell(
//       onTap: onPressed,
//       borderRadius: BorderRadius.circular(50),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(50),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               mainText,
//               style: const TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textColor,
//               ),
//             ),
//             if (subText.isNotEmpty)
//               Text(
//                 subText,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: AppColors.textColor.withOpacity(0.7),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomButton(
//     IconData icon,
//     void Function()? onPressed,
//     String label, {
//     Color color = AppColors.iconBackgroundColor,
//   }) {
//     return Column(
//       children: [
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: color,
//             shape: const CircleBorder(),
//             padding: const EdgeInsets.all(16),
//             elevation: 4,
//           ),
//           onPressed: onPressed,
//           child: Icon(icon, color: Colors.white),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12, color: AppColors.textColor),
//         ),
//       ],
//     );
//   }
// }

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:flutter/material.dart';
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
  bool isTranscribing = false;
  late CallProvider _callProvider;
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    // Providers ko listen: false ke saath initialize karein
    _callProvider = Provider.of<CallProvider>(context, listen: false);
    _socketService = Provider.of<SocketService>(context, listen: false);

    // Call ended event ko listen karein
    _socketService.onCallEnded = _handleCallEnded;
  }

  @override
  void dispose() {
    // Jab screen dispose ho to listener ko null kar dein
    _socketService.onCallEnded = null;
    super.dispose();
  }

  // Jab call end ho to navigate back karein
  void _handleCallEnded(Map<String, dynamic> data) {
    if (mounted) {
      print('📞 Call ended received: $data');
      Navigator.of(context).pop(); // Call end hone par screen se bahar aayen
    }
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
    String? fixedImagePath;
    if (widget.user['avatar'] != null && widget.user['avatar'].isNotEmpty) {
      // Simplified null check, as avatarUrl is required
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
                onPressed: () {
                  if (widget.user['call_record_id'] != null &&
                      _callProvider.currentUserId != null) {
                    _callProvider.endCall(
                      callStatus: 'cancelled',
                      context: context,
                    );
                  } else {
                    print(
                      'Error: Call record ID or current user ID is missing.',
                    );
                  }
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
