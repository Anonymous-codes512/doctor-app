import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/screens/patient/add_new_patient_screen.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:flutter/material.dart';

class PastPsychiatricHistoryScreen extends StatefulWidget {
  const PastPsychiatricHistoryScreen({super.key});

  @override
  State<PastPsychiatricHistoryScreen> createState() =>
      _PastPsychiatricHistoryScreenState();
}

class _PastPsychiatricHistoryScreenState
    extends State<PastPsychiatricHistoryScreen> {
  TextEditingController _diagnosisHistoryController = TextEditingController();
  TextEditingController _detainedMentalHealthController =
      TextEditingController();
  TextEditingController _detainedMentalHealthtreatmentController =
      TextEditingController();
  TextEditingController _seekingHelpController = TextEditingController();

  String? groupValue;
  List<String> options = ['Yes', 'No'];
  void onChanged(String? value) {
    setState(() {
      groupValue = value;
    });
  }

  bool diagnosisHistory = false;
  bool isDetainedMentalHealth = false;
  bool isSeekingHelp = false;

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
          'Past Psychiatric History',
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
                '1. Previous Psychiatric Consultations',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              GenderRadioGroup(
                label: 'Have you ever seen a psychiatrist before? ',
                groupValue: groupValue,
                options: options,
                onChanged: onChanged,
              ),
              const SizedBox(height: 16.0),
              Text(
                '2. Diagnosis History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label:
                    'Have you ever been diagnosed with a psychiatric disorder?',
                value: diagnosisHistory,
                onChanged: (value) {
                  setState(() {
                    diagnosisHistory = value;
                  });
                },
              ),
              if (diagnosisHistory)
                LabeledTextField(
                  label: 'If yes, please list the diagnoses: ',
                  hintText: 'Conditions here...',
                  controller: _diagnosisHistoryController,
                ),
              const SizedBox(height: 16.0),
              Text(
                '3. Hospitaliozation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GenderRadioGroup(
                label: 'Have you ever been admitted to a psychiatric ward?',
                groupValue: groupValue,
                options: options,
                onChanged: onChanged,
              ),
              const SizedBox(height: 16.0),
              Text(
                '4. Mental Health Detention',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GenderRadioGroup(
                label:
                    'Have you ever been subjected to a 72-hour mental health detention order?',
                groupValue: groupValue,
                options: options,
                onChanged: onChanged,
              ),
              const SizedBox(height: 16.0),
              Text(
                '5. Further Detention',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label: 'Have you ever been detained for mental health reasons?',
                value: isDetainedMentalHealth,
                onChanged: (value) {
                  setState(() {
                    isDetainedMentalHealth = value;
                  });
                },
              ),
              if (isDetainedMentalHealth)
                LabeledTextField(
                  label:
                      'If yes, how many times have you been detained and for how long?:',
                  hintText: 'Conditions here...',
                  controller: _detainedMentalHealthController,
                ),
              if (isDetainedMentalHealth)
                LabeledTextField(
                  label:
                      'What treatment was given for each hospital admission?:',
                  hintText: 'Conditions here...',
                  controller: _detainedMentalHealthtreatmentController,
                ),
              const SizedBox(height: 16.0),
              Text(
                '6. Willingness to Seek Help',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label:
                    'Are you open to seeing a psychiatrist or mental health professional?',
                value: isSeekingHelp,
                onChanged: (value) {
                  setState(() {
                    isSeekingHelp = value;
                  });
                },
              ),
              if (isSeekingHelp)
                LabeledTextField(
                  label: 'If yes, who would you prefer to see and why?',
                  hintText: 'Conditions here...',
                  controller: _seekingHelpController,
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
