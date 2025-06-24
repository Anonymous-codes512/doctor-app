import 'package:doctor_app/data/models/notes_model.dart';

class Patient {
  int? id;
  int? doctorUserId;

  String fullName;
  String? email;
  String? contact;
  String? address;
  String? dateOfBirth;
  String? genderBornWith;
  String? genderIdentifiedWith;

  String? weight;
  String? height;
  String? bloodPressure;
  String? pulse;
  String? allergies;

  String? kinRelation;
  String? kinFullName;
  String? kinContactNumber;
  String? gpDetails;
  String? preferredLanguage;

  List<Note>? notes;

  bool? hasPhysicalDisabilities;
  String? physicalDisabilitySpecify;

  bool? requiresWheelchairAccess;
  String? wheelchairSpecify;

  bool? needsSpecialCommunication;
  String? communicationSpecify;

  bool? hasHearingImpairments;
  String? hearingSpecify;

  bool? hasVisualImpairments;
  String? visualSpecify;

  String? environmentalFactors;
  String? otherAccessibilityNeeds;

  bool? hasHealthInsurance;
  String? insuranceProvider;
  String? policyNumber;
  String? insuranceClaimContact;
  String? linkedHospitals;
  String? additionalHealthBenefits;

  List<String>? pastMedicalHistory;
  List<String>? pastDrugHistory;
  List<String>? pastPsychiatricHistory;
  List<String>? personalHistory;
  List<String>? familyHistory;
  List<String>? activitiesOfDailyLiving;

  bool? depressiveIllness;
  String? feelLowFrequency;
  double? moodLevel;
  double? selfEsteemLevel;

  bool? cryToggle;
  String? cryFrequency;

  bool? suicidalToggle;
  String? suicidalFrequency;

  bool? notWantToBeHereToggle;
  String? notWantToBeHereFrequency;

  bool? isWorthLiving;
  bool? isEndingLife;
  bool? isEndingThoughts;
  String? lifeEndingThoughts;

  bool? isInjured;
  String? injuredDetails;

  bool? admittedToHospital;
  String? admittedToHospitalDetails;

  bool? selfHarmed;
  String? selfHarmedDetails;

  bool? acquiredInjury;
  String? acquiredInjuryDetails;

  bool? blameYourself;
  String? blameYourselfDetails;

  Map<String, bool>? moodRelatedQuestions;
  Map<String, bool>? endingYourLifeRelatedQuestions;
  Map<String, bool>? abnormalBehaviorsRelatedQuestions;
  Map<String, bool>? believesInSpecialPurposeRelatedQuestions;

  String? overlyHappy;
  String? selectedAngerLevel;
  String? selectedAgitatedLevel;
  String? selectedFeelLow;
  String? selectedFeelElated;

  String? imagePath;

  Patient({
    required this.fullName,
    this.id,
    this.doctorUserId,
    this.email,
    this.contact,
    this.address,
    this.dateOfBirth,
    this.genderBornWith,
    this.genderIdentifiedWith,
    this.weight,
    this.height,
    this.bloodPressure,
    this.pulse,
    this.allergies,
    this.kinRelation,
    this.kinFullName,
    this.kinContactNumber,
    this.gpDetails,
    this.preferredLanguage,
    this.notes,
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
    this.pastMedicalHistory,
    this.pastDrugHistory,
    this.pastPsychiatricHistory,
    this.personalHistory,
    this.familyHistory,
    this.activitiesOfDailyLiving,
    this.depressiveIllness,
    this.feelLowFrequency,
    this.moodLevel,
    this.selfEsteemLevel,
    this.cryToggle,
    this.cryFrequency,
    this.suicidalToggle,
    this.suicidalFrequency,
    this.notWantToBeHereToggle,
    this.notWantToBeHereFrequency,
    this.isWorthLiving,
    this.isEndingLife,
    this.isEndingThoughts,
    this.lifeEndingThoughts,
    this.isInjured,
    this.injuredDetails,
    this.admittedToHospital,
    this.admittedToHospitalDetails,
    this.selfHarmed,
    this.selfHarmedDetails,
    this.acquiredInjury,
    this.acquiredInjuryDetails,
    this.blameYourself,
    this.blameYourselfDetails,
    this.moodRelatedQuestions,
    this.endingYourLifeRelatedQuestions,
    this.abnormalBehaviorsRelatedQuestions,
    this.believesInSpecialPurposeRelatedQuestions,
    this.overlyHappy,
    this.selectedAngerLevel,
    this.selectedAgitatedLevel,
    this.selectedFeelLow,
    this.selectedFeelElated,
    this.imagePath,
  });

