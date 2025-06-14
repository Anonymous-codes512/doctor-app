import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ReminderItem extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final String frequency; // 'daily' or 'weekly'
  final ValueChanged<String?> onFrequencyChanged;

  const ReminderItem({
    super.key,
    required this.title,
    required this.isEnabled,
    required this.onToggle,
    required this.frequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Reminder frequency',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'daily',
                  groupValue: frequency,
                  onChanged: isEnabled ? onFrequencyChanged : null,
                ),
                const Text('Daily'),
                Radio<String>(
                  value: 'weekly',
                  groupValue: frequency,
                  onChanged: isEnabled ? onFrequencyChanged : null,
                ),
                const Text('Weekly'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
