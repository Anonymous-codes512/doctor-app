import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/health_tiles.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HealthTrackerScreen extends StatefulWidget {
  final int patientId;
  const HealthTrackerScreen({super.key, required this.patientId});

  @override
  State<HealthTrackerScreen> createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  late List<Patient> _patient;
  late PatientProvider _patientProvider;

  List<Map<String, String>> sampleRecords = [];

  @override
  void initState() {
    super.initState();
    _patientProvider = Provider.of<PatientProvider>(context, listen: false);
    _patient = _patientProvider.patients;
    _patientProvider.fetchHealthRecords(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Health Tracker',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: AppColors.warningColor,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Daily Health Tip!',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Stay hydrated! Drink at least 8 glasses of water daily.',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  HealthTile(
                    title: 'Weight Tracker',
                    icon: Image.asset(
                      ImagePath.weightTrackerImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.weightTrackerScreen,
                        arguments: sampleRecords,
                      );
                    },
                  ),
                  HealthTile(
                    title: 'BMI Tracker',
                    icon: Image.asset(
                      ImagePath.bmiTrackerImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.bmiTrackerScreen,
                        arguments: sampleRecords,
                      );
                    },
                  ),
                  HealthTile(
                    title: 'BP Tracker',
                    icon: Image.asset(
                      ImagePath.bpTrackerImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.bpTrackerScreen,
                        arguments: sampleRecords,
                      );
                    },
                  ),
                  HealthTile(
                    title: 'Pulse Tracker',
                    icon: Image.asset(
                      ImagePath.pulseTrackerImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.pulseTrackerScreen,
                        arguments: sampleRecords,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LargeHealthTile(
                title: 'Steps & Calories Counter',
                icon: Image.asset(ImagePath.calories),
                stepsIcons: [
                  Image.asset(ImagePath.step1, width: 20, height: 20),
                  Image.asset(ImagePath.step2, width: 25, height: 25),
                  Image.asset(ImagePath.step3, width: 30, height: 30),
                ],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.stepsAndCaloriesCounterScreen,
                  );
                },
              ),
              const SizedBox(height: 30),
              OutlinedCustomButton(
                text: 'Analysis',
                trailingIcon: Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.grey.shade700,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.analysisScreen);
                },
              ),
              const SizedBox(height: 10),
              OutlinedCustomButton(
                text: 'Reminders settings',
                trailingIcon: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.grey.shade700,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.remindersSettingsScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
