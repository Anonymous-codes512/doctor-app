import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showToast({
    required BuildContext context,
    required String message,
    ToastificationType type = ToastificationType.info,
    Color backgroundColor = Colors.white,
    Color foregroundColor = Colors.black,
    Color iconColor = Colors.black,
    IconData iconData = Icons.info,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: TextStyle(color: foregroundColor, fontWeight: FontWeight.bold),
      ),
      description: null,
      alignment: Alignment.topRight,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      icon: Icon(iconData, color: iconColor),
      autoCloseDuration: Duration(seconds: 5),
      showIcon: true,
      primaryColor: iconColor,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: true,
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) {
          return IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 18, color: Colors.red),
          );
        },
      ),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    showToast(
      context: context,
      message: message,
      type: ToastificationType.success,
      backgroundColor: const Color(0xFFe6f4ea),
      foregroundColor: Colors.green.shade900,
      iconColor: Colors.green,
      iconData: Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    showToast(
      context: context,
      message: message,
      type: ToastificationType.error,
      backgroundColor: const Color(0xFFfdecea),
      foregroundColor: Colors.red.shade900,
      iconColor: Colors.red,
      iconData: Icons.error,
    );
  }

  static void showInfo(BuildContext context, String message) {
    showToast(
      context: context,
      message: message,
      type: ToastificationType.info,
      backgroundColor: const Color(0xFFe8f4fd),
      foregroundColor: Colors.blue.shade900,
      iconColor: Colors.blue,
      iconData: Icons.info,
    );
  }
}
