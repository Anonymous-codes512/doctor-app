import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class GenderRadioGroup extends StatelessWidget {
  final String label;
  final String? groupValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const GenderRadioGroup({
    Key? key,
    required this.label,
    required this.groupValue,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              options.map((option) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: option,
                      activeColor: AppColors.primaryColor,
                      groupValue: groupValue,
                      onChanged: onChanged,
                    ),
                    Text(option),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }
}
