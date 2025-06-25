import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalHistoryScreen extends StatefulWidget {
  final int patientId;
  const PersonalHistoryScreen({super.key, required this.patientId});

  @override
  State<PersonalHistoryScreen> createState() => _PersonalHistoryScreenState();
}

class _PersonalHistoryScreenState extends State<PersonalHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? isPlannedPregnancy;
  String? isMaternalSubstanceUseDuringPregnancy;
  String? isBirthDelayed;
  String? isBirthInduced;
  String? isBirthHypoxia;
  String? isImmediatePostNatalComplications;
  String? isRequireOxygenOrIncubator;
  String? isFeedWellAsNewborn;
  String? isSleepWellAsNewborn;

  late Patient patient;

  @override
  void initState() {
    super.initState();

    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;

    patient = patients.firstWhere((patient) => patient.id == widget.patientId);

    isPlannedPregnancy = patient.isPlannedPregnancy;
    isMaternalSubstanceUseDuringPregnancy =
        patient.isMaternalSubstanceUseDuringPregnancy;
    isBirthDelayed = patient.isBirthDelayed;
    isBirthInduced = patient.isBirthInduced;
    isBirthHypoxia = patient.isBirthHypoxia;
    isImmediatePostNatalComplications =
        patient.isImmediatePostNatalComplications;
    isRequireOxygenOrIncubator = patient.isRequireOxygenOrIncubator;
    isFeedWellAsNewborn = patient.isFeedWellAsNewborn;
    isSleepWellAsNewborn = patient.isSleepWellAsNewborn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Personal History',
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
              const SizedBox(height: 16),
              const Text(
                'Please answer the following questions about your birth and early childhood.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 20),

              // Questions
              GenderRadioGroup(
                label: 'Was your birth a planned pregnancy?',
                groupValue: isPlannedPregnancy,
                options: ['yes', 'no'],
                onChanged:
                    (value) => setState(() => isPlannedPregnancy = value),
              ),

              const SizedBox(height: 20),

              GenderRadioGroup(
                label:
                    'Did your mother take alcohol or any other drug substances during pregnancy?',
                groupValue: isMaternalSubstanceUseDuringPregnancy,
                options: ['yes', 'no'],
                onChanged:
                    (value) => setState(
                      () => isMaternalSubstanceUseDuringPregnancy = value,
                    ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Birth Timing and Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              GenderRadioGroup(
                label: 'Was the birth delayed or on time?',
                groupValue: isBirthDelayed,
                options: ['on time', 'delayed'],
                onChanged: (value) => setState(() => isBirthDelayed = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'Was the birth induced or a normal delivery?',
                groupValue: isBirthInduced,
                options: ['normal delivery', 'induced'],
                onChanged: (value) => setState(() => isBirthInduced = value),
              ),

              const SizedBox(height: 20),

              const Text(
                'Birth Complications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              GenderRadioGroup(
                label: 'Was there any lack of oxygen (e.g., cord around neck)?',
                groupValue: isBirthHypoxia,
                options: ['yes', 'no'],
                onChanged: (value) => setState(() => isBirthHypoxia = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label:
                    'Any complications immediately after birth (bleeding, infections, jaundice, etc.)?',
                groupValue: isImmediatePostNatalComplications,
                options: ['yes', 'no'],
                onChanged:
                    (value) => setState(
                      () => isImmediatePostNatalComplications = value,
                    ),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'Did you require oxygen or an incubator?',
                groupValue: isRequireOxygenOrIncubator,
                options: ['yes', 'no'],
                onChanged:
                    (value) =>
                        setState(() => isRequireOxygenOrIncubator = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'Did you feed well as a newborn?',
                groupValue: isFeedWellAsNewborn,
                options: ['yes', 'no'],
                onChanged:
                    (value) => setState(() => isFeedWellAsNewborn = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'Did you sleep well as a newborn?',
                groupValue: isSleepWellAsNewborn,
                options: ['yes', 'no'],
                onChanged:
                    (value) => setState(() => isSleepWellAsNewborn = value),
              ),

              const SizedBox(height: 32),

              // Save Button
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
                      'is_planned_pregnancy': isPlannedPregnancy,
                      'is_maternal_substance_use_during_pregnancy':
                          isMaternalSubstanceUseDuringPregnancy,
                      'is_birth_delayed': isBirthDelayed,
                      'is_birth_induced': isBirthInduced,
                      'is_birth_hypoxia': isBirthHypoxia,
                      'is_immediate_post_natal_complications':
                          isImmediatePostNatalComplications,
                      'is_require_oxygen_or_incubator':
                          isRequireOxygenOrIncubator,
                      'is_feed_well_as_newborn': isFeedWellAsNewborn,
                      'is_sleep_well_as_newborn': isSleepWellAsNewborn,
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
