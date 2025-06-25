import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastDrugHistoryScreen extends StatefulWidget {
  final int patientId;
  const PastDrugHistoryScreen({super.key, required this.patientId});

  @override
  State<PastDrugHistoryScreen> createState() => _PastDrugHistoryScreenState();
}

class _PastDrugHistoryScreenState extends State<PastDrugHistoryScreen> {
  late TextEditingController _medicationAllergyController;
  late TextEditingController _takingMeddicationController;
  late TextEditingController _mentalMedicationController;

  bool isAllergatic = false;
  bool isMedicationAllergatic = false;
  bool isTakingMedication = false;
  bool isMentalMedication = false;

  late Patient patient;

  @override
  void initState() {
    super.initState();

    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;

    patient = patients.firstWhere((patient) => patient.id == widget.patientId);

    _medicationAllergyController = TextEditingController(
      text: patient.medicationAllergatic ?? '',
    );
    _takingMeddicationController = TextEditingController(
      text: patient.takingMedication ?? '',
    );
    _mentalMedicationController = TextEditingController(
      text: patient.mentalMedication ?? '',
    );

    isAllergatic = patient.hasAllergatic ?? false;
    isMedicationAllergatic = patient.hasMedicationAllergatic ?? false;
    isTakingMedication = patient.hasTakingMedication ?? false;
    isMentalMedication = patient.hasMentalMedication ?? false;
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
                onChanged: (value) => setState(() => isAllergatic = value),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label: 'If yes, do you have any allergies to medications?',
                value: isMedicationAllergatic,
                onChanged:
                    (value) => setState(() => isMedicationAllergatic = value),
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
                onChanged:
                    (value) => setState(() => isTakingMedication = value),
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
                value: isMentalMedication,
                onChanged:
                    (value) => setState(() => isMentalMedication = value),
              ),
              if (isMentalMedication)
                LabeledTextField(
                  label:
                      'If yes, please specify the medications, the reason for use, dosage, and their effectiveness:',
                  hintText: 'Medication here...',
                  controller: _mentalMedicationController,
                ),

              const SizedBox(height: 16.0),
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
                      'has_allergies': isAllergatic,
                      'has_medication_allergatic': isMedicationAllergatic,
                      'medication_allergatic':
                          isMedicationAllergatic
                              ? _medicationAllergyController.text.trim()
                              : null,
                      'has_taking_medication': isTakingMedication,
                      'taking_medication':
                          isTakingMedication
                              ? _takingMeddicationController.text.trim()
                              : null,
                      'has_mental_medication': isMentalMedication,
                      'mental_medication':
                          isMentalMedication
                              ? _mentalMedicationController.text.trim()
                              : null,
                    },
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
