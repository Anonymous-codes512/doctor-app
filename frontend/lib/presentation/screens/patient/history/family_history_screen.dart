import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:flutter/material.dart';

class FamilyHistoryScreen extends StatefulWidget {
  const FamilyHistoryScreen({super.key});

  @override
  State<FamilyHistoryScreen> createState() => _FamilyHistoryScreenState();
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {
  TextEditingController _familyRelationshipDetailsController =
      TextEditingController();
  TextEditingController _familyMentalHealthConditionController =
      TextEditingController();

  TextEditingController _numberOfAdmissionsController = TextEditingController();
  TextEditingController _durationControllers = TextEditingController();
  TextEditingController _outcomeControllers = TextEditingController();

  bool hasFamilyMentalHealthHistory = false;
  bool hasBeenHospitalizedForMentalHealth = false;

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
          'Family History',
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
              ToggleSwitchWidget(
                label:
                    'Does anyone in your family suffer from mental health-related issues?',
                value: hasFamilyMentalHealthHistory,
                onChanged: (value) {
                  setState(() {
                    hasFamilyMentalHealthHistory = value;
                  });
                },
              ),
              if (hasFamilyMentalHealthHistory)
                Text(
                  'If yes, then give following details:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              if (hasFamilyMentalHealthHistory)
                LabeledTextField(
                  label:
                      'Please specify how they are related to you (e.g., mother\'s brother)',
                  hintText: 'Type here...',
                  controller: _familyRelationshipDetailsController,
                ),
              if (hasFamilyMentalHealthHistory)
                LabeledTextField(
                  label: 'What mental health condition do they have?',
                  hintText: 'Type here...',
                  controller: _familyMentalHealthConditionController,
                ),
              const SizedBox(height: 16.0),

              ToggleSwitchWidget(
                label:
                    'Have they been admitted to a hospital for mental health treatment?',
                value: hasBeenHospitalizedForMentalHealth,
                onChanged: (value) {
                  setState(() {
                    hasBeenHospitalizedForMentalHealth = value;
                  });
                },
              ),
              if (hasBeenHospitalizedForMentalHealth)
                Text(
                  'If yes, then give following details:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              if (hasBeenHospitalizedForMentalHealth)
                LabeledTextField(
                  label: 'How many times have they been admitted?',
                  hintText: 'Type here...',
                  controller: _numberOfAdmissionsController,
                ),
              if (hasBeenHospitalizedForMentalHealth)
                LabeledTextField(
                  label: 'What was the duration of each hospital stay?',
                  hintText: 'Type here...',
                  controller: _durationControllers,
                ),
              if (hasBeenHospitalizedForMentalHealth)
                LabeledTextField(
                  label: 'What was the outcome of each hospital stay?',
                  hintText: 'Type here...',
                  controller: _outcomeControllers,
                ),
              const SizedBox(height: 16.0),
              PrimaryCustomButton(text: 'Save', onPressed: () {}),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
