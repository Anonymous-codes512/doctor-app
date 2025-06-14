import 'dart:ui';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/date_selector_widget.dart'; // Import DateSelectorWidget

class CustomStepPopup extends StatelessWidget {
  final TextEditingController controller;
  final Function onSave;
  final Function onCancel;
  final bool isSteptarget;

  const CustomStepPopup({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.isSteptarget = false,
  }) : super(key: key);

  // Callback to handle date change from DateSelectorWidget
  void _onDateChanged(DateTime selectedDate) {
    // Handle the selected date logic (for example, you could update the UI or pass it to a function)
    print('Selected date: $selectedDate');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button top-right
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 20),
              ),
            ),
            const Text(
              "Edit Steps",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),

            // If isSteptarget is true, show DateSelectorWidget
            if (isSteptarget)
              Column(
                children: [
                  DateSelectorWidget(
                    initialDate: DateTime.now(),
                    onDateChanged:
                        _onDateChanged, // Pass the callback for date change
                  ),
                  const SizedBox(
                    height: 30,
                  ), // Space below the DateSelectorWidget
                ],
              ),
            // LabeledTextField for steps input
            LabeledTextField(
              label: "Edit Steps",
              hintText: "Enter steps here",
              controller: controller,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedCustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      onCancel();
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // Save Button
                Expanded(
                  child: PrimaryCustomButton(
                    text: 'Done',
                    onPressed: () {
                      onSave();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class ViewTargetStepsDialog extends StatefulWidget {
  final List<Map<String, dynamic>> stepsData;
  final Function onDelete;
  final Function onCancel;

  const ViewTargetStepsDialog({
    Key? key,
    required this.stepsData,
    required this.onDelete,
    required this.onCancel,
  }) : super(key: key);

  @override
  _ViewTargetStepsDialogState createState() => _ViewTargetStepsDialogState();
}

class _ViewTargetStepsDialogState extends State<ViewTargetStepsDialog> {
  late List<bool> selectedItems;

  @override
  void initState() {
    super.initState();
    // Initialize the selectedItems list to track the checkbox state
    selectedItems = List.generate(widget.stepsData.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            // Content Popup
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Steps & Calories Counter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.stepsData.length,
                          itemBuilder: (context, index) {
                            final step = widget.stepsData[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(),
                              ),
                              child: Row(
                                children: [
                                  // Checkbox Before Data - Managed independently
                                  Checkbox(
                                    activeColor: AppColors.primaryColor,
                                    value: selectedItems[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedItems[index] = value ?? false;
                                      });
                                    },
                                  ),
                                  // Data Section
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Date: ${step['date']}'),
                                            Text(
                                              step['target'],
                                              style: TextStyle(
                                                color:
                                                    Colors
                                                        .blue, // Customize as per AppColors
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Target: ${step['status']}",
                                          style: TextStyle(
                                            color:
                                                step['status'] == 'Accomplished'
                                                    ? Colors.green
                                                    : step['status'] ==
                                                        'Exceeded'
                                                    ? Colors.orange
                                                    : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedCustomButton(
                              onPressed: () => widget.onCancel(),
                              text: 'Cancel',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: PrimaryCustomButton(
                              text: 'Delete',
                              isdelete: true,
                              onPressed: () => widget.onDelete(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
