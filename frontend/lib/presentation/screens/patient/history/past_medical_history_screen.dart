import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/screens/patient/add_new_patient_screen.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:flutter/material.dart';

class PastMedicalHistoryScreen extends StatefulWidget {
  const PastMedicalHistoryScreen({super.key});

  @override
  State<PastMedicalHistoryScreen> createState() =>
      _PastMedicalHistoryScreenState();
}

class _PastMedicalHistoryScreenState extends State<PastMedicalHistoryScreen> {
  TextEditingController _pastMedicalHistoryController = TextEditingController();
  TextEditingController _familyMedicalHistoryController =
      TextEditingController();
  TextEditingController _medicationController = TextEditingController();

  bool pastMedicalHistory = false;
  bool familyMedicalHistory = false;
  bool medicationHistory = false;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Text(
                '1. Past Medical Conditions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label:
                    'Do you have a past medical history? (E.g., Head injuries, Diabetes, Epilepsy, Asthma, Kidney disease, etc.)',
                value: familyMedicalHistory,
                onChanged: (value) {
                  setState(() {
                    familyMedicalHistory = value;
                  });
                },
              ),
              if (familyMedicalHistory)
                LabeledTextField(
                  label: 'If yes, please specify and explain each condition:',
                  hintText: 'Conditions here...',
                  controller: _pastMedicalHistoryController,
                ),

              const SizedBox(height: 16.0),
              Text(
                '2. Family Medical History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label: 'Any significant family medical history?',
                value: pastMedicalHistory,
                onChanged: (value) {
                  setState(() {
                    pastMedicalHistory = value;
                  });
                },
              ),
              if (pastMedicalHistory)
                LabeledTextField(
                  label:
                      'If yes, please specify which family members and their conditions:',
                  hintText: 'Conditions here...',
                  controller: _familyMedicalHistoryController,
                ),
              const SizedBox(height: 16.0),
              Text(
                '3. Current Medications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label:
                    'Are you on any medication (prescribed, non-prescribed, supplements, vitamins, herbal remedies)? ',
                value: medicationHistory,
                onChanged: (value) {
                  setState(() {
                    medicationHistory = value;
                  });
                },
              ),
              if (medicationHistory)
                LabeledTextField(
                  label:
                      'If yes, please specify each medication\'s name, dose, strength, and duration:',
                  hintText: 'Medication here...',
                  controller: _medicationController,
                ),
              const SizedBox(height: 16.0),
              PrimaryCustomButton(text: 'Save', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
