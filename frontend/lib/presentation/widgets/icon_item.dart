import 'package:flutter/material.dart';
import 'package:doctor_app/core/assets/colors/app_colors.dart';

class IconItems extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const IconItems({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.iconBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryColor, width: 1.5),
            ),
            padding: const EdgeInsets.all(14),
            child: Icon(icon, color: Colors.black, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
