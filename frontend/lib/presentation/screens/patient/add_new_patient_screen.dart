import 'dart:io';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/custom_date_picker.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddNewPatientScreen extends StatefulWidget {
  const AddNewPatientScreen({super.key});

  @override
  State<AddNewPatientScreen> createState() => _AddNewPatientScreenState();
}

class _AddNewPatientScreenState extends State<AddNewPatientScreen> {
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
      final fullName =
          "${_firstNameController.text.trim()} ${_middleNameController.text.trim()} ${_surnameController.text.trim()}"
              .trim();
      final height = "${_footController.text}'${_inchController.text}\"";

      final patient = Patient(
        fullName: fullName,
        contact: _contactController.text,
        email: _emailController.text,
        address: _addressController.text,
        weight: _weightController.text,
        height: height,
        bloodPressure: _bpController.text,
        pulse: _pulseController.text,
        allergies: _allergiesController.text,
        dateOfBirth: _selectedDate.toIso8601String(),
        imagePath: _selectedImage?.path,
      );

      Provider.of<PatientProvider>(
        context,
        listen: false,
      ).addPatient(patient, context);
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: const Text(
          'Add New Patient',
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
      body: Consumer<PatientProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              SingleChildScrollView(
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
                        controller: _firstNameController,
                        validator:
                            (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Middle Name',
                        hintText: 'Enter middle name',
                        controller: _middleNameController,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Surname',
                        hintText: 'Enter surname',
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
                        keyboardType: TextInputType.phone,
                        validator:
                            (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextField(
                        label: 'Email',
                        hintText: 'Enter email address',
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
              if (provider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
