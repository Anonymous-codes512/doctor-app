import 'dart:ui';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

enum MessageType { error, warning, info, success }

class CustomDialog extends StatelessWidget {
  final VoidCallback onClose;
  final String title;
  final String message;
  final MessageType type;

  const CustomDialog({
    Key? key,
    required this.onClose,
    required this.title,
    required this.message,
    this.type = MessageType.error,
  }) : super(key: key);

  // Helper method to get icon and color based on type
  IconData get _icon {
    switch (type) {
      case MessageType.warning:
        return Icons.warning_amber_rounded;
      case MessageType.info:
        return Icons.info_outline;
      case MessageType.success:
        return Icons.check_circle_outline;
      case MessageType.error:
        return Icons.error_outline;
    }
  }

  Color get _iconColor {
    switch (type) {
      case MessageType.warning:
        return AppColors.warningColor;
      case MessageType.info:
        return AppColors.infoColor;
      case MessageType.success:
        return AppColors.successColor;
      case MessageType.error:
        return AppColors.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 250,
            height: 300,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_icon, color: _iconColor, size: 75),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onClose,
                    child: const Icon(Icons.close, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
