import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/custom_date_picker.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:flutter/material.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> patientData;
  const PersonalDetailsScreen({super.key, required this.patientData});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  // Existing controllers
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _gpDetailsController = TextEditingController();
  TextEditingController _preferedLanguageController = TextEditingController();
  TextEditingController _kinRelationController = TextEditingController();
  TextEditingController _kinFullNameController = TextEditingController();
  TextEditingController _kinContactController = TextEditingController();

  // New controllers for missing fields
  TextEditingController _physicalDisabilitySpecifyController =
      TextEditingController();
  TextEditingController _wheelchairSpecifyController = TextEditingController();
  TextEditingController _communicationSpecifyController =
      TextEditingController();
  TextEditingController _hearingSpecifyController = TextEditingController();
  TextEditingController _visualSpecifyController = TextEditingController();
  TextEditingController _environmentalFactorsController =
      TextEditingController();
  TextEditingController _otherAccessibilityController = TextEditingController();
  TextEditingController _insuranceProviderController = TextEditingController();
  TextEditingController _policyNumberController = TextEditingController();
  TextEditingController _insuranceClaimContactController =
      TextEditingController();
  TextEditingController _linkedHospitalsController = TextEditingController();
  TextEditingController _additionalHealthBenefitsController =
      TextEditingController();

  DateTime? initialDate = DateTime(2000, 1, 1);

  // Gender selection
  String? genderBornWith;
  String? genderIdentifiedWith;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  // Accessibility toggles
  bool hasPhysicalDisabilities = false;
  bool requiresWheelchairAccess = false;
  bool needsSpecialCommunication = false;
  bool hasHearingImpairments = false;
  bool hasVisualImpairments = false;

  // Insurance toggles
  bool hasHealthInsurance = false;

  void onGenderBornWithChanged(String? value) {
    setState(() {
      genderBornWith = value;
    });
  }

  void onGenderIdentifiedWithChanged(String? value) {
    setState(() {
      genderIdentifiedWith = value;
    });
  }

  void onDateChanged(DateTime date) {
    setState(() {
      initialDate = date;
    });
  }

  @override
  void initState() {
    super.initState();

    // Split name logic
    final fullName = (widget.patientData['name'] ?? '').toString().trim();
    final nameParts = fullName.split(' ');

    if (nameParts.length >= 3) {
      _firstNameController.text = nameParts[0];
      _middleNameController.text = nameParts[1];
      _lastNameController.text = nameParts
          .sublist(2)
          .join(' '); // handles >3 parts
    } else if (nameParts.length == 2) {
      _firstNameController.text = nameParts[0];
      _middleNameController.text = 'Middle name here...';
      _lastNameController.text = nameParts[1];
    } else if (nameParts.length == 1 && nameParts[0].isNotEmpty) {
      _firstNameController.text = nameParts[0];
      _middleNameController.text = 'Middle name here...';
      _lastNameController.text = 'Last name here...';
    } else {
      _firstNameController.text = 'First name here...';
      _middleNameController.text = 'Middle name here...';
      _lastNameController.text = 'Last name here...';
    }

    // DOB from age
    final int? age = int.tryParse(widget.patientData['age']?.toString() ?? '');
    if (age != null && age > 0) {
      final now = DateTime.now();
      initialDate = DateTime(now.year - age, now.month, now.day);
    } else {
      initialDate = DateTime(2000, 1, 1); // fallback
    }

    // Other fields with hint fallback
    genderBornWith = widget.patientData['gender_born_with'];
    genderIdentifiedWith = widget.patientData['gender_identified_with'];

    _emailController.text = widget.patientData['email'] ?? 'Email here...';
    _contactNumberController.text =
        widget.patientData['phone'] ?? 'Contact number here...';
    _addressController.text =
        widget.patientData['address'] ?? 'Address here...';
    _gpDetailsController.text =
        widget.patientData['gp_details'] ?? 'GP details here...';
    _preferedLanguageController.text =
        widget.patientData['preferred_language'] ??
        'Preferred language here...';
    _kinRelationController.text =
        widget.patientData['kin_relation'] ?? 'Relation here...';
    _kinFullNameController.text =
        widget.patientData['kin_full_name'] ?? 'Full name here...';
    _kinContactController.text =
        widget.patientData['kin_contact_number'] ?? 'Contact number here...';

    hasPhysicalDisabilities =
        (widget.patientData['has_physical_disabilities'] ?? false) == true;
    hasHearingImpairments =
        (widget.patientData['has_hearing_impairments'] ?? false) == true;
    hasVisualImpairments =
        (widget.patientData['has_visual_impairments'] ?? false) == true;
    requiresWheelchairAccess =
        (widget.patientData['requires_wheelchair_access'] ?? false) == true;
    needsSpecialCommunication =
        (widget.patientData['needs_special_communication'] ?? false) == true;

    _physicalDisabilitySpecifyController.text =
        widget.patientData['physical_disability_specify'] ??
        'Please specify...';
    _wheelchairSpecifyController.text =
        widget.patientData['wheelchair_specify'] ?? 'Please specify...';
    _communicationSpecifyController.text =
        widget.patientData['communication_specify'] ?? 'Please specify...';
    _hearingSpecifyController.text =
        widget.patientData['hearing_specify'] ?? 'Please specify...';
    _visualSpecifyController.text =
        widget.patientData['visual_specify'] ?? 'Please specify...';
    _environmentalFactorsController.text =
        widget.patientData['environmental_factors'] ?? 'Please describe...';
    _otherAccessibilityController.text =
        widget.patientData['other_accessibility_needs'] ?? 'Please describe...';

    hasHealthInsurance =
        (widget.patientData['has_health_insurance'] ?? false) == true;

    _insuranceProviderController.text =
        widget.patientData['insurance_provider'] ?? 'Provider name...';
    _policyNumberController.text =
        widget.patientData['policy_number'] ?? 'Policy number...';
    _insuranceClaimContactController.text =
        widget.patientData['insurance_claim_contact'] ?? 'Contact details...';
    _linkedHospitalsController.text =
        widget.patientData['linked_hospitals'] ?? 'Hospital/clinic names...';
    _additionalHealthBenefitsController.text =
        widget.patientData['additional_health_benefits'] ??
        'Benefits details...';
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
        centerTitle: true,
        title: const Text(
          'Personal Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Basic Information Section
              LabeledTextField(
                label: 'First Name',
                hintText: 'First name here...',
                controller: _firstNameController,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Middle Name',
                hintText: 'Middle name here...',
                controller: _middleNameController,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Last Name',
                hintText: 'Last name here...',
                controller: _lastNameController,
              ),

              const SizedBox(height: 12),

              CustomDatePicker(
                label: 'Date of Birth',
                initialDate: initialDate!,
                onDateChanged: onDateChanged,
              ),

              const SizedBox(height: 12),

              GenderRadioGroup(
                label: 'Gender (Born With)',
                groupValue: genderBornWith,
                options: genderOptions,
                onChanged: onGenderBornWithChanged,
              ),

              const SizedBox(height: 12),

              GenderRadioGroup(
                label: 'Gender (Identified With)',
                groupValue: genderIdentifiedWith,
                options: genderOptions,
                onChanged: onGenderIdentifiedWithChanged,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Email',
                hintText: 'Email here...',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Contact Number',
                hintText: 'Contact number here...',
                controller: _contactNumberController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Address',
                hintText: 'Address here...',
                maxline: 3,
                controller: _addressController,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'GP Details',
                hintText: 'GP details here...',
                maxline: 3,
                controller: _gpDetailsController,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Preferred Language',
                hintText: 'Preferred language here...',
                controller: _preferedLanguageController,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Emergency Contact (Next of Kin)',
                hintText: 'Relation here...',
                controller: _kinRelationController,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Full Name (Next of Kin)',
                hintText: 'Full name here...',
                controller: _kinFullNameController,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Contact Number (Next of Kin)',
                hintText: 'Contact number here...',
                controller: _kinContactController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),

              // Accessibility Requirements Section
              const Text(
                'Accessibility Requirements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              ToggleSwitchWidget(
                label:
                    'Do you have any physical disabilities or mobility challenges?',
                value: hasPhysicalDisabilities,
                onChanged: (value) {
                  setState(() {
                    hasPhysicalDisabilities = value;
                    if (!value) {
                      _physicalDisabilitySpecifyController.clear();
                    }
                  });
                },
              ),

              if (hasPhysicalDisabilities) ...[
                const SizedBox(height: 12),
                LabeledTextField(
                  label: 'If yes, specify',
                  hintText: 'Please specify...',
                  controller: _physicalDisabilitySpecifyController,
                  maxline: 2,
                ),
              ],

              const SizedBox(height: 12),

              ToggleSwitchWidget(
                label: 'Do you require wheelchair access?',
                value: requiresWheelchairAccess,
                onChanged: (value) {
                  setState(() {
                    requiresWheelchairAccess = value;
                    if (!value) {
                      _wheelchairSpecifyController.clear();
                    }
                  });
                },
              ),

              if (requiresWheelchairAccess) ...[
                const SizedBox(height: 12),
                LabeledTextField(
                  label: 'If yes, specify',
                  hintText: 'Please specify...',
                  controller: _wheelchairSpecifyController,
                  maxline: 2,
                ),
              ],

              const SizedBox(height: 12),

              ToggleSwitchWidget(
                label: 'Do you need special communication assistance?',
                value: needsSpecialCommunication,
                onChanged: (value) {
                  setState(() {
                    needsSpecialCommunication = value;
                    if (!value) {
                      _communicationSpecifyController.clear();
                    }
                  });
                },
              ),

              if (needsSpecialCommunication) ...[
                const SizedBox(height: 12),
                LabeledTextField(
                  label: 'If yes, specify',
                  hintText: 'Please specify...',
                  controller: _communicationSpecifyController,
                  maxline: 2,
                ),
              ],

              const SizedBox(height: 12),

              ToggleSwitchWidget(
                label: 'Do you have any hearing impairments?',
                value: hasHearingImpairments,
                onChanged: (value) {
                  setState(() {
                    hasHearingImpairments = value;
                    if (!value) {
                      _hearingSpecifyController.clear();
                    }
                  });
                },
              ),

              if (hasHearingImpairments) ...[
                const SizedBox(height: 12),
                LabeledTextField(
                  label: 'If yes, specify',
                  hintText: 'Please specify...',
                  controller: _hearingSpecifyController,
                  maxline: 2,
                ),
              ],

              const SizedBox(height: 12),

              ToggleSwitchWidget(
                label: 'Do you have any visual impairments?',
                value: hasVisualImpairments,
                onChanged: (value) {
                  setState(() {
                    hasVisualImpairments = value;
                    if (!value) {
                      _visualSpecifyController.clear();
                    }
                  });
                },
              ),

              if (hasVisualImpairments) ...[
                const SizedBox(height: 12),
                LabeledTextField(
                  label: 'If yes, specify',
                  hintText: 'Please specify...',
                  controller: _visualSpecifyController,
                  maxline: 2,
                ),
              ],

              const SizedBox(height: 12),

              LabeledTextField(
                label:
                    'Are there any environmental factors affecting your health?',
                hintText: 'Please describe...',
                controller: _environmentalFactorsController,
                maxline: 3,
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Any other accessibility needs?',
                hintText: 'Please describe...',
                controller: _otherAccessibilityController,
                maxline: 3,
              ),

              const SizedBox(height: 24),

              // Insurance Details Section
              const Text(
                'Insurance Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              ToggleSwitchWidget(
                label: 'Do you have health insurance?',
                value: hasHealthInsurance,
                onChanged: (value) {
                  setState(() {
                    hasHealthInsurance = value;
                    if (!value) {
                      _insuranceProviderController.clear();
                      _policyNumberController.clear();
                      _insuranceClaimContactController.clear();
                      _linkedHospitalsController.clear();
                      _additionalHealthBenefitsController.clear();
                    }
                  });
                },
              ),

              if (hasHealthInsurance) ...[
                const SizedBox(height: 12),
                LabeledTextField(
                  label: 'Insurance provider name:',
                  hintText: 'Provider name...',
                  controller: _insuranceProviderController,
                ),

                const SizedBox(height: 12),

                LabeledTextField(
                  label: 'Policy Number:',
                  hintText: 'Policy number...',
                  controller: _policyNumberController,
                ),

                const SizedBox(height: 12),

                LabeledTextField(
                  label: 'Insurance Claim Contact:',
                  hintText: 'Contact details...',
                  controller: _insuranceClaimContactController,
                  maxline: 2,
                ),

                const SizedBox(height: 12),

                LabeledTextField(
                  label: 'Linked Hospitals/Clinics:',
                  hintText: 'Hospital/clinic names...',
                  controller: _linkedHospitalsController,
                  maxline: 3,
                ),

                const SizedBox(height: 12),

                LabeledTextField(
                  label: 'Additional health benefits:',
                  hintText: 'Benefits details...',
                  controller: _additionalHealthBenefitsController,
                  maxline: 3,
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose existing controllers
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    _gpDetailsController.dispose();
    _preferedLanguageController.dispose();
    _kinRelationController.dispose();
    _kinFullNameController.dispose();
    _kinContactController.dispose();

    // Dispose new controllers
    _physicalDisabilitySpecifyController.dispose();
    _wheelchairSpecifyController.dispose();
    _communicationSpecifyController.dispose();
    _hearingSpecifyController.dispose();
    _visualSpecifyController.dispose();
    _environmentalFactorsController.dispose();
    _otherAccessibilityController.dispose();
    _insuranceProviderController.dispose();
    _policyNumberController.dispose();
    _insuranceClaimContactController.dispose();
    _linkedHospitalsController.dispose();
    _additionalHealthBenefitsController.dispose();

    super.dispose();
  }
}
