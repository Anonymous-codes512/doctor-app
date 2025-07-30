import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/date_selector_widget.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/time_selector_widget.dart';
import 'package:flutter/material.dart';

class BMIRecordScreen extends StatefulWidget {
  const BMIRecordScreen({Key? key}) : super(key: key);

  @override
  _BMIRecordScreenState createState() => _BMIRecordScreenState();
}

class _BMIRecordScreenState extends State<BMIRecordScreen> {
  DateTime selectedDate = DateTime(2023, 9, 1);
  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 0);

  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController resultController = TextEditingController(
    text:
        'Result appears here\nBMI= 50.3  kg/m²\n"Obesity\nAdvice: consult with dr immediately',
  );

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
              hintText: 'Enter the weight',
              keyboardType: TextInputType.number,
              label: 'Weight(Kg)',
            ),
            const SizedBox(height: 20),
            LabeledTextField(
              controller: diastolicController,
              hintText: 'Enter Height here...',
              keyboardType: TextInputType.number,
              label: 'Height (Feet)',
            ),
            const SizedBox(height: 20),
            Text('BMI (Kg/m²):', style: TextStyle(fontWeight: FontWeight.w600)),
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
