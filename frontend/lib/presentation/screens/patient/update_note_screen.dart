import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/notes_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateNoteScreen extends StatefulWidget {
  final Note note;

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
    _titleController.text = widget.note.notesTitle;
    _descriptionController.text = widget.note.notesDescription;
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
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LabeledTextField(
              label: 'Title',
              hintText: 'Enter title here...',
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LabeledTextField(
                label: 'Description',
                hintText: 'Enter description here...',
                controller: _descriptionController,
                maxline: 15,
              ),
            ),
            const SizedBox(height: 16),
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
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryCustomButton(
                    text: 'Save Changes',
                    onPressed: () async {
                      final updatedNote = Note(
                        notesTitle: _titleController.text.trim(),
                        notesDescription: _descriptionController.text.trim(),
                        date: DateTime.now().toIso8601String(),
                      );

                      final int noteId = widget.note.noteId!;
                      await Provider.of<DoctorProvider>(
                        context,
                        listen: false,
                      ).updateNote(context, updatedNote, noteId);

                      Navigator.pop(context);
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
