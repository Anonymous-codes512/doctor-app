import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/screens/patient/add_new_patient_screen.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:flutter/material.dart';

class PastDrugHistoryScreen extends StatefulWidget {
  const PastDrugHistoryScreen({super.key});

  @override
  State<PastDrugHistoryScreen> createState() => _PastDrugHistoryScreenState();
}

class _PastDrugHistoryScreenState extends State<PastDrugHistoryScreen> {
  TextEditingController _medicationAllergyController = TextEditingController();
  TextEditingController _takingMeddicationController = TextEditingController();
  TextEditingController _mentalMedicationController = TextEditingController();

  bool isAllergatic = false;
  bool isMedicationAllergatic = false;
  bool isTakingMedication = false;
  bool mentalMedication = false;

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
          'Past Drug History',
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
                '1. Allergies',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label: 'Do you have any allergies?',
                value: isAllergatic,
                onChanged: (value) {
                  setState(() {
                    isAllergatic = value;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label: 'If yes, do you have any allergies to medications?',
                value: isMedicationAllergatic,
                onChanged: (value) {
                  setState(() {
                    isMedicationAllergatic = value;
                  });
                },
              ),
              if (isMedicationAllergatic)
                LabeledTextField(
                  label:
                      'If yes, please specify the medication and describe what happens when you take it:',
                  hintText: 'Conditions here...',
                  controller: _medicationAllergyController,
                ),
              const SizedBox(height: 16.0),
              Text(
                '2. Current Medications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label: 'Are you currently taking any medication?',
                value: isTakingMedication,
                onChanged: (value) {
                  setState(() {
                    isTakingMedication = value;
                  });
                },
              ),
              if (isTakingMedication)
                LabeledTextField(
                  label:
                      'If yes, which medications are you currently taking, and how often do you take each?',
                  hintText: 'Conditions here...',
                  controller: _takingMeddicationController,
                ),
              const SizedBox(height: 16.0),
              Text(
                '3. Medications for Mental Health',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label:
                    'Have you ever taken or do you currently take any medication for your mental health?',
                value: mentalMedication,
                onChanged: (value) {
                  setState(() {
                    mentalMedication = value;
                  });
                },
              ),
              if (mentalMedication)
                LabeledTextField(
                  label:
                      'If yes, please specify the medications, the reason for use, dosage, and their effectiveness:',
                  hintText: 'Medication here...',
                  controller: _mentalMedicationController,
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
