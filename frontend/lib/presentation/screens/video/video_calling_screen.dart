import 'dart:ui';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class VideoCallingScreen extends StatefulWidget {
  final Map<String, dynamic> callingData;
  const VideoCallingScreen({super.key, required this.callingData});

  @override
  State<VideoCallingScreen> createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  late String name;
  late String avatarUrl;
  late String phone;
  late int userId;

  @override
  void initState() {
    super.initState();
    name = widget.callingData['name'] ?? 'Unknown';
    avatarUrl = widget.callingData['avatar'] ?? '';
    phone = widget.callingData['phone'] ?? 'N/A';
    userId = widget.callingData['user_id'] ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // startZegoCall(userId);
    });
  }

  // void startZegoCall(int peerUserId) {
  //   ZegoUIKitPrebuiltCallInvitationService().controller
  //       ?.sendCallInvitation(
  //         callees: [ZegoUIKitUser(id: peerUserId.toString(), name: name)],
  //         callType: ZegoCallType.video,
  //         resourceID: "your_resource_id", // same as in dashboard
  //         timeout: 60,
  //       )
  //       .then((result) {
  //         if (result.errorInvitees.isNotEmpty) {
  //           debugPrint("Invite failed for users: ${result.errorInvitees}");
  //         }
  //       })
  //       .catchError((err) {
  //         debugPrint("Invitation send error: $err");
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          avatarUrl.isNotEmpty
              ? Image.network(avatarUrl, fit: BoxFit.cover)
              : Container(color: Colors.black),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          Positioned(
            top: 40,
            left: 16,
            child: _circleIcon(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
          ),

          Positioned(
            top: 50,
            left: 160,
            child: Text(
              "Calling ...",
              style: TextStyle(color: AppColors.backgroundColor, fontSize: 15),
            ),
          ),

          Positioned(
            top: 40,
            right: 16,
            child: Column(
              children: [
                _circleIcon(icon: Icons.person_add, onTap: () {}),
                const SizedBox(height: 16),
                _circleIcon(icon: Icons.videocam, onTap: () {}),
              ],
            ),
          ),

          Positioned(
            top: 180,
            left: 100,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundImage:
                      avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  backgroundColor: Colors.grey.shade800,
                  child:
                      avatarUrl.isEmpty
                          ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                          : null,
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  phone,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bottomControlIcon(
                      icon: Icons.videocam_outlined,
                      onTap: () {},
                    ),
                    _bottomControlIcon(icon: Icons.mic_off, onTap: () {}),
                    _bottomControlIcon(icon: Icons.volume_off, onTap: () {}),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.7),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _bottomControlIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
