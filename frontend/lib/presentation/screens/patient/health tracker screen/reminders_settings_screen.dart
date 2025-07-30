import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/reminder_item.dart';
import 'package:flutter/material.dart';

class RemindersSettingsScreen extends StatefulWidget {
  const RemindersSettingsScreen({super.key});

  @override
  State<RemindersSettingsScreen> createState() =>
      _RemindersSettingsScreenState();
}

class _RemindersSettingsScreenState extends State<RemindersSettingsScreen> {
  // State for all reminders: enabled status and frequency
  final Map<String, bool> _enabledMap = {
    'Weight Tracker Reminder': false,
    'BMI Tracker Reminder': false,
    'BP Tracker Reminder': false,
    'Pulse Tracker Reminder': false,
    'Step & Calories Counter Reminder': false,
  };

  final Map<String, String> _frequencyMap = {
    'Weight Tracker Reminder': 'daily',
    'BMI Tracker Reminder': 'daily',
    'BP Tracker Reminder': 'daily',
    'Pulse Tracker Reminder': 'daily',
    'Step & Calories Counter Reminder': 'daily',
  };

  @override
  Widget build(BuildContext context) {
    final reminders = _enabledMap.keys.toList();

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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reminders Settings',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Bell icon circle
            CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              radius: 30,
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),

            // Reminder list inside Expanded & Scroll
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final title = reminders[index];
                    return ReminderItem(
                      title: title,
                      isEnabled: _enabledMap[title] ?? false,
                      frequency: _frequencyMap[title] ?? 'daily',
                      onToggle: (val) {
                        setState(() {
                          _enabledMap[title] = val;
                          // If disabled, reset frequency to daily for UX consistency
                          if (!val) {
                            _frequencyMap[title] = 'daily';
                          }
                        });
                      },
                      onFrequencyChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _frequencyMap[title] = val;
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ),

            // Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedCustomButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryCustomButton(
                      text: 'Save',
                      onPressed: () {
                        // Implement save logic
                        // You can gather data from _enabledMap and _frequencyMap here
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
