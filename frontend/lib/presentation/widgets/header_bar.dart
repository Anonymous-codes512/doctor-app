import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onSkip;
  final Color skipColor;

  const HeaderBar({
    Key? key,
    required this.title,
    required this.onBack,
    required this.onSkip,
    this.skipColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onBack,
          child: const Icon(Icons.arrow_back_ios, size: 24),
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        GestureDetector(
          onTap: onSkip,
          child: Text(
            'Skip',
            style: TextStyle(
              color: skipColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
