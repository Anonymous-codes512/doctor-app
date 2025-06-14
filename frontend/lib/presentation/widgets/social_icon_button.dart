import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  const SocialIconButton({required this.icon, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE3DFF9), // Light purple
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(80, 45),
        elevation: 0,
      ),
      child: icon,
    );
  }
}
