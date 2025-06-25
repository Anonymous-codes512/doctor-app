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
  final TextEditingController _medicalConditionsController =
      TextEditingController();

  String selectedCategory = 'Select Category';
  double moodScale = 1.0;
  String? moodAffectLife;
  String? extremeEnergy;
  String? recklessSpending;
  bool takingMedications = false;
  String? alcoholDrugUse;
  late Patient patient;

  @override
  void initState() {
    super.initState();

    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;

    patient = patients.firstWhere((patient) => patient.id == widget.patientId);
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
                selectedValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
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
                  value: moodScale,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (double value) {
                    setState(() {
                      moodScale = value;
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
                groupValue: extremeEnergy,
                options: ['no', 'sometimes', 'often'],
                onChanged: (value) => setState(() => extremeEnergy = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label:
                    'Have you ever spent money recklessly or felt unusually confident?',
                groupValue: recklessSpending,
                options: ['no', 'sometimes', 'often'],
                onChanged: (value) => setState(() => recklessSpending = value),
              ),

              const SizedBox(height: 16),

              CustomCheckbox(
                label:
                    'Are you currently taking any medications that affect your mood?',
                value: takingMedications,
                onChanged: (value) {
                  // value is now bool?
                  setState(() {
                    takingMedications =
                        value ?? false; // Safely handle null, default to false
                  });
                },
              ),
              const SizedBox(height: 16),

              GenderRadioGroup(
                label:
                    'Have you recently used alcohol or drugs more than usual?',
                groupValue: alcoholDrugUse,
                options: ['no', 'sometimes', 'often'],
                onChanged: (value) => setState(() => alcoholDrugUse = value),
              ),

              const SizedBox(height: 16),

              LabeledTextField(
                label:
                    'Do you have any medical conditions that may cause mood symptoms?',
                hintText: 'Type...',
                controller: _medicalConditionsController,
              ),

              const SizedBox(height: 16),
              PrimaryCustomButton(text: 'Save', onPressed: () {}),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
