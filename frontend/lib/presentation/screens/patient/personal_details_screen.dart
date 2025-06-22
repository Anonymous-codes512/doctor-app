import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';

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
  late TextEditingController _preferredLanguageController;
  late TextEditingController _kinRelationController;
  late TextEditingController _kinFullNameController;
  late TextEditingController _kinContactController;
  late TextEditingController _physicalDisabilitySpecifyController;
  late TextEditingController _wheelchairSpecifyController;
  late TextEditingController _communicationSpecifyController;
  late TextEditingController _hearingSpecifyController;
  late TextEditingController _visualSpecifyController;
  late TextEditingController _environmentalFactorsController;
  late TextEditingController _otherAccessibilityController;
  late TextEditingController _insuranceProviderController;
  late TextEditingController _policyNumberController;
  late TextEditingController _insuranceClaimContactController;
  late TextEditingController _linkedHospitalsController;
  late TextEditingController _additionalHealthBenefitsController;

  late String _genderBornWith;
  late String _genderIdentifiedWith;

  num _calculateAge(dynamic dob) {
    if (dob is String) {
      final DateTime? parsedDob = DateTime.tryParse(dob);
      if (parsedDob == null) return 0; // Handle invalid date string
      dob = parsedDob;
    }
    if (dob is! DateTime) return 0; // Ensure dob is DateTime

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
      text: nameParts.isNotEmpty ? nameParts[0] : 'Not set yet',
    );
    _middleNameController = TextEditingController(
      text: nameParts.length >= 2 ? nameParts[1] : 'Not set yet',
    );
    _lastNameController = TextEditingController(
      text:
          nameParts.length >= 3
              ? nameParts.sublist(2).join(' ')
              : 'Not set yet',
    );

    _emailController = TextEditingController(text: widget.patientData.email);
    _contactNumberController = TextEditingController(
      text: widget.patientData.contact,
    );
    _addressController = TextEditingController(
      text: widget.patientData.address,
    );
    _weightController = TextEditingController(
      text: widget.patientData.weight?.toString() ?? 'Not set yet',
    );
    _heightController = TextEditingController(
      text: widget.patientData.height?.toString() ?? 'Not set yet',
    );
    _bpController = TextEditingController(
      text: widget.patientData.bloodPressure ?? 'Not set yet',
    );
    _pulseController = TextEditingController(
      text: widget.patientData.pulse ?? 'Not set yet',
    );
    _allergiesController = TextEditingController(
      text: widget.patientData.allergies ?? 'Not set yet',
    );
    _dobController = TextEditingController(
      text:
          widget.patientData.dateOfBirth != null
              ? '${_calculateAge(widget.patientData.dateOfBirth)} Years'
              : 'Not set yet',
    );

    _genderBornWith = widget.patientData.genderBornWith ?? 'Not set yet';
    _genderIdentifiedWith =
        widget.patientData.genderIdentifiedWith ?? 'Not set yet';

    _gpDetailsController = TextEditingController(
      text: widget.patientData.gpDetails ?? 'Not set yet',
    );
    _preferredLanguageController = TextEditingController(
      text: widget.patientData.preferredLanguage ?? 'Not set yet',
    );
    _kinRelationController = TextEditingController(
      text: widget.patientData.kinRelation ?? 'Not set yet',
    );
    _kinFullNameController = TextEditingController(
      text: widget.patientData.kinFullName ?? 'Not set yet',
    );
    _kinContactController = TextEditingController(
      text: widget.patientData.kinContactNumber ?? 'Not set yet',
    );

    _physicalDisabilitySpecifyController = TextEditingController(
      text:
          widget.patientData.hasPhysicalDisabilities == true
              ? (widget.patientData.physicalDisabilitySpecify ??
                  'Not specified')
              : 'N/A',
    );
    _wheelchairSpecifyController = TextEditingController(
      text:
          widget.patientData.requiresWheelchairAccess == true
              ? (widget.patientData.wheelchairSpecify ?? 'Not specified')
              : 'N/A',
    );
    _communicationSpecifyController = TextEditingController(
      text:
          widget.patientData.needsSpecialCommunication == true
              ? (widget.patientData.communicationSpecify ?? 'Not specified')
              : 'N/A',
    );
    _hearingSpecifyController = TextEditingController(
      text:
          widget.patientData.hasHearingImpairments == true
              ? (widget.patientData.hearingSpecify ?? 'Not specified')
              : 'N/A',
    );
    _visualSpecifyController = TextEditingController(
      text:
          widget.patientData.hasVisualImpairments == true
              ? (widget.patientData.visualSpecify ?? 'Not specified')
              : 'N/A',
    );
    _environmentalFactorsController = TextEditingController(
      text: widget.patientData.environmentalFactors ?? 'Not set yet',
    );
    _otherAccessibilityController = TextEditingController(
      text: widget.patientData.otherAccessibilityNeeds ?? 'Not set yet',
    );

    _insuranceProviderController = TextEditingController(
      text:
          widget.patientData.hasHealthInsurance == true
              ? (widget.patientData.insuranceProvider ?? 'Not set yet')
              : 'N/A',
    );
    _policyNumberController = TextEditingController(
      text:
          widget.patientData.hasHealthInsurance == true
              ? (widget.patientData.policyNumber ?? 'Not set yet')
              : 'N/A',
    );
    _insuranceClaimContactController = TextEditingController(
      text:
          widget.patientData.hasHealthInsurance == true
              ? (widget.patientData.insuranceClaimContact ?? 'Not set yet')
              : 'N/A',
    );
    _linkedHospitalsController = TextEditingController(
      text:
          widget.patientData.hasHealthInsurance == true
              ? (widget.patientData.linkedHospitals ?? 'Not set yet')
              : 'N/A',
    );
    _additionalHealthBenefitsController = TextEditingController(
      text:
          widget.patientData.hasHealthInsurance == true
              ? (widget.patientData.additionalHealthBenefits ?? 'Not set yet')
              : 'N/A',
    );
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Section
            _buildField('First Name', _firstNameController),
            _buildField('Middle Name', _middleNameController),
            _buildField('Last Name', _lastNameController),
            _buildField('Date of Birth', _dobController),
            _buildField(
              'Gender (Born With)',
              TextEditingController(text: _genderBornWith),
            ),
            _buildField(
              'Gender (Identified With)',
              TextEditingController(text: _genderIdentifiedWith),
            ),
            _buildField('Email', _emailController),
            _buildField('Contact Number', _contactNumberController),
            _buildField('Address', _addressController, maxLines: 3),
            _buildField('GP Details', _gpDetailsController, maxLines: 3),
            _buildField('Preferred Language', _preferredLanguageController),
            _buildField(
              'Emergency Contact (Next of Kin) - Relation',
              _kinRelationController,
            ),
            _buildField(
              'Emergency Contact (Next of Kin) - Full Name',
              _kinFullNameController,
            ),
            _buildField(
              'Emergency Contact (Next of Kin) - Contact Number',
              _kinContactController,
            ),
            _buildField('Weight', _weightController),
            _buildField('Height', _heightController),
            _buildField('Blood Pressure', _bpController),
            _buildField('Pulse', _pulseController),
            _buildField('Allergies', _allergiesController),

            const SizedBox(height: 24),
            const Divider(), // Separator
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

            _buildField(
              'Physical Disabilities or Mobility Challenges?',
              TextEditingController(
                text:
                    widget.patientData.hasPhysicalDisabilities == true
                        ? 'Yes'
                        : 'No',
              ),
            ),
            if (widget.patientData.hasPhysicalDisabilities == true)
              _buildField(
                'If yes, specify',
                _physicalDisabilitySpecifyController,
                maxLines: 2,
              ),

            _buildField(
              'Requires Wheelchair Access?',
              TextEditingController(
                text:
                    widget.patientData.requiresWheelchairAccess == true
                        ? 'Yes'
                        : 'No',
              ),
            ),
            if (widget.patientData.requiresWheelchairAccess == true)
              _buildField(
                'If yes, specify',
                _wheelchairSpecifyController,
                maxLines: 2,
              ),

            _buildField(
              'Needs Special Communication Assistance?',
              TextEditingController(
                text:
                    widget.patientData.needsSpecialCommunication == true
                        ? 'Yes'
                        : 'No',
              ),
            ),
            if (widget.patientData.needsSpecialCommunication == true)
              _buildField(
                'If yes, specify',
                _communicationSpecifyController,
                maxLines: 2,
              ),

            _buildField(
              'Has Hearing Impairments?',
              TextEditingController(
                text:
                    widget.patientData.hasHearingImpairments == true
                        ? 'Yes'
                        : 'No',
              ),
            ),
            if (widget.patientData.hasHearingImpairments == true)
              _buildField(
                'If yes, specify',
                _hearingSpecifyController,
                maxLines: 2,
              ),

            _buildField(
              'Has Visual Impairments?',
              TextEditingController(
                text:
                    widget.patientData.hasVisualImpairments == true
                        ? 'Yes'
                        : 'No',
              ),
            ),
            if (widget.patientData.hasVisualImpairments == true)
              _buildField(
                'If yes, specify',
                _visualSpecifyController,
                maxLines: 2,
              ),

            _buildField(
              'Environmental Factors Affecting Health',
              _environmentalFactorsController,
              maxLines: 3,
            ),
            _buildField(
              'Other Accessibility Needs',
              _otherAccessibilityController,
              maxLines: 3,
            ),

            const SizedBox(height: 24),
            const Divider(), // Separator
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

            _buildField(
              'Has Health Insurance?',
              TextEditingController(
                text:
                    widget.patientData.hasHealthInsurance == true
                        ? 'Yes'
                        : 'No',
              ),
            ),
            if (widget.patientData.hasHealthInsurance == true) ...[
              _buildField(
                'Insurance Provider Name',
                _insuranceProviderController,
              ),
              _buildField('Policy Number', _policyNumberController),
              _buildField(
                'Insurance Claim Contact',
                _insuranceClaimContactController,
                maxLines: 2,
              ),
              _buildField(
                'Linked Hospitals/Clinics',
                _linkedHospitalsController,
                maxLines: 3,
              ),
              _buildField(
                'Additional Health Benefits',
                _additionalHealthBenefitsController,
                maxLines: 3,
              ),
            ],

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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: LabeledTextField(
        label: label,
        controller: controller,
        readOnly: true,
        maxline: maxLines,
        // The hintText here will only show if the controller's text is empty.
        // Given that we are populating with 'Not set yet', this might not be needed.
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
    _preferredLanguageController.dispose();
    _kinRelationController.dispose();
    _kinFullNameController.dispose();
    _kinContactController.dispose();
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
