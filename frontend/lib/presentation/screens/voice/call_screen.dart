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
