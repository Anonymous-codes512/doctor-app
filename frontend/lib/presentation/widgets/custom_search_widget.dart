import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class SearchBarWithAddButton extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onAddPressed;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap; // new parameter

  const SearchBarWithAddButton({
    Key? key,
    this.controller,
    this.onAddPressed,
    this.onChanged,
    this.onTap, // add to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(30);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(color: Colors.black26, width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      onTap: onTap, // assign here
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: AppColors.backgroundColor),
              onPressed: onAddPressed,
              splashRadius: 20,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
