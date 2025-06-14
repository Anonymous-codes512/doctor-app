import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? AppColors.primaryColor,
      inactiveThumbColor: Colors.grey[400],
      inactiveTrackColor: Colors.grey[300],
    );
  }
}
