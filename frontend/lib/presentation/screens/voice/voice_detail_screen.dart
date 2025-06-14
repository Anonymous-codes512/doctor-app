import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class VoiceCallDetailScreen extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final List<CallHistoryItem> callHistory;

  const VoiceCallDetailScreen({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.callHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Call', style: TextStyle(color: AppColors.textColor)),
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
                      radius: 40,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
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
              child: ListView.builder(
                itemCount: callHistory.length,
                itemBuilder: (context, index) {
                  final call = callHistory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        // Call status icon
                        Icon(
                          call.isMissed ? Icons.call_missed : Icons.call_made,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                          call.isVideoCall ? Icons.videocam : Icons.call,
                          color:
                              AppColors.primaryColor, // Your custom icon color
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
