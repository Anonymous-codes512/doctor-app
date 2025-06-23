import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/notes_model.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart'; // Assuming this provides SearchBarWithAddButton
import 'package:doctor_app/presentation/widgets/note_list_item.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  final List<Note> notes;
  const NotesScreen({super.key, required this.notes});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Note> filteredNotes = [];
  bool _isSearching = false;
  int patientId = 0;
  @override
  void initState() {
    super.initState();
    filteredNotes = List.from(widget.notes);
    if (widget.notes.isNotEmpty) {
      patientId = widget.notes.first.patientId ?? 0;
    }
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
        filteredNotes = List.from(widget.notes);
      } else {
        final lowerCaseQuery = query.toLowerCase();
        filteredNotes =
            widget.notes.where((note) {
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
              print(patientId);
              Navigator.pushNamed(
                context,
                Routes.addNoteScreen,
                arguments: patientId,
              );
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
