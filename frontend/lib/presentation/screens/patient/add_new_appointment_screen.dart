import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/custom_date_picker.dart';
import 'package:doctor_app/presentation/widgets/custom_time_picker.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewAppointmentsScreen extends StatefulWidget {
  // Ab sirf patientId required hai, appointmentModel ki zaroorat nahi
  final int patientId;

  const AddNewAppointmentsScreen({
    super.key,
    required this.patientId, // Sirf patientId required hai
  });

  @override
  State<AddNewAppointmentsScreen> createState() =>
      _AddNewAppointmentsScreenState();
}

class _AddNewAppointmentsScreenState extends State<AddNewAppointmentsScreen> {
  Patient? _matchedPatient;

  final TextEditingController _appointmentDurationController =
      TextEditingController();
  final TextEditingController _appointmentFeeController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedReason;
  List<String> reasonOptions = ['consultation', 'follow-up', 'check-up'];

  String? _selectedMode;
  List<String> modeOptions = ['online', 'in-person'];

  String? _selectedPaymentMethod;
  List<String> paymentMethodOptions = [
    'cash',
    'credit card',
    'bank transfer',
    'cheque',
  ];

  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();

    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;

    try {
      _matchedPatient = patients.firstWhere(
        (patient) => patient.id == widget.patientId,
      );
    } catch (e) {
      _matchedPatient = null;
      print(
        'Patient with ID ${widget.patientId} not found. Cannot create appointment without patient data.',
      );
    }

    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  void _saveAppointment(BuildContext context) async {
    if (_matchedPatient == null) {
      ToastHelper.showError(
        context,
        'Patient data is missing. Cannot save appointment.',
      );
      return;
    }
    if (_selectedReason == null ||
        _selectedMode == null ||
        _selectedPaymentMethod == null ||
        _appointmentDurationController.text.isEmpty ||
        _appointmentFeeController.text.isEmpty) {
      ToastHelper.showError(
        context,
        'Please fill all required fields (Duration, Fee, Reason, Mode, Payment Method).',
      );
      return;
    }

    final appointment = AppointmentModel(
      patientId: widget.patientId,
      patientEmail: _matchedPatient!.email!,
      patientName: _matchedPatient!.fullName,
      duration: int.tryParse(_appointmentDurationController.text) ?? 0,
      appointmentReason: _selectedReason,
      appointmentMode: _selectedMode,
      fee: double.tryParse(_appointmentFeeController.text.trim()) ?? 0.0,
      paymentMode: _selectedPaymentMethod,
      description: _descriptionController.text.trim(),
      appointmentDate: selectedDate,
      appointmentTime: selectedTime,
    );

    final provider = Provider.of<DoctorProvider>(context, listen: false);
    provider.setAppointment(appointment);
    await provider.saveAppointment(context);
  }

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
          // Title ab static 'New Appointment' hai
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
              // Patient Email aur Name ab bhi show honge, read-only fields mein
              LabeledTextField(
                label: 'Patient Email',
                hintText: '',
                controller: TextEditingController(
                  text: _matchedPatient?.email ?? 'N/A', // Null check
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Patient Name',
                hintText: '',
                controller: TextEditingController(
                  text: _matchedPatient?.fullName ?? 'N/A', // Null check
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Appointment Duration',
                hintText: 'Enter appointment duration here...',
                controller: _appointmentDurationController,
                keyboardType: TextInputType.number,
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
                label: 'Fee for appointment',
                hintText: 'Enter appointment fee here...',
                controller: _appointmentFeeController,
                keyboardType: TextInputType.number,
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
                    child: PrimaryCustomButton(
                      text: 'Save New', // Button text ab static 'Save New' hai
                      onPressed: () => _saveAppointment(context),
                    ),
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
    _appointmentDurationController.dispose();
    _appointmentFeeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
