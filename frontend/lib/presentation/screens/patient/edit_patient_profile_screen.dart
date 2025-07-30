import 'dart:io';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/custom_date_picker.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPatientScreen extends StatefulWidget {
  final int patientId;
  const EditPatientScreen({super.key, required this.patientId});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _weightController = TextEditingController();
  final _footController = TextEditingController();
  final _inchController = TextEditingController();
  final _bpController = TextEditingController();
  final _pulseController = TextEditingController();
  final _allergiesController = TextEditingController();

  DateTime _selectedDate = DateTime(2000, 1, 1);
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    print(widget.patientId);
    Future.delayed(Duration.zero, () async {
      final provider = Provider.of<PatientProvider>(context, listen: false);
      final patient = await provider.getPatientById(widget.patientId);

      if (patient != null) {
        final names = patient.fullName.split(' ');
        _firstNameController.text = names.isNotEmpty ? names[0] : '';
        _middleNameController.text = names.length > 2 ? names[1] : '';
        _surnameController.text = names.length > 1 ? names.last : '';
        _contactController.text = patient.contact ?? '';
        _emailController.text = patient.email ?? '';
        _addressController.text = patient.address ?? '';
        _weightController.text = patient.weight ?? '';
        _bpController.text = patient.bloodPressure ?? '';
        _pulseController.text = patient.pulse ?? '';
        _allergiesController.text = patient.allergies ?? '';
        _selectedDate =
            DateTime.tryParse(patient.dateOfBirth ?? '') ??
            DateTime(2000, 1, 1);

        if (patient.height != null && patient.height!.contains("'")) {
          final parts = patient.height!.split("'");
          _footController.text = parts[0];
          _inchController.text =
              parts.length > 1 ? parts[1].replaceAll('"', '') : '';
        }
      }
    });
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final height = "${_footController.text}'${_inchController.text}\"";
      Provider.of<PatientProvider>(context, listen: false).updatePatientFields(
        context,
        patientId: widget.patientId,
        updatedFields: {
          'address': _addressController.text,
          'weight': _weightController.text,
          'height': height,
          'bloodPressure': _bpController.text,
          'pulse': _pulseController.text,
          'allergies': _allergiesController.text,
          'date_of_birth': _selectedDate.toIso8601String(),
          'image_path': _selectedImage?.path,
        },
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _surnameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _weightController.dispose();
    _footController.dispose();
    _inchController.dispose();
    _bpController.dispose();
    _pulseController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PatientProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: const Text(
          'Edit Patient Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _submitForm(context),
          ),
        ],
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                          child:
                              _selectedImage == null
                                  ? const Icon(Icons.camera_alt)
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LabeledTextField(
                        label: 'First Name',
                        hintText: 'Enter first name',
                        readOnly: true,
                        controller: _firstNameController,
                        validator:
                            (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Middle Name',
                        hintText: 'Enter middle name',
                        readOnly: true,
                        controller: _middleNameController,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Surname',
                        hintText: 'Enter surname',
                        readOnly: true,
                        controller: _surnameController,
                        validator:
                            (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      CustomDatePicker(
                        label: 'Date of Birth',
                        initialDate: _selectedDate,
                        onDateChanged:
                            (date) => setState(() => _selectedDate = date),
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Contact Number',
                        hintText: 'Enter phone number',
                        controller: _contactController,
                        readOnly: true,
                        keyboardType: TextInputType.phone,
                        validator:
                            (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Email',
                        hintText: 'Enter email address',
                        readOnly: true,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Address',
                        hintText: 'Enter address',
                        controller: _addressController,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LabeledTextField(
                              label: 'Weight (kg)',
                              hintText: 'Enter weight in kg',
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LabeledTextField(
                              label: 'Blood Pressure',
                              hintText: 'Enter BP (e.g., 120/80)',
                              controller: _bpController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LabeledTextField(
                              label: 'Height (ft)',
                              hintText: 'Enter feet',
                              controller: _footController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LabeledTextField(
                              label: 'Height (in)',
                              hintText: 'Enter inches',
                              controller: _inchController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Pulse',
                        hintText: 'Enter pulse',
                        controller: _pulseController,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Allergies',
                        hintText: 'Enter any allergies',
                        controller: _allergiesController,
                        maxline: 3,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
    );
  }
}
