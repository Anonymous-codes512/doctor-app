import 'package:flutter/material.dart';

class OutlinedCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? trailingIcon; // optional trailing icon

  const OutlinedCustomButton({
    required this.text,
    this.onPressed,
    this.trailingIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: const Size(double.infinity, 45),
        // Ensures content fills available space, so text can be centered properly
        padding:
            trailingIcon != null
                ? const EdgeInsets.symmetric(
                  horizontal: 16,
                ) // Add some horizontal padding when icon is present
                : EdgeInsets
                    .zero, // Let Row handle centering without extra padding
      ),
      child: Row(
        // Conditionally set mainAxisAlignment based on whether a trailingIcon is provided
        mainAxisAlignment:
            trailingIcon != null
                ? MainAxisAlignment
                    .spaceBetween // Distribute text and icon
                : MainAxisAlignment.center, // Center the text if no icon
        children: [
          // If no trailing icon, we only need the Text widget.
          // If a trailing icon exists, we need to balance the space.
          // For perfect centering when no icon, it's often best to just have the Text.
          // For spaceBetween, we need the Spacer or equivalent logic.
          if (trailingIcon != null)
            const SizedBox(
              width: 24,
            ), // Add a leading "placeholder" space to visually center text when icon is present

          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          if (trailingIcon != null) trailingIcon!,
          if (trailingIcon ==
              null) // This spacer ensures the single text is truly centered
            const SizedBox.shrink(), // No extra space needed when centered
        ],
      ),
    );
  }
}
