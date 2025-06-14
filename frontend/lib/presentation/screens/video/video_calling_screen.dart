import 'dart:ui';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/screens/video/video_call_attended_screen.dart';
import 'package:flutter/material.dart';

class VideoCallingScreen extends StatefulWidget {
  const VideoCallingScreen({super.key});

  @override
  State<VideoCallingScreen> createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to CallAttendedScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CallAttendedScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image blurred
          Image.network(
            'https://i.pravatar.cc/500?img=12', // Replace with actual image URL or asset
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ), // Dark overlay
          ),

          // Back arrow at top-left
          Positioned(
            top: 40,
            left: 16,
            child: _circleIcon(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // Back arrow at top-left
          Positioned(
            top: 50,
            left: 160,
            child: Text(
              "Calling ...",
              style: TextStyle(color: AppColors.backgroundColor, fontSize: 15),
            ),
          ),

          // Add person & videocam icons stacked vertically at top-right
          Positioned(
            top: 40,
            right: 16,
            child: Column(
              children: [
                _circleIcon(
                  icon: Icons.person_add,
                  onTap: () {
                    // Add person action
                  },
                ),
                const SizedBox(height: 16),
                _circleIcon(
                  icon: Icons.videocam,
                  onTap: () {
                    // Switch camera action
                  },
                ),
              ],
            ),
          ),

          Positioned(
            top: 180,
            left: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/300?img=12',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'David Wayne',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '(+44) 50 9285 3022',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Bottom controls + End call button
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

  // Circle icon for top buttons
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

  // Bottom control icons
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
