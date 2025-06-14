import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/date_selector_widget.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/time_selector_widget.dart';
import 'package:flutter/material.dart';

class PulseRecordScreen extends StatefulWidget {
  const PulseRecordScreen({Key? key}) : super(key: key);

  @override
  _PulseRecordScreenState createState() => _PulseRecordScreenState();
}

class _PulseRecordScreenState extends State<PulseRecordScreen> {
  DateTime selectedDate = DateTime(2023, 9, 1);
  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 0);

  final TextEditingController pulseController = TextEditingController();
  final TextEditingController resultController = TextEditingController(
    text:
        'Result appears here\nBradycardia - Low Pulse\nAdvice: consult with dr immediately',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Pulse Tracker',
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
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            DateSelectorWidget(
              initialDate: selectedDate,
              onDateChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 20),
            TimeSelectorWidget(
              initialTime: selectedTime,
              onTimeChanged: (time) {
                setState(() {
                  selectedTime = time;
                });
              },
            ),
            const SizedBox(height: 20),
            LabeledTextField(
              controller: pulseController,
              hintText: 'Enter the pulse(between 40 to 300)',
              keyboardType: TextInputType.number,
              label: 'Pulse(BPM)',
            ),

            const SizedBox(height: 20),
            Text('Result:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: resultController,
              maxLines: 4,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 24),
            PrimaryCustomButton(
              text: 'Save',
              onPressed: () {
                // Implement save logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
