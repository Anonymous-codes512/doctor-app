import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/custom_checkbox.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/patient_provider.dart' show PatientProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodAssessmentScreen extends StatefulWidget {
  final int patientId;
  const MoodAssessmentScreen({super.key, required this.patientId});

  @override
  State<MoodAssessmentScreen> createState() => _MoodAssessmentScreenState();
}

class _MoodAssessmentScreenState extends State<MoodAssessmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  TextEditingController _medicalConditionsController = TextEditingController();

  String selectedPhysicalSymptom = 'Select Category';
  double moodLevels = 0;
  String? moodAffectLife;
  String? extremeEnergyPeriods;
  String? recklessSpendingFrequency;
  bool isTakingMedications = false;
  String? alcoholDrugUseFrequency;

  late Patient patient;

  @override
  void initState() {
    super.initState();

    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;
    patient = patients.firstWhere((patient) => patient.id == widget.patientId);

    selectedPhysicalSymptom =
        patient.selectedPhysicalSymptom ?? 'Select Category';
    moodLevels = patient.moodLevels ?? 1.0;
    moodAffectLife = patient.moodAffectLife ?? '';
    extremeEnergyPeriods = patient.extremeEnergyPeriods ?? '';
    recklessSpendingFrequency = patient.recklessSpendingFrequency ?? '';
    isTakingMedications = patient.isTakingMedications ?? false;
    alcoholDrugUseFrequency = patient.alcoholDrugUseFrequency ?? '';

    _medicalConditionsController = TextEditingController(
      text: patient.medicalConditions ?? '',
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
          'Mood assessment form',
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
              LabeledDropdown(
                label: 'Physical Symptoms',
                items: [
                  'Select Category',
                  'Fatigue',
                  'Frequent Headaches',
                  'Muscle Pain',
                  'Other',
                ],
                selectedValue: selectedPhysicalSymptom,
                onChanged: (value) {
                  setState(() {
                    selectedPhysicalSymptom = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Severity and Impact
              const Text(
                'Severity and Impact',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 4),

              const Text(
                'On a scale of 1-10, how severe is your mood issue?',
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 16),

              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primaryColor,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: AppColors.primaryColor,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                ),
                child: Slider(
                  value: moodLevels,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (double value) {
                    setState(() {
                      moodLevels = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'How much does your mood affect daily life?',
                groupValue: moodAffectLife,
                options: ['Not much', 'Somewhat', 'Moderately', 'Severely'],
                onChanged: (value) => setState(() => moodAffectLife = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label:
                    'Have you ever had periods of extreme energy with little sleep?',
                groupValue: extremeEnergyPeriods,
                options: ['no', 'sometimes', 'often'],
                onChanged:
                    (value) => setState(() => extremeEnergyPeriods = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label:
                    'Have you ever spent money recklessly or felt unusually confident?',
                groupValue: recklessSpendingFrequency,
                options: ['no', 'sometimes', 'often'],
                onChanged:
                    (value) =>
                        setState(() => recklessSpendingFrequency = value),
              ),

              const SizedBox(height: 16),

              CustomCheckbox(
                label:
                    'Are you currently taking any medications that affect your mood?',
                value: isTakingMedications,
                onChanged: (value) {
                  // value is now bool?
                  setState(() {
                    isTakingMedications =
                        value ?? false; // Safely handle null, default to false
                  });
                },
              ),
              const SizedBox(height: 16),

              GenderRadioGroup(
                label:
                    'Have you recently used alcohol or drugs more than usual?',
                groupValue: alcoholDrugUseFrequency,
                options: ['no', 'sometimes', 'often'],
                onChanged:
                    (value) => setState(() => alcoholDrugUseFrequency = value),
              ),

              const SizedBox(height: 16),

              LabeledTextField(
                label:
                    'Do you have any medical conditions that may cause mood symptoms?',
                hintText: 'Type...',
                controller: _medicalConditionsController,
              ),

              const SizedBox(height: 16),
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
                      'selected_physical_symptom': selectedPhysicalSymptom,
                      'mood_levels': moodLevels,
                      'mood_affect_life': moodAffectLife,
                      'extreme_energy_periods': extremeEnergyPeriods,
                      'reckless_spending_frequency': recklessSpendingFrequency,
                      'is_taking_medications': isTakingMedications,
                      'alcohol_drug_use_frequency': alcoholDrugUseFrequency,
                      'medical_conditions':
                          _medicalConditionsController.text.trim(),
                    },
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
