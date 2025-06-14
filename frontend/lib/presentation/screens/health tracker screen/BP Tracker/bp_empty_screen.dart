import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:flutter/material.dart';

class BpEmptyScreen extends StatelessWidget {
  const BpEmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'BP Tracker',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(), // Push content to center vertically
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.block, size: 50, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  'No data yet',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            Spacer(), // Push button to bottom
            PrimaryCustomButton(
              text: 'Record',
              onPressed: () {
                Navigator.pushNamed(context, Routes.bpRecordScreen);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
