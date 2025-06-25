import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyHistoryScreen extends StatefulWidget {
  final int patientId;

  const FamilyHistoryScreen({super.key, required this.patientId});

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

  late Patient patient;

  @override
  void initState() {
    super.initState();

    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;

    patient = patients.firstWhere((patient) => patient.id == widget.patientId);

    hasFamilyMentalHealthHistory =
        patient.hasFamilyMentalHealthHistory ?? false;

    _familyRelationshipDetailsController = TextEditingController(
      text: patient.familyRelationshipDetails,
    );

    _familyMentalHealthConditionController = TextEditingController(
      text: patient.familyMentalHealthCondition,
    );

    hasBeenHospitalizedForMentalHealth =
        patient.hasBeenHospitalizedForMentalHealth ?? false;

    _numberOfAdmissionsController = TextEditingController(
      text: patient.numberOfAdmissions,
    );
    _durationControllers = TextEditingController(text: patient.duration);
    _outcomeControllers = TextEditingController(text: patient.outcome);
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
                      'has_family_mental_health_history':
                          hasFamilyMentalHealthHistory,
                      if (hasFamilyMentalHealthHistory)
                        'family_relationship_details':
                            _familyRelationshipDetailsController.text.trim(),
                      if (hasFamilyMentalHealthHistory)
                        'family_mental_health_condition':
                            _familyMentalHealthConditionController.text.trim(),

                      'has_been_hospitalized_for_mental_health':
                          hasBeenHospitalizedForMentalHealth,
                      if (hasBeenHospitalizedForMentalHealth)
                        'number_of_admissions':
                            _numberOfAdmissionsController.text.trim(),
                      if (hasBeenHospitalizedForMentalHealth)
                        'duration': _durationControllers.text.trim(),
                      if (hasBeenHospitalizedForMentalHealth)
                        'outcome': _outcomeControllers.text.trim(),
                    },
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
