import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String userName;
  final String messagePreview;
  final String time;
  final int unreadCount;
  final String avatarUrl;
  final bool isOnline;
  final VoidCallback? onTap;

  const ChatItem({
    Key? key,
    required this.userName,
    required this.messagePreview,
    required this.time,
    required this.unreadCount,
    required this.avatarUrl,
    this.isOnline = false,
    this.onTap,
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

  @override
  Widget build(BuildContext context) {
    String? fixedImagePath;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                if (isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.warningColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
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
                  Text(
                    messagePreview,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                if (unreadCount > 0)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
