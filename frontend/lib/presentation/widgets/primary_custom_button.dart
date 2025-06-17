import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isdelete;
  final bool isLoading;

  const PrimaryCustomButton({
    required this.text,
    this.onPressed,
    this.isdelete = false,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isdelete ? AppColors.errorColor : AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: const Size(double.infinity, 45),
      ),
      child:
          isLoading
              ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
              : Text(
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
