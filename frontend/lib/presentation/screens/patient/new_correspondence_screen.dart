import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/screens/patient/add_new_patient_screen.dart';
import 'package:doctor_app/presentation/widgets/custom_date_picker.dart';
import 'package:doctor_app/presentation/widgets/file_upload_widget.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:flutter/material.dart';

class NewCorrespondenceScreen extends StatefulWidget {
  const NewCorrespondenceScreen({super.key});

  @override
  State<NewCorrespondenceScreen> createState() =>
      _NewCorrespondenceScreenState();
}

class _NewCorrespondenceScreenState extends State<NewCorrespondenceScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final List<String> items = ['Email', 'Phone', 'SMS'];
  String? selectedValue;

  void onChanged(String? value) {
    setState(() {
      selectedValue = value;
    });
  }

  final List<String> recipient = ['Email', 'Phone', 'SMS'];
  String? selectedRecipient;

  DateTime initialDate = DateTime.now();

  void onDateChanged(DateTime date) {
    setState(() {
      initialDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Correspondence',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    Icons.mode_comment_outlined,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('Communication Details', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              LabeledDropdown(
                label: 'Communication Type',
                items: items,
                selectedValue: selectedValue,
                onChanged: onChanged,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Subject',
                hintText: 'Enter subject here...',
                controller: _subjectController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Message',
                hintText: 'Enter message here...',
                controller: _messageController,
                maxline: 4,
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    Icons.attach_file_outlined,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('Attachments', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              FileUploadWidget(),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('Additional Details', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              LabeledDropdown(
                label: 'Recipient',
                items: recipient,
                selectedValue: selectedRecipient,
                onChanged:
                    (value) => {
                      setState(() {
                        selectedRecipient = value;
                      }),
                    },
              ),
              const SizedBox(height: 16),

              CustomDatePicker(
                initialDate: initialDate,
                onDateChanged: onDateChanged,
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedCustomButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryCustomButton(text: 'Save', onPressed: () {}),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
