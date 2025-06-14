import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/custom_date_picker.dart';
import 'package:doctor_app/presentation/widgets/custom_time_picker.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:flutter/material.dart';

class AddNewAppointmentsScreen extends StatefulWidget {
  const AddNewAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AddNewAppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AddNewAppointmentsScreen> {
  final TextEditingController _appointmnetIDController =
      TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _appointmentDurationController =
      TextEditingController();
  final TextEditingController _appointmentFeeController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedGender;
  List<String> genderOptions = ['Male', 'Female', 'Others'];

  String? _selectedReason;
  List<String> reasonOptions = ['Follow-up', 'Checkup', 'Consultation'];

  String? _selectedMode;
  List<String> modeOptions = ['Phyical', 'Online'];

  String? _selectedPaymentMethod;
  List<String> paymentMethodOptions = [
    'Cash',
    'Credit card',
    'Bank transfer',
    'Cheque',
  ];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Appointment',
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
              LabeledTextField(
                label: 'Appointmnent ID',
                hintText: 'Enter appointment here...',
                controller: _appointmnetIDController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Patient Name',
                hintText: 'Enter patient name here...',
                controller: _patientNameController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Appointment Duration',
                hintText: 'Enter appointment duration here...',
                controller: _appointmentDurationController,
              ),
              const SizedBox(height: 16),
              GenderRadioGroup(
                label: 'Gender',
                groupValue: _selectedGender,
                options: genderOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              GenderRadioGroup(
                label: 'Reason of appointment',
                groupValue: _selectedReason,
                options: reasonOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              GenderRadioGroup(
                label: 'Mode of appointment',
                groupValue: _selectedMode,
                options: modeOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedMode = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Fee for appointmrnt',
                hintText: 'Enter appointment fee here...',
                controller: _appointmentFeeController,
              ),
              const SizedBox(height: 16),
              LabeledDropdown(
                label: 'Payment mode',
                items: paymentMethodOptions,
                selectedValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Description',
                hintText: 'Enter description here...',
                controller: _descriptionController,
                maxline: 5,
              ),
              const SizedBox(height: 16),
              CustomDatePicker(
                label: 'Due Date',
                initialDate: selectedDate,
                onDateChanged: (value) {
                  setState(() {
                    selectedDate = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTimePicker(
                label: 'Due Time',
                initialTime: selectedTime,
                onTimeChanged: (value) {
                  setState(() {
                    selectedTime = value;
                  });
                },
              ),
              const SizedBox(height: 24),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryCustomButton(text: 'Save', onPressed: () {}),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
