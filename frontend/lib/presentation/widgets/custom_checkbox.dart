import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged; // Changed type to ValueChanged<bool?>

  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14), // Added const for TextStyle
          ),
        ),
        Checkbox(
          value: value,
          onChanged: (bool? value) {
            // Directly pass the bool? value
            onChanged(value);
          },
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
