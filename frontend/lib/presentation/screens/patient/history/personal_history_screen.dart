import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:flutter/material.dart';

class PersonalHistoryScreen extends StatefulWidget {
  const PersonalHistoryScreen({super.key});

  @override
  State<PersonalHistoryScreen> createState() => _PersonalHistoryScreenState();
}

class _PersonalHistoryScreenState extends State<PersonalHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? plannedPregnancy;
  String? alcoholDuringPregnancy;
  String? birthTiming;
  String? birthMethod;
  String? oxygenLack;
  String? birthComplications;
  String? requiredOxygen;
  String? fedWell;
  String? sleptWell;

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
                groupValue: plannedPregnancy,
                options: ['yes', 'no'],
                onChanged: (value) => setState(() => plannedPregnancy = value),
              ),

              const SizedBox(height: 20),

              GenderRadioGroup(
                label:
                    'Did your mother take alcohol or any other drug substances during pregnancy?',
                groupValue: alcoholDuringPregnancy,
                options: ['yes', 'no'],
                onChanged:
                    (value) => setState(() => alcoholDuringPregnancy = value),
              ),

              const SizedBox(height: 20),

              const Text(
                'Birth Timing and Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              GenderRadioGroup(
                label: 'Was the birth delayed or on time?',
                groupValue: birthTiming,
                options: ['on time', 'delayed'],
                onChanged: (value) => setState(() => birthTiming = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'Was the birth induced or a normal delivery?',
                groupValue: birthMethod,
                options: ['normal delivery', 'induced'],
                onChanged: (value) => setState(() => birthMethod = value),
              ),

              const SizedBox(height: 20),

              const Text(
                'Birth Complications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              GenderRadioGroup(
                label: 'Was there any lack of oxygen (e.g., cord around neck)?',
                groupValue: oxygenLack,
                options: ['yes', 'no'],
                onChanged: (value) => setState(() => oxygenLack = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label:
                    'Any complications immediately after birth (bleeding, infections, jaundice, etc.)?',
                groupValue: birthComplications,
                options: ['yes', 'no'],
                onChanged:
                    (value) => setState(() => birthComplications = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'Did you require oxygen or an incubator?',
                groupValue: requiredOxygen,
                options: ['yes', 'no'],
                onChanged: (value) => setState(() => requiredOxygen = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'Did you feed well as a newborn?',
                groupValue: fedWell,
                options: ['yes', 'no'],
                onChanged: (value) => setState(() => fedWell = value),
              ),

              const SizedBox(height: 16),

              GenderRadioGroup(
                label: 'Did you sleep well as a newborn?',
                groupValue: sleptWell,
                options: ['yes', 'no'],
                onChanged: (value) => setState(() => sleptWell = value),
              ),

              const SizedBox(height: 32),

              // Save Button
              PrimaryCustomButton(
                text: 'Save',
                onPressed: () {
                  // Handle save action
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
