import 'package:doctor_app/presentation/screens/patient/health%20tracker%20screen/bmi%20tracker/bmi_empty_screen.dart';
import 'package:doctor_app/presentation/screens/patient/health%20tracker%20screen/bmi%20tracker/bmi_history_screen.dart';

import 'package:flutter/material.dart';

class BMITrackerScreen extends StatelessWidget {
  final List<Map<String, String>> records;

  const BMITrackerScreen({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return BMIEmptyScreen();
    } else {
      return BMIHistoryScreen(records: records);
    }
  }
}
