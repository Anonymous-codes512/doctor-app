import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/notes_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  final int patientId;
  const AddNoteScreen({super.key, required this.patientId});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreen();
}

class _AddNoteScreen extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.patientId);
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
          'Add Note',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LabeledTextField(
              label: 'Title',
              hintText: 'Enter title here...',
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Description',
              hintText: 'Enter description here...',
              controller: _descriptionController,
              maxline: 15,
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
                    text: 'Save Note',
                    onPressed: () async {
                      final note = Note(
                        patientId: widget.patientId,
                        notesTitle: _titleController.text.trim(),
                        notesDescription: _descriptionController.text.trim(),
                        date: DateFormat('MMMM d, y').format(DateTime.now()),
                      );
                      print(note);
                      await Provider.of<DoctorProvider>(
                        context,
                        listen: false,
                      ).createNote(context, note);
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
}
