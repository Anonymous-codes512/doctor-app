import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastPsychiatricHistoryScreen extends StatefulWidget {
  final int patientId;
  const PastPsychiatricHistoryScreen({super.key, required this.patientId});

  @override
  State<PastPsychiatricHistoryScreen> createState() =>
      _PastPsychiatricHistoryScreenState();
}

class _PastPsychiatricHistoryScreenState
    extends State<PastPsychiatricHistoryScreen> {
  TextEditingController _diagnosisHistoryController = TextEditingController();
  TextEditingController _numberOfMentallyDetainedController =
      TextEditingController();
  TextEditingController _detainedMentalHealthTreatmentController =
      TextEditingController();
  TextEditingController _seekingHelpController = TextEditingController();

  List<String> options = ['Yes', 'No'];

  String? isVisitedPsychiatrist;
  String? is72HourMentallyDetentionOrder;
  String? isPsychiatricallyHospitalized;

  bool hasDiagnosisHistory = false;
  bool hasDetainedMentalHealth = false;
  bool hasSeekingHelp = false;

  late Patient patient;

  @override
  void initState() {
    super.initState();
    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;

    patient = patients.firstWhere((patient) => patient.id == widget.patientId);

    isVisitedPsychiatrist = patient.isVisitedPsychiatrist;
    hasDiagnosisHistory = patient.hasDiagnosisHistory ?? false;
    _diagnosisHistoryController = TextEditingController(
      text: patient.diagnosisHistory?.join(', ') ?? '',
    );
    isPsychiatricallyHospitalized = patient.isPsychiatricallyHospitalized;
    is72HourMentallyDetentionOrder = patient.is72HourMentallyDetentionOrder;
    hasDetainedMentalHealth = patient.hasDetainedMentalHealth ?? false;

    _numberOfMentallyDetainedController = TextEditingController(
      text: patient.numberOfMentallyDetained,
    );
    _detainedMentalHealthTreatmentController = TextEditingController(
      text: patient.detainedMentalHealthTreatment,
    );
    hasSeekingHelp = patient.hasSeekingHelp ?? false;
    _seekingHelpController = TextEditingController(text: patient.seekingHelp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,

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
                groupValue: isVisitedPsychiatrist,
                options: options,
                onChanged:
                    (value) => {
                      setState(() {
                        isVisitedPsychiatrist = value;
                      }),
                    },
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
                value: hasDiagnosisHistory,
                onChanged: (value) {
                  setState(() {
                    hasDiagnosisHistory = value;
                  });
                },
              ),
              if (hasDiagnosisHistory)
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
                groupValue: isPsychiatricallyHospitalized,
                options: options,
                onChanged:
                    (value) => {
                      setState(() {
                        isPsychiatricallyHospitalized = value;
                      }),
                    },
              ),
              const SizedBox(height: 16.0),
              Text(
                '4. Mental Health Detention',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GenderRadioGroup(
                label:
                    'Have you ever been subjected to a 72-hour mental health detention order?',
                groupValue: is72HourMentallyDetentionOrder,
                options: options,
                onChanged:
                    (value) => {
                      setState(() {
                        is72HourMentallyDetentionOrder = value;
                      }),
                    },
              ),
              const SizedBox(height: 16.0),
              Text(
                '5. Further Detention',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ToggleSwitchWidget(
                label: 'Have you ever been detained for mental health reasons?',
                value: hasDetainedMentalHealth,
                onChanged: (value) {
                  setState(() {
                    hasDetainedMentalHealth = value;
                  });
                },
              ),
              if (hasDetainedMentalHealth)
                LabeledTextField(
                  label:
                      'If yes, how many times have you been detained and for how long?:',
                  hintText: 'Conditions here...',
                  controller: _numberOfMentallyDetainedController,
                ),
              if (hasDetainedMentalHealth)
                LabeledTextField(
                  label:
                      'What treatment was given for each hospital admission?:',
                  hintText: 'Conditions here...',
                  controller: _detainedMentalHealthTreatmentController,
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
                value: hasSeekingHelp,
                onChanged: (value) {
                  setState(() {
                    hasSeekingHelp = value;
                  });
                },
              ),
              if (hasSeekingHelp)
                LabeledTextField(
                  label: 'If yes, who would you prefer to see and why?',
                  hintText: 'Conditions here...',
                  controller: _seekingHelpController,
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
                      'is_visited_psychiatrist': isVisitedPsychiatrist,
                      'has_diagnosis_history': hasDiagnosisHistory,
                      if (hasDiagnosisHistory)
                        'diagnosis_history':
                            _diagnosisHistoryController.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList(),
                      'is_psychiatrically_hospitalized':
                          isPsychiatricallyHospitalized,
                      'is_72_hour_mentally_detention_order':
                          is72HourMentallyDetentionOrder,
                      'has_detained_mental_health': hasDetainedMentalHealth,
                      if (hasDetainedMentalHealth)
                        'number_of_mentally_detained':
                            _numberOfMentallyDetainedController.text.trim(),
                      if (hasDetainedMentalHealth)
                        'detained_mental_health_treatment':
                            _detainedMentalHealthTreatmentController.text
                                .trim(),
                      'has_seeking_help': hasSeekingHelp,
                      if (hasSeekingHelp)
                        'seeking_help': _seekingHelpController.text.trim(),
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
