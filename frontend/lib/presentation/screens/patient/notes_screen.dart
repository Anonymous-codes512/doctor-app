import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/notes_model.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart'; // Assuming this provides SearchBarWithAddButton
import 'package:doctor_app/presentation/widgets/note_list_item.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Note> notes = [
    Note(
      notesTitle: 'Patient Follow-up Plan',
      notesDescription:
          'Patient shows significant improvement in mobility after physical therapy sessions. Recommended continuing with twice weekly sessions for another month and reassess progress.',
      date: 'May 30, 2025',
    ),
    Note(
      notesTitle: 'Medication Adjustment',
      notesDescription:
          'Reduced dosage of Lisinopril from 20mg to 10mg daily due to patient experiencing persistent dry cough. Will monitor blood pressure closely over the next two weeks.',
      date: 'May 25, 2025',
    ),
    Note(
      notesTitle: 'Lab Results Review',
      notesDescription:
          'CBC results show normal WBC count. Hemoglobin slightly low at 11.8 g/dL. Recommended iron supplement and dietary changes. Will recheck in 3 months.',
      date: 'May 22, 2025',
    ),
    Note(
      notesTitle: 'Treatment Plan Discussion',
      notesDescription:
          'Discussed treatment options for chronic lower back pain. Patient prefers non-surgical approach. Agreed on combination of physical therapy, NSAIDs, and muscle relaxants.',
      date: 'May 17, 2025',
    ),
    Note(
      notesTitle: 'Initial Consultation',
      notesDescription:
          'New patient with complaints of recurring headaches for past 3 months. No family history of migraines or related conditions.',
      date: 'May 15, 2025',
    ),
  ];

  List<Note> filteredNotes = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredNotes = List.from(notes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNotes(String query) {
    // Renamed from _filterPatients to _filterNotes
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredNotes = List.from(notes);
      } else {
        final lowerCaseQuery = query.toLowerCase();
        filteredNotes =
            notes.where((note) {
              final title = note.notesTitle.toLowerCase();
              return title.contains(lowerCaseQuery);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'My Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar and add button
          SearchBarWithAddButton(
            controller: _searchController,
            onChanged: _filterNotes, // Use _filterNotes here
            onAddPressed: () {
              Navigator.pushNamed(context, Routes.addNoteScreen);
            },
            onTap: () {
              // Handle tap if needed, e.g., show a search overlay
            },
          ),
          const SizedBox(height: 10),
          // List of notes
          Expanded(
            child:
                filteredNotes.isEmpty && _isSearching
                    ? const Center(
                      child: Text(
                        'No notes found',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.iconColor,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
                        return NoteListItem(
                          // Using a new widget for notes
                          title: note.notesTitle,
                          description: note.notesDescription,
                          date: note.date,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.updateNoteScreen,
                              arguments: note,
                            );
                          },
                        );
                      },
                    ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
