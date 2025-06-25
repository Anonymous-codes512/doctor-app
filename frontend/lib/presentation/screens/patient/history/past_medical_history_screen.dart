import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastMedicalHistoryScreen extends StatefulWidget {
  final int patientId;
  const PastMedicalHistoryScreen({super.key, required this.patientId});

  @override
  State<PastMedicalHistoryScreen> createState() =>
      _PastMedicalHistoryScreenState();
}

class _PastMedicalHistoryScreenState extends State<PastMedicalHistoryScreen> {
  late TextEditingController _pastMedicalHistoryController;
  late TextEditingController _familyMedicalHistoryController;
  late TextEditingController _medicationController;

  bool pastMedicalHistory = false;
  bool familyMedicalHistory = false;
  bool medicationHistory = false;

  late Patient patient;

  @override
  void initState() {
    super.initState();
    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;

    patient = patients.firstWhere((patient) => patient.id == widget.patientId);

    /// Correct mapping of toggles based on actual `has_*` fields
    pastMedicalHistory = patient.hasPastMedicalHistory ?? false;
    familyMedicalHistory = patient.hasFamilyHistory ?? false;
    medicationHistory = patient.hasMedicationHistory ?? false;

    /// Correctly assign controllers based on values
    _pastMedicalHistoryController = TextEditingController(
      text: patient.pastMedicalHistory?.join(', ') ?? '',
    );
    _familyMedicalHistoryController = TextEditingController(
      text: patient.familyHistory?.join(', ') ?? '',
    );
    _medicationController = TextEditingController(
      text: patient.medicationHistory?.join(', ') ?? '',
    );
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
        title: const Text(
          'Past Medical History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section 1
            const Text(
              '1. Past Medical Conditions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ToggleSwitchWidget(
              label:
                  'Do you have a past medical history? (E.g., Head injuries, Diabetes, Epilepsy, etc.)',
              value: pastMedicalHistory,
              onChanged: (value) => setState(() => pastMedicalHistory = value),
            ),
            if (pastMedicalHistory)
              LabeledTextField(
                label: 'If yes, specify conditions:',
                hintText: 'Conditions here...',
                controller: _pastMedicalHistoryController,
              ),

            const SizedBox(height: 16.0),

            /// Section 2
            const Text(
              '2. Family Medical History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ToggleSwitchWidget(
              label: 'Any significant family medical history?',
              value: familyMedicalHistory,
              onChanged:
                  (value) => setState(() => familyMedicalHistory = value),
            ),
            if (familyMedicalHistory)
              LabeledTextField(
                label: 'If yes, specify family members & conditions:',
                hintText: 'Conditions here...',
                controller: _familyMedicalHistoryController,
              ),

            const SizedBox(height: 16.0),

            /// Section 3
            const Text(
              '3. Current Medications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ToggleSwitchWidget(
              label:
                  'Are you on any medication (prescribed/non-prescribed, etc.)?',
              value: medicationHistory,
              onChanged: (value) => setState(() => medicationHistory = value),
            ),
            if (medicationHistory)
              LabeledTextField(
                label: 'List medications with dose & duration:',
                hintText: 'Medication here...',
                controller: _medicationController,
              ),

            const SizedBox(height: 24.0),

            /// Save Button
            PrimaryCustomButton(
              text: 'Save',
              onPressed: () async {
                final provider = Provider.of<PatientProvider>(
                  context,
                  listen: false,
                );

                await provider.updatePatientFields(
                  context,
                  patientId: widget.patientId,
                  updatedFields: {
                    'has_past_medical_history': pastMedicalHistory,
                    if (pastMedicalHistory)
                      'past_medical_history':
                          _pastMedicalHistoryController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList(),

                    'has_family_history': familyMedicalHistory,
                    if (familyMedicalHistory)
                      'family_history':
                          _familyMedicalHistoryController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList(),

                    'has_medication_history': medicationHistory,
                    if (medicationHistory)
                      'medication_history':
                          _medicationController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList(),
                  },
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
