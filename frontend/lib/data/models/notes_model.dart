class Note {
  final int? noteId;
  final int? doctorUserId;
  final int? patientId;
  final String notesTitle;
  final String notesDescription;
  final String date;

  Note({
    this.noteId,
    this.doctorUserId,
    this.patientId,
    required this.notesTitle,
    required this.notesDescription,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['note_id'] ?? '',
      doctorUserId: json['doctor_user_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      notesTitle: json['notes_title'] ?? '',
      notesDescription: json['notes_description'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'note_id': noteId,
    'doctor_user_id': doctorUserId,
    'patient_id': patientId,
    'notes_title': notesTitle,
    'notes_description': notesDescription,
    'date': date,
  };

  @override
  String toString() {
    return 'Note(title: $notesTitle, description: $notesDescription, date: $date)';
  }
}
