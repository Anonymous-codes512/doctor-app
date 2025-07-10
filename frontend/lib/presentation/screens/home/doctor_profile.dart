import 'dart:io';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:doctor_app/data/models/doctor_model.dart';
import 'package:doctor_app/presentation/widgets/custom_date_picker.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final _formKey = GlobalKey<FormState>();

  late DoctorProvider _doctorProvider;
  late DoctorModel doctor;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _specializationController = TextEditingController();
  final _subSpecializationController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _practiceNameController = TextEditingController();
  final _practiceAddressController = TextEditingController();
  final _initialConsultationFeeController = TextEditingController();
  final _sessionTypeController = TextEditingController();
  final _sessionDurationController = TextEditingController();

  DateTime _dateOfBirth = DateTime(2000, 1, 1);
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? gender;
  String? doctorName;
  ImageProvider? profileImage;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    doctor = _doctorProvider.doctor;
    profileImage =
        _doctorProvider.refineImagePath(doctor.imagePath!) ??
        AssetImage(ImagePath.profileAvatar);
    doctorName = _doctorProvider.getInitials(doctor.fullName!);

    // Initialize controllers with doctor data
    _fullNameController.text = doctor.fullName ?? '';
    _emailController.text = doctor.email ?? '';
    _contactController.text = doctor.contact ?? '';
    // Check if doctor.gender is a valid option before setting
    if (doctor.gender != null) {
      gender = doctor.gender;
    }
    _bloodGroupController.text = doctor.bloodGroup ?? '';
    _specializationController.text = doctor.specialization ?? '';
    _subSpecializationController.text = doctor.subSpecialization ?? '';
    _yearsOfExperienceController.text = doctor.yearsOfExperience ?? '';
    _qualificationController.text = doctor.qualification ?? '';
    _registrationNumberController.text = doctor.registrationNumber ?? '';
    _practiceNameController.text = doctor.practiceName ?? '';
    _practiceAddressController.text = doctor.practiceAddress ?? '';
    _initialConsultationFeeController.text =
        doctor.initialConsultationFee?.toString() ?? '';
    _sessionTypeController.text = doctor.sessionType ?? '';
    _sessionDurationController.text = doctor.sessionDuration ?? '';
    _dateOfBirth = DateTime.parse(doctor.dateOfBirth ?? '2000-01-01');
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final updatedDoctor = DoctorModel(
        fullName: _fullNameController.text,
        email: _emailController.text,
        contact: _contactController.text,
        gender: gender,
        bloodGroup: _bloodGroupController.text,
        specialization: _specializationController.text,
        subSpecialization: _subSpecializationController.text,
        yearsOfExperience: _yearsOfExperienceController.text,
        qualification: _qualificationController.text,
        registrationNumber: _registrationNumberController.text,
        practiceName: _practiceNameController.text,
        practiceAddress: _practiceAddressController.text,
        sessionType: _sessionTypeController.text,
        sessionDuration: _sessionDurationController.text,
        initialConsultationFee:
            double.tryParse(_initialConsultationFeeController.text) ?? 0.0,
        dateOfBirth: _dateOfBirth.toIso8601String(),
        imagePath: _selectedImage?.path,
      );

      Provider.of<DoctorProvider>(
        context,
        listen: false,
      ).updateDoctor(updatedDoctor, context);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _bloodGroupController.dispose();
    _specializationController.dispose();
    _subSpecializationController.dispose();
    _yearsOfExperienceController.dispose();
    _qualificationController.dispose();
    _registrationNumberController.dispose();
    _practiceNameController.dispose();
    _practiceAddressController.dispose();
    _initialConsultationFeeController.dispose();
    _sessionTypeController.dispose();
    _sessionDurationController.dispose();
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
          'Doctor Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, doctorProvider, _) {
          doctor = doctorProvider.doctor;
          profileImage =
              doctorProvider.refineImagePath(doctor.imagePath!) ??
              AssetImage(ImagePath.profileAvatar);
          doctorName = doctorProvider.getInitials(doctor.fullName!);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius:
                                    50, // Increased radius for better visibility
                                backgroundImage:
                                    _selectedImage != null
                                        ? FileImage(_selectedImage!)
                                        : profileImage,
                                backgroundColor: AppColors.primaryColor
                                    .withOpacity(0.3),
                                child:
                                    _selectedImage == null &&
                                            (profileImage == null ||
                                                (profileImage is AssetImage &&
                                                    (profileImage as AssetImage)
                                                            .assetName ==
                                                        ImagePath
                                                            .profileAvatar))
                                        ? Text(
                                          doctorProvider.getInitials(
                                            doctorName!,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            doctor.fullName ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            doctor.specialization ?? 'General Doctor',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'My Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        controller: _fullNameController,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Email required';
                          if (!val.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),

                      const SizedBox(height: 8.0),
                      CustomDatePicker(
                        initialDate: _dateOfBirth,
                        onDateChanged:
                            (date) => {
                              setState(() {
                                _dateOfBirth = date;
                              }),
                            },
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            child: LabeledDropdown(
                              label: 'Gender',
                              items: ['male', 'female'],
                              selectedValue: gender,
                              onChanged: (String? value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 8.0),
                          Expanded(
                            child: LabeledTextField(
                              label: 'Blood Group',
                              hintText: 'Enter your blood group',
                              controller: _bloodGroupController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Contact Number',
                        hintText: 'Enter your contact number',
                        controller: _contactController,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Professional Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Specialization',
                        hintText: 'Enter your specialization',
                        controller: _specializationController,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Sub Specialization',
                        hintText: 'Enter your sub specialization',
                        controller: _subSpecializationController,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Years of Experience',
                        hintText: 'Enter your years of experience',
                        controller: _yearsOfExperienceController,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Qualification',
                        hintText: 'Enter your qualification',
                        controller: _qualificationController,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Medical Registration Number',
                        hintText: 'Enter your registration number',
                        controller: _registrationNumberController,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Practice Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Practice Name',
                        hintText: 'Enter your practice name',
                        controller: _practiceNameController,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Practice Address',
                        hintText: 'Enter your practice address',
                        controller: _practiceAddressController,
                        maxline: 3,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Initial Consultation Fee (Rs)',
                        hintText: 'Enter your initial consultation fee',
                        controller: _initialConsultationFeeController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Session Types',
                        hintText: 'Enter your session types',
                        controller: _sessionTypeController,
                      ),
                      const SizedBox(height: 8.0),
                      LabeledTextField(
                        label: 'Session Duration',
                        hintText: 'Enter your session duration',
                        controller: _sessionDurationController,
                      ),
                      const SizedBox(height: 16.0),
                      PrimaryCustomButton(
                        text: 'Update Profile',
                        onPressed: () => _submitForm(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
