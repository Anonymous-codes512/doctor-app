import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isdelete;
  const PrimaryCustomButton({
    required this.text,
    this.onPressed,
    this.isdelete = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isdelete ? AppColors.errorColor : AppColors.primaryColor, // Blue
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: const Size(double.infinity, 45),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
