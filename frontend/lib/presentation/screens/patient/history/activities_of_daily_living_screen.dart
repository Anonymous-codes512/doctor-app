import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/patient_provider.dart' show PatientProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivitiesOfDailyLivingScreen extends StatefulWidget {
  final int patientId;
  const ActivitiesOfDailyLivingScreen({super.key, required this.patientId});

  @override
  State<ActivitiesOfDailyLivingScreen> createState() =>
      _ActivitiesOfDailyLivingScreenState();
}

class _ActivitiesOfDailyLivingScreenState
    extends State<ActivitiesOfDailyLivingScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? showerAbility;
  String? showerFrequency;
  String? dressingAbility;
  String? eatingAbility;
  String? foodType;
  String? toiletingAbility;
  String? groomingAbility;
  String? menstrualManagement;
  String? householdTasks;
  String? dailyAffairs;
  String? safetyMobility;

  late Patient patient;

  @override
  void initState() {
    super.initState();

    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;
    patient = patients.firstWhere((patient) => patient.id == widget.patientId);

    showerAbility = patient.showerAbility;
    showerFrequency = patient.showerFrequency;
    dressingAbility = patient.dressingAbility;
    eatingAbility = patient.eatingAbility;
    foodType = patient.foodType;
    toiletingAbility = patient.toiletingAbility;
    groomingAbility = patient.groomingAbility;
    menstrualManagement = patient.menstrualManagement;
    householdTasks = patient.householdTasks;
    dailyAffairs = patient.dailyAffairs;
    safetyMobility = patient.safetyMobility;
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
          'Activities of daily living',
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
                '1. Personal Hygiene',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),
              GenderRadioGroup(
                label: 'Are you able to shower independently?',
                groupValue: showerAbility,
                options: ['independently', 'with assistance'],
                onChanged: (value) => setState(() => showerAbility = value),
              ),

              const SizedBox(height: 12),

              GenderRadioGroup(
                label: 'How regularly do you shower?',
                groupValue: showerFrequency,
                options: [
                  'daily',
                  'every other day',
                  'weekly',
                  'less frequently',
                ],
                onChanged: (value) => setState(() => showerFrequency = value),
              ),

              const SizedBox(height: 16),

              // 2. Dressing
              const Text(
                '2. Dressing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              GenderRadioGroup(
                label: 'Are you able to dress yourself?',
                groupValue: dressingAbility,
                options: ['independently', 'with assistance'],
                onChanged: (value) => setState(() => dressingAbility = value),
              ),

              const SizedBox(height: 16),

              // 3. Eating
              const Text(
                '3. Eating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              GenderRadioGroup(
                label: 'Are you able to feed yourself?',
                groupValue: eatingAbility,
                options: ['independently', 'with assistance', 'not applicable'],
                onChanged: (value) => setState(() => eatingAbility = value),
              ),

              const SizedBox(height: 12),

              GenderRadioGroup(
                label: 'Do you mostly consume healthy or unhealthy foods?',
                groupValue: foodType,
                options: ['healthy', 'unhealthy'],
                onChanged: (value) => setState(() => foodType = value),
              ),

              const SizedBox(height: 16),

              // 4. Toileting
              const Text(
                '4. Toileting',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              GenderRadioGroup(
                label: 'Can you use the toilet independently?',
                groupValue: toiletingAbility,
                options: ['independently', 'with assistance'],
                onChanged: (value) => setState(() => toiletingAbility = value),
              ),

              const SizedBox(height: 16),

              // 5. Grooming
              const Text(
                '5. Grooming',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),
              GenderRadioGroup(
                label:
                    'Can you complete personal grooming tasks (e.g., shaving, brushing teeth, cutting nails) by yourself?',
                groupValue: groomingAbility,
                options: ['independently', 'with assistance'],
                onChanged: (value) => setState(() => groomingAbility = value),
              ),

              const SizedBox(height: 16),

              // 6. Menstrual Management
              const Text(
                '6. Menstrual Management (if applicable)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              GenderRadioGroup(
                label:
                    'If applicable, can you manage menstrual hygiene independently?',
                groupValue: menstrualManagement,
                options: ['independently', 'with assistance'],
                onChanged:
                    (value) => setState(() => menstrualManagement = value),
              ),

              const SizedBox(height: 16),

              // 7. Household Tasks
              const Text(
                '7. Household Tasks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              GenderRadioGroup(
                label:
                    'Can you perform household tasks (e.g., cleaning, cooking, laundry, ironing, shopping) independently?',
                groupValue: householdTasks,
                options: ['independently', 'with assistance', 'not applicable'],
                onChanged: (value) => setState(() => householdTasks = value),
              ),

              const SizedBox(height: 16),

              // 8. Management of Daily Affairs
              const Text(
                '8. Management of Daily Affairs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              GenderRadioGroup(
                label:
                    'Can you manage daily affairs such as bills, appointments, correspondence, banking, forms, finances, and travel independently?',
                groupValue: dailyAffairs,
                options: ['independently', 'with assistance'],
                onChanged: (value) => setState(() => dailyAffairs = value),
              ),

              const SizedBox(height: 16),

              // 9. Safety and Mobility
              const Text(
                '9. Safety and Mobility',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              GenderRadioGroup(
                label:
                    'Can you ensure your own safety and travel independently outside the home?',
                groupValue: safetyMobility,
                options: ['independently', 'with assistance'],
                onChanged: (value) => setState(() => safetyMobility = value),
              ),

              const SizedBox(height: 12),
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
                      'shower_ability': showerAbility,
                      'shower_frequency': showerFrequency,
                      'dressing_ability': dressingAbility,
                      'eating_ability': eatingAbility,
                      'food_type': foodType,
                      'toileting_ability': toiletingAbility,
                      'grooming_ability': groomingAbility,
                      'menstrual_management': menstrualManagement,
                      'household_tasks': householdTasks,
                      'daily_affairs': dailyAffairs,
                      'safety_mobility': safetyMobility,
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
