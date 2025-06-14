import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

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
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // History Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'History',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.history_rounded, color: Colors.grey[600]),
              ],
            ),

            const Divider(height: 10),
            const SizedBox(height: 24),

            // History Items List
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  _buildHistoryItem(
                    'Past medical history',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.pastMedicalHistoryScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryItem(
                    'Past drug history',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.pastDrugHistoryScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryItem(
                    'Past psychiatric history',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.pastPsychiatricHistoryScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryItem(
                    'Personal history',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.personalHistoryScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryItem(
                    'Family history',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.familyHistoryScreen);
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryItem(
                    'Activities of daily living',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.activitiesOfDailyLivingScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryItem(
                    'Mood info',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.moodInfoScreen);
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryItem(
                    'Mood assessment form',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.moodAssessmentScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xFFbbc5ea), // Light purple background
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
