import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Extension to add capitalize method to String
class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const ChatListScreen({super.key, required this.users});

  String _getInitials(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return '?';
    final parts = trimmed.split(' ');
    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    final initials = (first + second).toUpperCase();
    return initials.isEmpty ? '?' : initials;
  }

  String capitalize(String role) {
    if (role.isEmpty) return '';
    return role[0].toUpperCase() + role.toLowerCase().substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          "Messages",
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          String? fixedImagePath;
          if (user['avatar'] != null && user['avatar']!.isNotEmpty) {
            fixedImagePath = user['avatar']?.replaceAll(r'\', '/');
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

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: avatarImage,
              backgroundColor: AppColors.primaryColor.withOpacity(0.3),
              child:
                  avatarImage == null
                      ? Text(
                        _getInitials(user['name']),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      )
                      : null,
            ),

            title: Text(user['name']),
            subtitle: Text(capitalize(user['role'])),
            onTap: () async {
              await chatProvider.selectUserForChat(user['user_id']);
              Navigator.pushNamed(context, Routes.chatScreen, arguments: user);
            },
          );
        },
      ),
    );
  }
}
