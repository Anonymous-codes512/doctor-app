import 'package:doctor_app/presentation/screens/health%20tracker%20screen/bp%20tracker/bp_empty_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/bp%20tracker/bp_history_screen.dart';
import 'package:flutter/material.dart';

class BpTrackerScreen extends StatelessWidget {
  final List<Map<String, String>> records;

  const BpTrackerScreen({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return BpEmptyScreen();
    } else {
      return BpHistoryScreen(records: records);
    }
  }
}
