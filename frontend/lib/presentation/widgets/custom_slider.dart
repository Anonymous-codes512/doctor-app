import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final String label;
  final String? sublabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    Key? key,
    required this.label,
    this.sublabel,
    required this.value,
    this.min = 0.0,
    this.max = 10.0,
    this.divisions = 10,
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
        if (sublabel != null) ...[
          const SizedBox(height: 4),
          Text(
            sublabel!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          inactiveColor: Colors.grey[300],
        ),
      ],
    );
  }
}
