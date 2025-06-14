import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:flutter/material.dart';

class HealthTrackerStartScreen extends StatefulWidget {
  const HealthTrackerStartScreen({Key? key}) : super(key: key);

  @override
  State<HealthTrackerStartScreen> createState() =>
      _HealthTrackerStartScreenState();
}

class _HealthTrackerStartScreenState extends State<HealthTrackerStartScreen> {
  String? gender;
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  final blueTextColor = const Color(0xFF2238F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // overall background white
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                ),

                // Title
                const Text(
                  'Health Tracker',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),

                // Skip button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.healthTrackerScreen);
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: blueTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  ImagePath.healthTrackrStartScreenImage,
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Fill the following fields',
                  style: TextStyle(
                    color: blueTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              LabeledTextField(
                label: 'Age (years)',
                hintText: 'Enter age',
                controller: ageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              LabeledTextField(
                label: 'Height (Feet)',
                hintText: 'Enter height',
                controller: heightController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              GenderRadioGroup(
                label: 'Gender:',
                groupValue: gender,
                options: const ['male', 'female'],
                onChanged: (val) {
                  setState(() {
                    gender = val;
                  });
                },
              ),
              const SizedBox(height: 30),
              PrimaryCustomButton(
                text: 'Next',
                onPressed: () {
                  Navigator.pushNamed(context, Routes.healthTrackerScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
