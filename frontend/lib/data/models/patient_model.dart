import 'package:doctor_app/data/models/notes_model.dart';

class Patient {
  final int? id;
  int? doctorUserId;
  final String fullName;
  final String contact;
  final String email;
  final String address;
  final String? weight;
  final String? height;
  final String? gender;
  final String? bloodPressure;
  final String? pulse;
  final String? allergies;
  final String dateOfBirth;
  final String? imagePath;

  // New Fields: Basic Information
  final String? genderBornWith;
  final String? genderIdentifiedWith;
  final String? gpDetails;
  final String? preferredLanguage;
  final String? kinRelation;
  final String? kinFullName;
  final String? kinContactNumber;

  // New Fields: Accessibility Requirements
  final bool? hasPhysicalDisabilities;
  final String? physicalDisabilitySpecify;
  final bool? requiresWheelchairAccess;
  final String? wheelchairSpecify;
  final bool? needsSpecialCommunication;
  final String? communicationSpecify;
  final bool? hasHearingImpairments;
  final String? hearingSpecify;
  final bool? hasVisualImpairments;
  final String? visualSpecify;
  final String? environmentalFactors;
  final String? otherAccessibilityNeeds;

  // New Fields: Insurance Details
  final bool? hasHealthInsurance;
  final String? insuranceProvider;
  final String? policyNumber;
  final String? insuranceClaimContact;
  final String? linkedHospitals;
  final String? additionalHealthBenefits;

  // Notes
  final List<Note>? notes;

