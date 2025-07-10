import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:flutter/material.dart';

class VoiceCallItem extends StatelessWidget {
  final String userName;
  final String callTime;
  final String callType;
  final String avatarUrl;
  final bool isOnline;
  final VoidCallback? onTap;
  final VoidCallback? onpPhoneTap;

  const VoiceCallItem({
    Key? key,
    required this.userName,
    required this.callTime,
    required this.callType,
    required this.avatarUrl,
    this.isOnline = false,
    this.onTap,
    this.onpPhoneTap,
  }) : super(key: key);

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

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
    String? fixedImagePath;
    if (avatarUrl.isNotEmpty) {
      // Simplified null check, as avatarUrl is required
      fixedImagePath = avatarUrl.replaceAll(r'\', '/');
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
                  backgroundImage: avatarImage,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                  child:
                      avatarImage == null
                          ? Text(
                            _getInitials(userName),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          )
                          : null,
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
              onPressed: onpPhoneTap,
            ),
          ],
        ),
      ),
    );
  }
}
