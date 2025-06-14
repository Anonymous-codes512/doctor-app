import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/weight_result_card.dart';
import 'package:flutter/material.dart';

class BMIHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> records;

  const BMIHistoryScreen({Key? key, required this.records}) : super(key: key);

  Color _getColor(String color) {
    switch (color) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'BMI Tracker',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final rec = records[index];
                  return WeightResultCard(
                    status: rec['status']!,
                    date: rec['date']!,
                    time: rec['time']!,
                    weight: rec['diastolic']!,
                    statusColor: _getColor(rec['color']!),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            PrimaryCustomButton(
              text: 'Record',
              onPressed: () {
                Navigator.pushNamed(context, Routes.bmiRecordScreen);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
