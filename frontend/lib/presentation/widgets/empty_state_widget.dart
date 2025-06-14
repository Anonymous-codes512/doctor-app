import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String text;
  const EmptyState({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImagePath.emptyImage,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textColor.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
