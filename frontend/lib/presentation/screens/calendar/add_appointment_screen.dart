import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/presentation/widgets/date_selector_widget.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/time_selector_widget.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:provider/provider.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  // final TextEditingController _appointmentController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _consultationNotesController =
      TextEditingController();

  String? _selectedAppointmentReason;
  final List<String> _appointmentReasonOptions = [
    'Follow-up',
    'Check-up',
    'Consultation',
  ];

  String? _selectedPaymentMode;
  final List<String> _paymentModeOptions = [
    'Select payment mode',
    'Cash',
    'Credit card',
    'Bank transfer',
    'cheque',
  ];

  String? _selectedAppointmentMode;
  final List<String> _appointmentModeOptions = ['Online', 'in-person'];

  DateTime initialDate = DateTime.now();
  TimeOfDay initialTime = TimeOfDay.now();

  @override
  void dispose() {
    // _appointmentController.dispose();
    _patientNameController.dispose();
    _durationController.dispose();
    _feeController.dispose();
    _consultationNotesController.dispose();
    super.dispose();
  }

  void onDateChanged(DateTime date) {
    setState(() {
      initialDate = date;
    });
  }

  void onTimeChanged(TimeOfDay time) {
    setState(() {
      initialTime = time;
    });
  }

  void _saveAppointment(BuildContext context) async {
    final appointment = AppointmentModel(
      // appointmentId: _appointmentController.text.trim(),
      patientName: _patientNameController.text.trim(),
      duration: int.tryParse(_durationController.text) ?? 0,
      appointmentReason: _selectedAppointmentReason,
      appointmentMode: _selectedAppointmentMode,
      fee: double.tryParse(_feeController.text.trim()) ?? 0.0,
      paymentMode: _selectedPaymentMode,
      description: _consultationNotesController.text.trim(),
      appointmentDate: initialDate,
      appointmentTime: initialTime,
    );

    final provider = Provider.of<DoctorProvider>(context, listen: false);
    provider.setAppointment(appointment);

    bool saved = await provider.saveAppointment(context);

    if (saved) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Appointment',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // LabeledTextField(
              //   label: 'Appointment ID',
              //   hintText: 'Enter Id Here',
              //   controller: _appointmentController,
              //   keyboardType: TextInputType.number,
              // ),
              // const SizedBox(height: 16),
              LabeledTextField(
                label: 'Patient Name',
                hintText: 'Enter Name Here',
                controller: _patientNameController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Duration of appointment(minutes)',
                hintText: 'Enter Duration Here',
                controller: _durationController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              GenderRadioGroup(
                label: 'Reason of appointment',
                groupValue: _selectedAppointmentReason,
                options: _appointmentReasonOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedAppointmentReason = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              GenderRadioGroup(
                label: 'Mode of appointment',
                groupValue: _selectedAppointmentMode,
                options: _appointmentModeOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedAppointmentMode = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Fee of appointment',
                hintText: 'Enter fee here',
                controller: _feeController,
              ),
              const SizedBox(height: 16),
              LabeledDropdown(
                label: 'Payment mode',
                items: _paymentModeOptions,
                selectedValue: _selectedPaymentMode,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMode = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Description',
                hintText: 'Enter description here',
                controller: _consultationNotesController,
                maxline: 4,
              ),
              const SizedBox(height: 16),
              DateSelectorWidget(
                initialDate: initialDate,
                onDateChanged: onDateChanged,
              ),
              const SizedBox(height: 16),
              TimeSelectorWidget(
                initialTime: initialTime,
                onTimeChanged: onTimeChanged,
              ),
              const SizedBox(height: 16),
              OutlinedCustomButton(
                text: 'Reminder settings',
                onPressed: () {},
                trailingIcon: const Icon(Icons.notifications),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedCustomButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryCustomButton(
                      text: 'Save',
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
}
