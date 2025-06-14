import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class VoiceCallItem extends StatelessWidget {
  final String userName;
  final String callTime; // e.g. "Yesterday", "2 min ago"
  final String callType; // e.g. "Incoming", "Outgoing", "Missed"
  final String avatarUrl;
  final bool isOnline;
  final VoidCallback? onTap;

  const VoiceCallItem({
    Key? key,
    required this.userName,
    required this.callTime,
    required this.callType,
    required this.avatarUrl,
    this.isOnline = false,
    this.onTap,
  }) : super(key: key);

  Color getCallTypeColor() {
    switch (callType.toLowerCase()) {
      case 'missed':
        return AppColors.errorColor;
      case 'incoming':
        return AppColors.successColor;
      case 'outgoing':
        return AppColors.primaryColor;
      default:
        return AppColors.textColor;
    }
  }

  IconData getCallTypeIcon() {
    switch (callType.toLowerCase()) {
      case 'missed':
        return Icons.call_missed;
      case 'incoming':
        return Icons.call_received;
      case 'outgoing':
        return Icons.call_made;
      default:
        return Icons.call;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        getCallTypeIcon(),
                        color: getCallTypeColor(),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        callType,
                        style: TextStyle(
                          color: getCallTypeColor(),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        callTime,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.call, color: AppColors.primaryColor),
              onPressed: () {
                // Add voice call action
              },
            ),
          ],
        ),
      ),
    );
  }
}