  Patient({
    this.id,
    this.doctorUserId,
    required this.fullName,
    required this.contact,
    required this.email,
    required this.address,
    this.weight,
    this.height,
    this.gender,
    this.bloodPressure,
    this.pulse,
    this.allergies,
    required this.dateOfBirth,
    this.imagePath,
    this.genderBornWith,
    this.genderIdentifiedWith,
    this.gpDetails,
    this.preferredLanguage,
    this.kinRelation,
    this.kinFullName,
    this.kinContactNumber,
    this.hasPhysicalDisabilities,
    this.physicalDisabilitySpecify,
    this.requiresWheelchairAccess,
    this.wheelchairSpecify,
    this.needsSpecialCommunication,
    this.communicationSpecify,
    this.hasHearingImpairments,
    this.hearingSpecify,
    this.hasVisualImpairments,
    this.visualSpecify,
    this.environmentalFactors,
    this.otherAccessibilityNeeds,
    this.hasHealthInsurance,
    this.insuranceProvider,
    this.policyNumber,
    this.insuranceClaimContact,
    this.linkedHospitals,
    this.additionalHealthBenefits,
    this.notes,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      doctorUserId: json['doctorUserId'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      contact: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      imagePath: json['imagePath'],
      weight: json['weight']?.toString(),
      height: json['height']?.toString(),
      bloodPressure: json['bloodPressure'] ?? '',
      pulse: json['pulse'] ?? '',
      allergies: json['allergies'] ?? '',
      genderBornWith: json['genderBornWith'],
      genderIdentifiedWith: json['genderIdentifiedWith'],
      gpDetails: json['gpDetails'],
      preferredLanguage: json['preferredLanguage'],
      kinRelation: json['kinRelation'],
      kinFullName: json['kinFullName'],
      kinContactNumber: json['kinContactNumber'],
      hasPhysicalDisabilities: json['hasPhysicalDisabilities'],
      physicalDisabilitySpecify: json['physicalDisabilitySpecify'],
      requiresWheelchairAccess: json['requiresWheelchairAccess'],
      wheelchairSpecify: json['wheelchairSpecify'],
      needsSpecialCommunication: json['needsSpecialCommunication'],
      communicationSpecify: json['communicationSpecify'],
      hasHearingImpairments: json['hasHearingImpairments'],
      hearingSpecify: json['hearingSpecify'],
      hasVisualImpairments: json['hasVisualImpairments'],
      visualSpecify: json['visualSpecify'],
      environmentalFactors: json['environmentalFactors'],
      otherAccessibilityNeeds: json['otherAccessibilityNeeds'],
      hasHealthInsurance: json['hasHealthInsurance'],
      insuranceProvider: json['insuranceProvider'],
      policyNumber: json['policyNumber'],
      insuranceClaimContact: json['insuranceClaimContact'],
      linkedHospitals: json['linkedHospitals'],
      additionalHealthBenefits: json['additionalHealthBenefits'],
      notes:
          json['notes'] != null
              ? List<Note>.from(
                json['notes'].map((note) => Note.fromJson(note)),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'doctorUserId': doctorUserId,
    'fullName': fullName,
    'contact': contact,
    'email': email,
    'address': address,
    'weight': weight,
    'height': height,
    'bloodPressure': bloodPressure,
    'pulse': pulse,
    'allergies': allergies,
    'dateOfBirth': dateOfBirth,
    'imagePath': imagePath,
    'genderBornWith': genderBornWith,
    'genderIdentifiedWith': genderIdentifiedWith,
    'gpDetails': gpDetails,
    'preferredLanguage': preferredLanguage,
    'kinRelation': kinRelation,
    'kinFullName': kinFullName,
    'kinContactNumber': kinContactNumber,
    'hasPhysicalDisabilities': hasPhysicalDisabilities,
    'physicalDisabilitySpecify': physicalDisabilitySpecify,
    'requiresWheelchairAccess': requiresWheelchairAccess,
    'wheelchairSpecify': wheelchairSpecify,
    'needsSpecialCommunication': needsSpecialCommunication,
    'communicationSpecify': communicationSpecify,
    'hasHearingImpairments': hasHearingImpairments,
    'hearingSpecify': hearingSpecify,
    'hasVisualImpairments': hasVisualImpairments,
    'visualSpecify': visualSpecify,
    'environmentalFactors': environmentalFactors,
    'otherAccessibilityNeeds': otherAccessibilityNeeds,
    'hasHealthInsurance': hasHealthInsurance,
    'insuranceProvider': insuranceProvider,
    'policyNumber': policyNumber,
    'insuranceClaimContact': insuranceClaimContact,
    'linkedHospitals': linkedHospitals,
    'additionalHealthBenefits': additionalHealthBenefits,
    'notes': notes?.map((note) => note.toJson()).toList(),
  };

  @override
  String toString() {
    return 'Patient(fullName: $fullName, contact: $contact, email: $email, address: $address, '
        'weight: $weight, height: $height, bloodPressure: $bloodPressure, pulse: $pulse, '
        'allergies: $allergies, dateOfBirth: $dateOfBirth, imagePath: $imagePath, '
        'genderBornWith: $genderBornWith, genderIdentifiedWith: $genderIdentifiedWith, '
        'gpDetails: $gpDetails, preferredLanguage: $preferredLanguage, '
        'kinRelation: $kinRelation, kinFullName: $kinFullName, kinContactNumber: $kinContactNumber, '
        'hasPhysicalDisabilities: $hasPhysicalDisabilities, physicalDisabilitySpecify: $physicalDisabilitySpecify, '
        'requiresWheelchairAccess: $requiresWheelchairAccess, wheelchairSpecify: $wheelchairSpecify, '
        'needsSpecialCommunication: $needsSpecialCommunication, communicationSpecify: $communicationSpecify, '
        'hasHearingImpairments: $hasHearingImpairments, hearingSpecify: $hearingSpecify, '
        'hasVisualImpairments: $hasVisualImpairments, visualSpecify: $visualSpecify, '
        'environmentalFactors: $environmentalFactors, otherAccessibilityNeeds: $otherAccessibilityNeeds, '
        'hasHealthInsurance: $hasHealthInsurance, insuranceProvider: $insuranceProvider, '
        'policyNumber: $policyNumber, insuranceClaimContact: $insuranceClaimContact, '
        'linkedHospitals: $linkedHospitals, additionalHealthBenefits: $additionalHealthBenefits, '
        'notes: $notes)';
  }
}