  // JSON helpers
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorUserId': doctorUserId,
      'fullName': fullName,
      'email': email,
      'contact': contact,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'genderBornWith': genderBornWith,
      'genderIdentifiedWith': genderIdentifiedWith,
      'weight': weight,
      'height': height,
      'bloodPressure': bloodPressure,
      'pulse': pulse,
      'allergies': allergies,
      'kinRelation': kinRelation,
      'kinFullName': kinFullName,
      'gpDetails': gpDetails,
      'preferredLanguage': preferredLanguage,
      'kinContactNumber': kinContactNumber,
      'notes': notes,
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
      'pastMedicalHistory': pastMedicalHistory,
      'pastDrugHistory': pastDrugHistory,
      'pastPsychiatricHistory': pastPsychiatricHistory,
      'personalHistory': personalHistory,
      'familyHistory': familyHistory,
      'activitiesOfDailyLiving': activitiesOfDailyLiving,
      'depressiveIllness': depressiveIllness,
      'feelLowFrequency': feelLowFrequency,
      'moodLevel': moodLevel,
      'selfEsteemLevel': selfEsteemLevel,
      'cryToggle': cryToggle,
      'cryFrequency': cryFrequency,
      'suicidalToggle': suicidalToggle,
      'suicidalFrequency': suicidalFrequency,
      'notWantToBeHereToggle': notWantToBeHereToggle,
      'notWantToBeHereFrequency': notWantToBeHereFrequency,
      'isWorthLiving': isWorthLiving,
      'isEndingLife': isEndingLife,
      'isEndingThoughts': isEndingThoughts,
      'lifeEndingThoughts': lifeEndingThoughts,
      'isInjured': isInjured,
      'injuredDetails': injuredDetails,
      'admittedToHospital': admittedToHospital,
      'admittedToHospitalDetails': admittedToHospitalDetails,
      'selfHarmed': selfHarmed,
      'selfHarmedDetails': selfHarmedDetails,
      'acquiredInjury': acquiredInjury,
      'acquiredInjuryDetails': acquiredInjuryDetails,
      'blameYourself': blameYourself,
      'blameYourselfDetails': blameYourselfDetails,
      'moodRelatedQuestions': moodRelatedQuestions,
      'endingYourLifeRelatedQuestions': endingYourLifeRelatedQuestions,
      'abnormalBehaviorsRelatedQuestions': abnormalBehaviorsRelatedQuestions,
      'believesInSpecialPurposeRelatedQuestions':
          believesInSpecialPurposeRelatedQuestions,
      'overlyHappy': overlyHappy,
      'selectedAngerLevel': selectedAngerLevel,
      'selectedAgitatedLevel': selectedAgitatedLevel,
      'selectedFeelLow': selectedFeelLow,
      'selectedFeelElated': selectedFeelElated,
      'imagePath': imagePath,
    };
  }

  static Patient fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      doctorUserId: json['doctorUserId'],
      fullName: json['fullName'] ?? 'No Name',
      email: json['email'],
      contact: json['contact'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'],
      genderBornWith: json['genderBornWith'],
      genderIdentifiedWith: json['genderIdentifiedWith'],
      weight: json['weight'],
      height: json['height'],
      bloodPressure: json['bloodPressure'],
      pulse: json['pulse'],
      allergies: json['allergies'],
      kinRelation: json['kinRelation'],
      kinFullName: json['kinFullName'],
      kinContactNumber: json['kinContactNumber'],
      gpDetails: json['gpDetails'],
      preferredLanguage: json['preferredLanguage'],
      notes:
          json['notes'] != null
              ? List<Note>.from(
                json['notes'].map((note) => Note.fromJson(note)),
              )
              : [],
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
      pastMedicalHistory:
          json['pastMedicalHistory'] != null
              ? List<String>.from(json['pastMedicalHistory'])
              : null,
      pastDrugHistory:
          json['pastDrugHistory'] != null
              ? List<String>.from(json['pastDrugHistory'])
              : null,
      pastPsychiatricHistory:
          json['pastPsychiatricHistory'] != null
              ? List<String>.from(json['pastPsychiatricHistory'])
              : null,
      personalHistory:
          json['personalHistory'] != null
              ? List<String>.from(json['personalHistory'])
              : null,
      familyHistory:
          json['familyHistory'] != null
              ? List<String>.from(json['familyHistory'])
              : null,
      activitiesOfDailyLiving:
          json['activitiesOfDailyLiving'] != null
              ? List<String>.from(json['activitiesOfDailyLiving'])
              : null,
      depressiveIllness: json['depressiveIllness'],
      feelLowFrequency: json['feelLowFrequency'],
      moodLevel:
          json['moodLevel'] != null
              ? (json['moodLevel'] as num).toDouble()
              : null,
      selfEsteemLevel:
          json['selfEsteemLevel'] != null
              ? (json['selfEsteemLevel'] as num).toDouble()
              : null,
      cryToggle: json['cryToggle'],
      cryFrequency: json['cryFrequency'],
      suicidalToggle: json['suicidalToggle'],
      suicidalFrequency: json['suicidalFrequency'],
      notWantToBeHereToggle: json['notWantToBeHereToggle'],
      notWantToBeHereFrequency: json['notWantToBeHereFrequency'],
      isWorthLiving: json['isWorthLiving'],
      isEndingLife: json['isEndingLife'],
      isEndingThoughts: json['isEndingThoughts'],
      lifeEndingThoughts: json['lifeEndingThoughts'],
      isInjured: json['isInjured'],
      injuredDetails: json['injuredDetails'],
      admittedToHospital: json['admittedToHospital'],
      admittedToHospitalDetails: json['admittedToHospitalDetails'],
      selfHarmed: json['selfHarmed'],
      selfHarmedDetails: json['selfHarmedDetails'],
      acquiredInjury: json['acquiredInjury'],
      acquiredInjuryDetails: json['acquiredInjuryDetails'],
      blameYourself: json['blameYourself'],
      blameYourselfDetails: json['blameYourselfDetails'],
      moodRelatedQuestions:
          json['moodRelatedQuestions'] != null
              ? Map<String, bool>.from(json['moodRelatedQuestions'])
              : null,
      endingYourLifeRelatedQuestions:
          json['endingYourLifeRelatedQuestions'] != null
              ? Map<String, bool>.from(json['endingYourLifeRelatedQuestions'])
              : null,
      abnormalBehaviorsRelatedQuestions:
          json['abnormalBehaviorsRelatedQuestions'] != null
              ? Map<String, bool>.from(
                json['abnormalBehaviorsRelatedQuestions'],
              )
              : null,
      believesInSpecialPurposeRelatedQuestions:
          json['believesInSpecialPurposeRelatedQuestions'] != null
              ? Map<String, bool>.from(
                json['believesInSpecialPurposeRelatedQuestions'],
              )
              : null,
      overlyHappy: json['overlyHappy'],
      selectedAngerLevel: json['selectedAngerLevel'],
      selectedAgitatedLevel: json['selectedAgitatedLevel'],
      selectedFeelLow: json['selectedFeelLow'],
      selectedFeelElated: json['selectedFeelElated'],
      imagePath: json['imagePath'],
    );
  }

  @override
  String toString() {
    return 'Patient(id: $id, fullName: $fullName, email: $email, contact: $contact, dob: $dateOfBirth, genderBornWith: $genderBornWith, genderIdentifiedWith: $genderIdentifiedWith, weight: $weight, height: $height, bloodPressure: $bloodPressure, pulse: $pulse, allergies: $allergies, pastMedicalHistory: $pastMedicalHistory, moodLevel: $moodLevel, imagePath: $imagePath, notes : $notes ...)';
  }
}
