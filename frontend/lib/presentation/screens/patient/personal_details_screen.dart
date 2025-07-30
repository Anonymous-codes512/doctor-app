// Updated PersonalDetailsScreen (Editable with Dropdowns)
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:provider/provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final Patient patientData;
  const PersonalDetailsScreen({super.key, required this.patientData});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _contactNumberController;
  late TextEditingController _addressController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _bpController;
  late TextEditingController _pulseController;
  late TextEditingController _allergiesController;
  late TextEditingController _dobController;
  late TextEditingController _gpDetailsController;
  late TextEditingController _kinRelationController;
  late TextEditingController _kinFullNameController;
  late TextEditingController _kinContactController;
  late TextEditingController _environmentalFactorsController;
  late TextEditingController _otherAccessibilityController;
  late TextEditingController _insuranceProviderController;
  late TextEditingController _policyNumberController;
  late TextEditingController _insuranceClaimContactController;
  late TextEditingController _linkedHospitalsController;
  late TextEditingController _additionalHealthBenefitsController;

  String? _genderBornWith;
  String? _genderIdentifiedWith;
  String? _preferredLanguage;
  String? _hasPhysicalDisability;
  String? _requiresWheelchair;
  String? _needsCommunication;
  String? _hasHearing;
  String? _hasVisual;
  String? _hasInsurance;

  final genderOptions = ['male', 'female', 'other'];
  final languageOptions = ['English', 'Urdu', 'Punjabi', 'Other'];
  final yesNoOptions = ['Yes', 'No'];

  num _calculateAge(dynamic dob) {
    if (dob is String) {
      final DateTime? parsedDob = DateTime.tryParse(dob);
      if (parsedDob == null) return 0;
      dob = parsedDob;
    }
    if (dob is! DateTime) return 0;

    final today = DateTime.now();
    num age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  @override
  void initState() {
    super.initState();
    final nameParts = widget.patientData.fullName.trim().split(' ');
    _firstNameController = TextEditingController(
      text: nameParts.isNotEmpty ? nameParts[0] : '',
    );
    _middleNameController = TextEditingController(
      text: nameParts.length >= 2 ? nameParts[1] : '',
    );
    _lastNameController = TextEditingController(
      text: nameParts.length >= 3 ? nameParts.sublist(2).join(' ') : '',
    );
    _emailController = TextEditingController(text: widget.patientData.email);
    _contactNumberController = TextEditingController(
      text: widget.patientData.contact,
    );
    _addressController = TextEditingController(
      text: widget.patientData.address,
    );
    _weightController = TextEditingController(
      text: widget.patientData.weight?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: widget.patientData.height?.toString() ?? '',
    );
    _bpController = TextEditingController(
      text: widget.patientData.bloodPressure ?? '',
    );
    _pulseController = TextEditingController(
      text: widget.patientData.pulse ?? '',
    );
    _allergiesController = TextEditingController(
      text: widget.patientData.allergies ?? '',
    );
    _dobController = TextEditingController(
      text:
          widget.patientData.dateOfBirth != null
              ? '${_calculateAge(widget.patientData.dateOfBirth)} Years'
              : '',
    );

    _genderBornWith = widget.patientData.genderBornWith;
    _genderIdentifiedWith = widget.patientData.genderIdentifiedWith;
    _preferredLanguage = widget.patientData.preferredLanguage;

    _gpDetailsController = TextEditingController(
      text: widget.patientData.gpDetails ?? '',
    );
    _kinRelationController = TextEditingController(
      text: widget.patientData.kinRelation ?? '',
    );
    _kinFullNameController = TextEditingController(
      text: widget.patientData.kinFullName ?? '',
    );
    _kinContactController = TextEditingController(
      text: widget.patientData.kinContactNumber ?? '',
    );

    _hasPhysicalDisability =
        widget.patientData.hasPhysicalDisabilities == true ? 'Yes' : 'No';
    _requiresWheelchair =
        widget.patientData.requiresWheelchairAccess == true ? 'Yes' : 'No';
    _needsCommunication =
        widget.patientData.needsSpecialCommunication == true ? 'Yes' : 'No';
    _hasHearing =
        widget.patientData.hasHearingImpairments == true ? 'Yes' : 'No';
    _hasVisual = widget.patientData.hasVisualImpairments == true ? 'Yes' : 'No';
    _hasInsurance =
        widget.patientData.hasHealthInsurance == true ? 'Yes' : 'No';

    _environmentalFactorsController = TextEditingController(
      text: widget.patientData.environmentalFactors ?? '',
    );
    _otherAccessibilityController = TextEditingController(
      text: widget.patientData.otherAccessibilityNeeds ?? '',
    );
    _insuranceProviderController = TextEditingController(
      text: widget.patientData.insuranceProvider ?? '',
    );
    _policyNumberController = TextEditingController(
      text: widget.patientData.policyNumber ?? '',
    );
    _insuranceClaimContactController = TextEditingController(
      text: widget.patientData.insuranceClaimContact ?? '',
    );
    _linkedHospitalsController = TextEditingController(
      text: widget.patientData.linkedHospitals ?? '',
    );
    _additionalHealthBenefitsController = TextEditingController(
      text: widget.patientData.additionalHealthBenefits ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Personal Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('First Name', _firstNameController),
            _buildField('Middle Name', _middleNameController),
            _buildField('Last Name', _lastNameController),
            _buildField('Date of Birth', _dobController, readOnly: true),

            LabeledDropdown(
              label: 'Gender (Born With)',
              hintText: 'Select Gender',
              selectedValue: _genderBornWith,
              items: genderOptions,
              onChanged: (val) => setState(() => _genderBornWith = val),
            ),
            LabeledDropdown(
              label: 'Gender (Identified With)',
              hintText: 'Select Gender',
              selectedValue: _genderIdentifiedWith,
              items: genderOptions,
              onChanged: (val) => setState(() => _genderIdentifiedWith = val),
            ),

            _buildField('Email', _emailController),
            _buildField('Contact Number', _contactNumberController),
            _buildField('Address', _addressController, maxLines: 3),
            _buildField('GP Details', _gpDetailsController, maxLines: 3),

            LabeledDropdown(
              label: 'Preferred Language',
              hintText: 'Select Language',
              selectedValue: _preferredLanguage,
              items: languageOptions,
              onChanged: (val) => setState(() => _preferredLanguage = val),
            ),
            const SizedBox(height: 16),
            _buildField('Next of Kin - Relation', _kinRelationController),
            _buildField('Next of Kin - Full Name', _kinFullNameController),
            _buildField('Next of Kin - Contact Number', _kinContactController),

            _buildField('Weight', _weightController),
            _buildField('Height', _heightController),
            _buildField('Blood Pressure', _bpController),
            _buildField('Pulse', _pulseController),
            _buildField('Allergies', _allergiesController),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            const Text(
              'Accessibility Requirements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            LabeledDropdown(
              label: 'Physical Disabilities?',
              selectedValue: _hasPhysicalDisability,
              items: yesNoOptions,
              onChanged: (val) => setState(() => _hasPhysicalDisability = val),
            ),
            LabeledDropdown(
              label: 'Requires Wheelchair Access?',
              selectedValue: _requiresWheelchair,
              items: yesNoOptions,
              onChanged: (val) => setState(() => _requiresWheelchair = val),
            ),
            LabeledDropdown(
              label: 'Needs Special Communication?',
              selectedValue: _needsCommunication,
              items: yesNoOptions,
              onChanged: (val) => setState(() => _needsCommunication = val),
            ),
            LabeledDropdown(
              label: 'Hearing Impairment?',
              selectedValue: _hasHearing,
              items: yesNoOptions,
              onChanged: (val) => setState(() => _hasHearing = val),
            ),
            LabeledDropdown(
              label: 'Visual Impairment?',
              selectedValue: _hasVisual,
              items: yesNoOptions,
              onChanged: (val) => setState(() => _hasVisual = val),
            ),
            _buildField(
              'Environmental Factors',
              _environmentalFactorsController,
              maxLines: 3,
            ),
            _buildField(
              'Other Accessibility Needs',
              _otherAccessibilityController,
              maxLines: 3,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            const Text(
              'Insurance Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            LabeledDropdown(
              label: 'Has Health Insurance?',
              selectedValue: _hasInsurance,
              items: yesNoOptions,
              onChanged: (val) => setState(() => _hasInsurance = val),
            ),

            if (_hasInsurance == 'Yes') ...[
              _buildField('Insurance Provider', _insuranceProviderController),
              _buildField('Policy Number', _policyNumberController),
              _buildField(
                'Insurance Claim Contact',
                _insuranceClaimContactController,
              ),
              _buildField(
                'Linked Hospitals',
                _linkedHospitalsController,
                maxLines: 2,
              ),
              _buildField(
                'Additional Health Benefits',
                _additionalHealthBenefitsController,
                maxLines: 3,
              ),
            ],

            const SizedBox(height: 16),
            PrimaryCustomButton(
              text: 'Update',
              onPressed: () async {
                final provider = Provider.of<PatientProvider>(
                  context,
                  listen: false,
                );

                await provider.updatePatientFields(
                  context,
                  patientId: widget.patientData.id!,
                  updatedFields: {
                    'contact': _contactNumberController.text.trim(),
                    'address': _addressController.text.trim(),
                    'weight': _weightController.text.trim(),
                    'height': _heightController.text.trim(),
                    'blood_pressure': _bpController.text.trim(),
                    'pulse': _pulseController.text.trim(),
                    'allergies': _allergiesController.text.trim(),
                    'gender_born_with': _genderBornWith,
                    'gender_identified_with': _genderIdentifiedWith,
                    'preferred_language': _preferredLanguage,
                    'gp_details': _gpDetailsController.text.trim(),
                    'kin_relation': _kinRelationController.text.trim(),
                    'kin_full_name': _kinFullNameController.text.trim(),
                    'kin_contact_number': _kinContactController.text.trim(),
                    'has_physical_disabilities':
                        _hasPhysicalDisability == 'Yes',
                    'requires_wheelchair_access': _requiresWheelchair == 'Yes',
                    'needs_special_communication': _needsCommunication == 'Yes',
                    'has_hearing_impairments': _hasHearing == 'Yes',
                    'has_visual_impairments': _hasVisual == 'Yes',
                    'environmental_factors':
                        _environmentalFactorsController.text.trim(),
                    'other_accessibility_needs':
                        _otherAccessibilityController.text.trim(),
                    'has_health_insurance': _hasInsurance == 'Yes',
                    if (_hasInsurance == 'Yes') ...{
                      'insurance_provider':
                          _insuranceProviderController.text.trim(),
                      'policy_number': _policyNumberController.text.trim(),
                      'insurance_claim_contact':
                          _insuranceClaimContactController.text.trim(),
                      'linked_hospitals':
                          _linkedHospitalsController.text.trim(),
                      'additional_health_benefits':
                          _additionalHealthBenefitsController.text.trim(),
                    },
                  },
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: LabeledTextField(
        label: label,
        controller: controller,
        readOnly: readOnly,
        maxline: maxLines,
        hintText: '',
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bpController.dispose();
    _pulseController.dispose();
    _allergiesController.dispose();
    _dobController.dispose();
    _gpDetailsController.dispose();
    _kinRelationController.dispose();
    _kinFullNameController.dispose();
    _kinContactController.dispose();
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
