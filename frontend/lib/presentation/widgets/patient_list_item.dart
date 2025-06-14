import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class PatientListItem extends StatelessWidget {
  final String name;
  final String?
  phoneNumber; // Changed to nullable based on PatientSelectionScreen data
  final VoidCallback? onTap;
  final bool showDivider;
  final Widget?
  trailing; // Added this property for the checkbox or other widgets

  const PatientListItem({
    Key? key,
    required this.name,
    this.phoneNumber, // Updated to be nullable
    this.onTap,
    this.showDivider = true,
    this.trailing, // Added to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.confirmedEventColor,
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          phoneNumber!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing !=
                    null) // Conditionally display the trailing widget
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ), // Add some spacing
                    child: trailing!,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            margin: const EdgeInsets.only(left: 56),
            height: 1,
            color: AppColors.dividerColor,
          ),
      ],
    );
  }
}
