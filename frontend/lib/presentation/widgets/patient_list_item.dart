import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:flutter/material.dart';

class PatientListItem extends StatelessWidget {
  final String name;
  final String? phoneNumber;
  final String? imagePath; // ✅ New field to show patient image
  final VoidCallback? onTap;
  final bool showDivider;
  final Widget? trailing;

  const PatientListItem({
    Key? key,
    required this.name,
    this.phoneNumber,
    this.imagePath, // ✅ Constructor update
    this.onTap,
    this.showDivider = true,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? fixedImagePath;
    if (imagePath != null && imagePath!.isNotEmpty) {
      fixedImagePath = imagePath?.replaceAll(r'\', '/');
    }

    ImageProvider? avatarImage;
    if (fixedImagePath != null && fixedImagePath.isNotEmpty) {
      // Build full URL by joining base URL and cleaned path without double slashes
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

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.confirmedEventColor,
                  backgroundImage: avatarImage,
                  child:
                      avatarImage == null
                          ? const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 28,
                          )
                          : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          phoneNumber!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            margin: const EdgeInsets.only(left: 56),
            height: 1,
            color: AppColors.dividerColor,
          ),
      ],
    );
  }
}
