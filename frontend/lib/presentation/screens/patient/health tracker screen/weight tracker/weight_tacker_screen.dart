import 'package:doctor_app/presentation/screens/patient/health%20tracker%20screen/weight%20tracker/weight_empty_screen.dart';
import 'package:doctor_app/presentation/screens/patient/health%20tracker%20screen/weight%20tracker/weight_history_screen.dart';
import 'package:flutter/material.dart';

class WeightTrackerScreen extends StatelessWidget {
  final List<Map<String, String>> records;

  const WeightTrackerScreen({Key? key, required this.records})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return WeightEmptyScreen();
    } else {
      return WeightHistoryScreen(records: records);
    }
  }
}
