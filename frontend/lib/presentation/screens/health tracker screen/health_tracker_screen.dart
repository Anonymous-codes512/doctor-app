import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/health_tiles.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart'; // import here
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthTrackerScreen extends StatelessWidget {
  const HealthTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final List<Map<String, String>> emptyRecords = [];
    final List<Map<String, String>> sampleRecords = [
      {
        'status': 'Normal',
        'date': '12/03/2025',
        'time': '12:00pm',
        'systolic': '120',
        'diastolic': '80',
        'color': 'green',
      },
      {
        'status': 'Hypertension Stage 1',
        'date': '13/03/2025',
        'time': '10:30am',
        'systolic': '140',
        'diastolic': '90',
        'color': 'orange',
      },
      {
        'status': 'Normal',
        'date': '12/03/2025',
        'time': '12:00pm',
        'systolic': '120',
        'diastolic': '80',
        'color': 'green',
      },
      {
        'status': 'Hypertension Stage 1',
        'date': '13/03/2025',
        'time': '10:30am',
        'systolic': '140',
        'diastolic': '90',
        'color': 'orange',
      },
      {
        'status': 'Normal',
        'date': '12/03/2025',
        'time': '12:00pm',
        'systolic': '120',
        'diastolic': '80',
        'color': 'green',
      },
      {
        'status': 'Hypertension Stage 1',
        'date': '13/03/2025',
        'time': '10:30am',
        'systolic': '140',
        'diastolic': '90',
        'color': 'orange',
      },
      {
        'status': 'Normal',
        'date': '12/03/2025',
        'time': '12:00pm',
        'systolic': '120',
        'diastolic': '80',
        'color': 'green',
      },
      {
        'status': 'Hypertension Stage 1',
        'date': '13/03/2025',
        'time': '10:30am',
        'systolic': '140',
        'diastolic': '90',
        'color': 'orange',
      },
      {
        'status': 'Normal',
        'date': '12/03/2025',
        'time': '12:00pm',
        'systolic': '120',
        'diastolic': '80',
        'color': 'green',
      },
      {
        'status': 'Hypertension Stage 1',
        'date': '13/03/2025',
        'time': '10:30am',
        'systolic': '140',
        'diastolic': '90',
        'color': 'orange',
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Health Tracker',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black),
            onPressed: () {
              // Menu action here
            },
          ),
        ],
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
