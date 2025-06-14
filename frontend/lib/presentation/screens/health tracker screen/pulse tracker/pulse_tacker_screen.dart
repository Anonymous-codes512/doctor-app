import 'package:doctor_app/presentation/screens/health%20tracker%20screen/pulse%20tracker/pulse_empty_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/pulse%20tracker/pulse_history_screen.dart';
import 'package:flutter/material.dart';

class PulseTrackerScreen extends StatelessWidget {
  final List<Map<String, String>> records;

  const PulseTrackerScreen({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return PulseEmptyScreen();
    } else {
      return PulseHistoryScreen(records: records);
    }
  }
}
