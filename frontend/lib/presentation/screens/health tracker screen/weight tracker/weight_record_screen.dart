import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/date_selector_widget.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/time_selector_widget.dart';
import 'package:flutter/material.dart';

class WeightRecordScreen extends StatefulWidget {
  const WeightRecordScreen({Key? key}) : super(key: key);

  @override
  _WeightRecordScreenState createState() => _WeightRecordScreenState();
}

class _WeightRecordScreenState extends State<WeightRecordScreen> {
  DateTime selectedDate = DateTime(2023, 9, 1);
  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 0);

  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController resultController = TextEditingController(
    text:
        'Result appears here\nAccording to your age you are underweight\nAdvice: consult with dr immediately',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Weight Tracker',
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
              controller: systolicController,
              hintText: 'Enter the age',
              keyboardType: TextInputType.number,
              label: 'Age(years)',
            ),
            const SizedBox(height: 20),
            LabeledTextField(
              controller: diastolicController,
              hintText: 'Enter weight here...',
              keyboardType: TextInputType.number,
              label: 'Weight (kg)',
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
