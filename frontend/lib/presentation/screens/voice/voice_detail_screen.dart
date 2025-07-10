import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:flutter/material.dart';

class VoiceCallDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  const VoiceCallDetailScreen({super.key, required this.user});

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
    if (user['avatar'].isNotEmpty) {
      // Simplified null check, as avatarUrl is required
      fixedImagePath = user['avatar'].replaceAll(r'\', '/');
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
      appBar: AppBar(
        title: Text(
          'Voice Call Details',
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.blue.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: avatarImage,
                      radius: 50,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                      child:
                          avatarImage == null
                              ? Text(
                                _getInitials(user['name'] ?? 'Unknown User'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              )
                              : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user['name'] ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor, // Your custom text color
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.message,
                            color: AppColors.textColor,
                          ), // Your custom icon color
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.email,
                            color: AppColors.textColor,
                          ), // Your custom icon color
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.block,
                            color: AppColors.textColor,
                          ), // Your custom icon color
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: AppColors.textColor,
                          ), // Your custom icon color
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Call History Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Call History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor, // Your custom text color
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Call history list view
            Expanded(
              child:
                  (user['call_history'] == null || user['call_history'].isEmpty)
                      ? const Center(
                        child: Text(
                          'No call history available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: user.length,
                        itemBuilder: (context, index) {
                          final call = user['call_history'][index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  call.isMissed
                                      ? Icons.call_missed
                                      : Icons.call_made,
                                  size: 14,
                                  color:
                                      call.isMissed
                                          ? AppColors.errorColor
                                          : AppColors
                                              .successColor, // Your custom error/success colors
                                ),
                                const SizedBox(width: 8),
                                // Call date and duration/size
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        call.callDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color:
                                              AppColors
                                                  .textColor, // Your custom text color
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        call.durationOrSize,
                                        style: TextStyle(
                                          color:
                                              Colors
                                                  .grey
                                                  .shade700, // Use custom grey color or leave as is
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Call type icon
                                Icon(
                                  call.isVideoCall
                                      ? Icons.videocam
                                      : Icons.call,
                                  color:
                                      AppColors
                                          .primaryColor, // Your custom icon color
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class CallHistoryItem {
  final bool isMissed;
  final String callDate;
  final String durationOrSize;
  final bool isVideoCall;

  CallHistoryItem({
    required this.isMissed,
    required this.callDate,
    required this.durationOrSize,
    required this.isVideoCall,
  });
}
