import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/provider/call_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Extension to add capitalize method to String
class CallListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const CallListScreen({super.key, required this.users});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  String capitalize(String role) {
    if (role.isEmpty) return '';
    return role[0].toUpperCase() + role.toLowerCase().substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final callProvider = Provider.of<CallProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          "Contacts For Call",
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
              print('User ID: ${user['user_id']}');
              await callProvider.selectUserForCall(user['user_id']);

              callProvider.startCall(callType: 'audio', context: context);

              Navigator.pushNamed(
                context,
                Routes.callingScreen,
                arguments: user,
              );
            },
          );
        },
      ),
    );
  }
}
