import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:flutter/material.dart';

class UpdateNoteScreen extends StatefulWidget {
  final Map<String, dynamic> note;
  const UpdateNoteScreen({super.key, required this.note});

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreen();
}

class _UpdateNoteScreen extends State<UpdateNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note['title'] ?? 'Enter title here...';
    _descriptionController.text =
        widget.note['description'] ?? 'Enter description here...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Update Note',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Fields Section
            LabeledTextField(
              label: 'Title',
              hintText: 'Enter title here...',
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            Expanded(
              // Use Expanded to allow the description field to take available space
              child: LabeledTextField(
                label: 'Description',
                hintText: 'Enter description here...',
                controller: _descriptionController,
                maxline: 15,
              ),
            ),
            const SizedBox(height: 16), // Space between content and buttons
            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedCustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12), // Space between buttons
                Expanded(
                  child: PrimaryCustomButton(
                    text: 'Save Changes',
                    onPressed: () {
                      // Implement save changes logic here
                      // e.g., print updated values:
                      print('Updated Title: ${_titleController.text}');
                      print(
                        'Updated Description: ${_descriptionController.text}',
                      );
                      Navigator.pop(context); // Pop after saving
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
