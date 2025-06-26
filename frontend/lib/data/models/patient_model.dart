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

  // Past Medical History
  bool? hasPastMedicalHistory;
  List<String>? pastMedicalHistory;
  bool? hasFamilyHistory;
  List<String>? familyHistory;
  bool? hasMedicationHistory;
  List<String>? medicationHistory;

  // Past Drug History
  bool? hasAllergatic;
  bool? hasMedicationAllergatic;
  String? medicationAllergatic;
  bool? hasTakingMedication;
  String? takingMedication;
  bool? hasMentalMedication;
  String? mentalMedication;

  // Past Psychiatric History
  String? isVisitedPsychiatrist;
  bool? hasDiagnosisHistory;
  List<String>? diagnosisHistory;
  String? isPsychiatricallyHospitalized;
  String? is72HourMentallyDetentionOrder;
  bool? hasDetainedMentalHealth;
  String? numberOfMentallyDetained;
  String? detainedMentalHealthTreatment;
  bool? hasSeekingHelp;
  String? seekingHelp;

  // Personal History
  String? isPlannedPregnancy;
  String? isMaternalSubstanceUseDuringPregnancy;
  String? isBirthDelayed;
  String? isBirthInduced;
  String? isBirthHypoxia;
  String? isImmediatePostNatalComplications;
  String? isRequireOxygenOrIncubator;
  String? isFeedWellAsNewborn;
  String? isSleepWellAsNewborn;

  // Family History
  bool? hasFamilyMentalHealthHistory;
  String? familyRelationshipDetails;
  String? familyMentalHealthCondition;
  bool? hasBeenHospitalizedForMentalHealth;
  String? numberOfAdmissions;
  String? duration;
  String? outcome;

  // Activities of daily living
  String? showerAbility;
  String? showerFrequency;
  String? dressingAbility;
  String? eatingAbility;
  String? foodType;
  String? toiletingAbility;
  String? groomingAbility;
  String? menstrualManagement;
  String? householdTasks;
  String? dailyAffairs;
  String? safetyMobility;

  // Mood info
  bool? hasDepressiveIllness;
  String? depressiveFrequency;
  double? moodLevel;
  bool? moodWorseInMorning;
  bool? moodConstantlyLow;
  bool? canSmile;
  bool? canLaugh;
  bool? hasNormalAppetiteAndEnjoyment;
  String? enjoyment;
  bool? hasCrying;
  String? cryFrequency;
  bool? feelsLifeWorth;
  bool? hasSuicidalThoughts;
  String? suicidalFrequency;
  bool? feelsNotWantToBeHere;
  String? notWantToBeHereFrequency;
  bool? wantToDie;
  String? wantToDieFrequency;
  bool? hasTriedEndingLife;
  bool? hasEndingLifeThoughts;
  String? lifeEndingThoughts;
  bool? hasInjuries;
  String? injured;
  bool? hasHospitalAdmission;
  String? admittedToHospital;
  bool? hasSelfHarmed;
  String? selfHarmed;
  bool? hasAcquiredInjury;
  String? acquiredInjury;
  bool? hasGuilt;
  String? guiltYourself;
  bool? bloodVesselDamage;
  bool? nerveDamage;
  bool? requiredStitches;
  bool? requiredSurgery;
  bool? permanentDamageFromSelfHarm;
  bool? hasConfidenceAndSelfEsteem;
  double? selfEsteemLevel;
  String? overlyHappyFrequency;
  bool? excessivelyFlirty;
  bool? increasedSexDrive;
  bool? recklessSpending;
  bool? undressedInPublic;
  bool? buysBeyondMeans;
  bool? highRiskActivities;
  bool? inflatedSelfEsteem;
  bool? feelsSuperior;
  bool? believesInPowers;
  bool? feelsWealthyOrGenius;
  String? angerLevel;
  String? agitationLevel;
  String? lowMoodDuration;
  String? elatedMoodDuration;

  // Mood assessment
  String? selectedPhysicalSymptom;
  double? moodLevels;
  String? moodAffectLife;
  String? extremeEnergyPeriods;
  String? recklessSpendingFrequency;
  bool? isTakingMedications;
  String? alcoholDrugUseFrequency;
  String? medicalConditions;

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

    // Past Medical History
    this.hasPastMedicalHistory,
    this.pastMedicalHistory,
    this.hasFamilyHistory,
    this.familyHistory,
    this.hasMedicationHistory,
    this.medicationHistory,

    // Past Drug History
    this.hasAllergatic,
    this.hasMedicationAllergatic,
    this.medicationAllergatic,
    this.hasTakingMedication,
    this.takingMedication,
    this.hasMentalMedication,
    this.mentalMedication,

    // Past Psychiatric History
    this.isVisitedPsychiatrist,
    this.hasDiagnosisHistory,
    this.diagnosisHistory,
    this.isPsychiatricallyHospitalized,
    this.is72HourMentallyDetentionOrder,
    this.hasDetainedMentalHealth,
    this.numberOfMentallyDetained,
    this.detainedMentalHealthTreatment,
    this.hasSeekingHelp,
    this.seekingHelp,

    // Personal History
    this.isPlannedPregnancy,
    this.isMaternalSubstanceUseDuringPregnancy,
    this.isBirthDelayed,
    this.isBirthInduced,
    this.isBirthHypoxia,
    this.isImmediatePostNatalComplications,
    this.isRequireOxygenOrIncubator,
    this.isFeedWellAsNewborn,
    this.isSleepWellAsNewborn,

    // Family History
    this.hasFamilyMentalHealthHistory,
    this.familyRelationshipDetails,
    this.familyMentalHealthCondition,
    this.hasBeenHospitalizedForMentalHealth,
    this.numberOfAdmissions,
    this.duration,
    this.outcome,

    // Activities of daily living
    this.showerAbility,
    this.showerFrequency,
    this.dressingAbility,
    this.eatingAbility,
    this.foodType,
    this.toiletingAbility,
    this.groomingAbility,
    this.menstrualManagement,
    this.householdTasks,
    this.dailyAffairs,
    this.safetyMobility,

    //Mood info
    this.hasDepressiveIllness,
    this.depressiveFrequency,
    this.moodLevel,
    this.moodWorseInMorning,
    this.moodConstantlyLow,
    this.canSmile,
    this.canLaugh,
    this.hasNormalAppetiteAndEnjoyment,
    this.enjoyment,
    this.hasCrying,
    this.cryFrequency,
    this.feelsLifeWorth,
    this.hasSuicidalThoughts,
    this.suicidalFrequency,
    this.feelsNotWantToBeHere,
    this.notWantToBeHereFrequency,
    this.wantToDie,
    this.wantToDieFrequency,
    this.hasTriedEndingLife,
    this.hasEndingLifeThoughts,
    this.lifeEndingThoughts,
    this.hasInjuries,
    this.injured,
    this.hasHospitalAdmission,
    this.admittedToHospital,
    this.hasSelfHarmed,
    this.selfHarmed,
    this.hasAcquiredInjury,
    this.acquiredInjury,
    this.hasGuilt,
    this.guiltYourself,
    this.bloodVesselDamage,
    this.nerveDamage,
    this.requiredStitches,
    this.requiredSurgery,
    this.permanentDamageFromSelfHarm,
    this.hasConfidenceAndSelfEsteem,
    this.selfEsteemLevel,
    this.overlyHappyFrequency,
    this.excessivelyFlirty,
    this.increasedSexDrive,
    this.recklessSpending,
    this.undressedInPublic,
    this.buysBeyondMeans,
    this.highRiskActivities,
    this.inflatedSelfEsteem,
    this.feelsSuperior,
    this.believesInPowers,
    this.feelsWealthyOrGenius,
    this.angerLevel,
    this.agitationLevel,
    this.lowMoodDuration,
    this.elatedMoodDuration,

    // Mood assessment
    this.selectedPhysicalSymptom,
    this.moodLevels,
    this.moodAffectLife,
    this.extremeEnergyPeriods,
    this.recklessSpendingFrequency,
    this.isTakingMedications,
    this.alcoholDrugUseFrequency,
    this.medicalConditions,

    this.imagePath,
  });
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
              ? List<Note>.from(json['notes'].map((x) => Note.fromJson(x)))
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

      // Past Medical History
      hasPastMedicalHistory: json['hasPastMedicalHistory'],
      pastMedicalHistory:
          json['pastMedicalHistory'] != null
              ? List<String>.from(json['pastMedicalHistory'])
              : null,
      hasMedicationHistory: json['hasMedicationHistory'],
      medicationHistory:
          json['medicationHistory'] != null
              ? List<String>.from(json['medicationHistory'])
              : null,
      hasFamilyHistory: json['hasFamilyHistory'],
      familyHistory:
          json['familyHistory'] != null
              ? List<String>.from(json['familyHistory'])
              : null,

      // Past Drug History
      hasAllergatic: json['hasAllergatic'],
      hasMedicationAllergatic: json['hasMedicationAllergatic'],
      medicationAllergatic: json['medicationAllergatic'],
      hasTakingMedication: json['hasTakingMedication'],
      takingMedication: json['takingMedication'],
      hasMentalMedication: json['hasMentalMedication'],
      mentalMedication: json['mentalMedication'],

      // Past Psychiatric History
      isVisitedPsychiatrist: json['isVisitedPsychiatrist'],
      hasDiagnosisHistory: json['hasDiagnosisHistory'],
      diagnosisHistory:
          json['diagnosisHistory'] != null
              ? List<String>.from(json['diagnosisHistory'])
              : null,
      isPsychiatricallyHospitalized: json['isPsychiatricallyHospitalized'],
      is72HourMentallyDetentionOrder: json['is72HourMentallyDetentionOrder'],
      hasDetainedMentalHealth: json['hasDetainedMentalHealth'],
      numberOfMentallyDetained: json['numberOfMentallyDetained'],
      detainedMentalHealthTreatment: json['detainedMentalHealthTreatment'],
      hasSeekingHelp: json['hasSeekingHelp'],
      seekingHelp: json['seekingHelp'],

      // Personal History
      isPlannedPregnancy: json['isPlannedPregnancy'],
      isMaternalSubstanceUseDuringPregnancy:
          json['isMaternalSubstanceUseDuringPregnancy'],
      isBirthDelayed: json['isBirthDelayed'],
      isBirthInduced: json['isBirthInduced'],
      isBirthHypoxia: json['isBirthHypoxia'],
      isImmediatePostNatalComplications:
          json['isImmediatePostNatalComplications'],
      isRequireOxygenOrIncubator: json['isRequireOxygenOrIncubator'],
      isFeedWellAsNewborn: json['isFeedWellAsNewborn'],
      isSleepWellAsNewborn: json['isSleepWellAsNewborn'],

      // Family History
      hasFamilyMentalHealthHistory: json['hasFamilyMentalHealthHistory'],
      familyRelationshipDetails: json['familyRelationshipDetails'],
      familyMentalHealthCondition: json['familyMentalHealthCondition'],
      hasBeenHospitalizedForMentalHealth:
          json['hasBeenHospitalizedForMentalHealth'],
      numberOfAdmissions: json['numberOfAdmissions'],
      duration: json['duration'],
      outcome: json['outcome'],

      // Activities of daily living
      showerAbility: json['showerAbility'],
      showerFrequency: json['showerFrequency'],
      dressingAbility: json['dressingAbility'],
      eatingAbility: json['eatingAbility'],
      foodType: json['foodType'],
      toiletingAbility: json['toiletingAbility'],
      groomingAbility: json['groomingAbility'],
      menstrualManagement: json['menstrualManagement'],
      householdTasks: json['householdTasks'],
      dailyAffairs: json['dailyAffairs'],
      safetyMobility: json['safetyMobility'],

      // Mood info
      hasDepressiveIllness: json['hasDepressiveIllness'],
      depressiveFrequency: json['depressiveFrequency'],
      moodLevel: json['moodLevel'],
      moodWorseInMorning: json['moodWorseInMorning'],
      moodConstantlyLow: json['moodConstantlyLow'],
      canSmile: json['canSmile'],
      canLaugh: json['canLaugh'],
      hasNormalAppetiteAndEnjoyment: json['hasNormalAppetiteAndEnjoyment'],
      enjoyment: json['enjoyment'],
      hasCrying: json['hasCrying'],
      cryFrequency: json['cryFrequency'],
      feelsLifeWorth: json['feelsLifeWorth'],
      hasSuicidalThoughts: json['hasSuicidalThoughts'],
      suicidalFrequency: json['suicidalFrequency'],
      feelsNotWantToBeHere: json['feelsNotWantToBeHere'],
      notWantToBeHereFrequency: json['notWantToBeHereFrequency'],
      wantToDie: json['wantToDie'],
      wantToDieFrequency: json['wantToDieFrequency'],
      hasTriedEndingLife: json['hasTriedEndingLife'],
      hasEndingLifeThoughts: json['hasEndingLifeThoughts'],
      lifeEndingThoughts: json['lifeEndingThoughts'],
      hasInjuries: json['hasInjuries'],
      injured: json['injured'],
      hasHospitalAdmission: json['hasHospitalAdmission'],
      admittedToHospital: json['admittedToHospital'],
      hasSelfHarmed: json['hasSelfHarmed'],
      selfHarmed: json['selfHarmed'],
      hasAcquiredInjury: json['hasAcquiredInjury'],
      acquiredInjury: json['acquiredInjury'],
      hasGuilt: json['hasGuilt'],
      guiltYourself: json['guiltYourself'],
      bloodVesselDamage: json['bloodVesselDamage'],
      nerveDamage: json['nerveDamage'],
      requiredStitches: json['requiredStitches'],
      requiredSurgery: json['requiredSurgery'],
      permanentDamageFromSelfHarm: json['permanentDamageFromSelfHarm'],
      hasConfidenceAndSelfEsteem: json['hasConfidenceAndSelfEsteem'],
      selfEsteemLevel: json['selfEsteemLevel'],
      overlyHappyFrequency: json['overlyHappyFrequency'],
      excessivelyFlirty: json['excessivelyFlirty'],
      increasedSexDrive: json['increasedSexDrive'],
      recklessSpending: json['recklessSpending'],
      undressedInPublic: json['undressedInPublic'],
      buysBeyondMeans: json['buysBeyondMeans'],
      highRiskActivities: json['highRiskActivities'],
      inflatedSelfEsteem: json['inflatedSelfEsteem'],
      feelsSuperior: json['feelsSuperior'],
      believesInPowers: json['believesInPowers'],
      feelsWealthyOrGenius: json['feelsWealthyOrGenius'],
      angerLevel: json['angerLevel'],
      agitationLevel: json['agitationLevel'],
      lowMoodDuration: json['lowMoodDuration'],
      elatedMoodDuration: json['elatedMoodDuration'],

      // Mood assessment
      selectedPhysicalSymptom: json['selectedPhysicalSymptom'],
      moodLevels: json['moodLevels'],
      moodAffectLife: json['moodAffectLife'],
      extremeEnergyPeriods: json['extremeEnergyPeriods'],
      recklessSpendingFrequency: json['recklessSpendingFrequency'],
      isTakingMedications: json['isTakingMedications'],
      alcoholDrugUseFrequency: json['alcoholDrugUseFrequency'],
      medicalConditions: json['medicalConditions'],

      imagePath: json['imagePath'],
    );
  }

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
      'kinContactNumber': kinContactNumber,
      'gpDetails': gpDetails,
      'preferredLanguage': preferredLanguage,
      'notes': notes?.map((n) => n.toJson()).toList(),
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

      // Past Medical History
      'hasPastMedicalHistory': hasPastMedicalHistory,
      'pastMedicalHistory': pastMedicalHistory,
      'hasMedicationHistory': hasMedicationHistory,
      'medicationHistory': medicationHistory,
      'hasFamilyHistory': hasFamilyHistory,
      'familyHistory': familyHistory,

      // Past Drug History
      'hasAllergatic': hasAllergatic,
      'hasMedicationAllergatic': hasMedicationAllergatic,
      'medicationAllergatic': medicationAllergatic,
      'hasTakingMedication': hasTakingMedication,
      'takingMedication': takingMedication,
      'hasMentalMedication': hasMentalMedication,
      'mentalMedication': mentalMedication,

      // Past Psychiatric History
      'isVisitedPsychiatrist': isVisitedPsychiatrist,
      'hasDiagnosisHistory': hasDiagnosisHistory,
      'diagnosisHistory': diagnosisHistory,
      'isPsychiatricallyHospitalized': isPsychiatricallyHospitalized,
      'is72HourMentallyDetentionOrder': is72HourMentallyDetentionOrder,
      'hasDetainedMentalHealth': hasDetainedMentalHealth,
      'numberOfMentallyDetained': numberOfMentallyDetained,
      'detainedMentalHealthTreatment': detainedMentalHealthTreatment,
      'hasSeekingHelp': hasSeekingHelp,
      'seekingHelp': seekingHelp,

      // Personal History
      'isPlannedPregnancy': isPlannedPregnancy,
      'isMaternalSubstanceUseDuringPregnancy':
          isMaternalSubstanceUseDuringPregnancy,
      'isBirthDelayed': isBirthDelayed,
      'isBirthInduced': isBirthInduced,
      'isBirthHypoxia': isBirthHypoxia,
      'isImmediatePostNatalComplications': isImmediatePostNatalComplications,
      'isRequireOxygenOrIncubator': isRequireOxygenOrIncubator,
      'isFeedWellAsNewborn': isFeedWellAsNewborn,
      'isSleepWellAsNewborn': isSleepWellAsNewborn,

      // Family History
      'hasFamilyMentalHealthHistory': hasFamilyMentalHealthHistory,
      'familyRelationshipDetails': familyRelationshipDetails,
      'familyMentalHealthCondition': familyMentalHealthCondition,
      'hasBeenHospitalizedForMentalHealth': hasBeenHospitalizedForMentalHealth,
      'numberOfAdmissions': numberOfAdmissions,
      'duration': duration,
      'outcome': outcome,

      // Activities of daily living
      'showerAbility': showerAbility,
      'showerFrequency': showerFrequency,
      'dressingAbility': dressingAbility,
      'eatingAbility': eatingAbility,
      'foodType': foodType,
      'toiletingAbility': toiletingAbility,
      'groomingAbility': groomingAbility,
      'menstrualManagement': menstrualManagement,
      'householdTasks': householdTasks,
      'dailyAffairs': dailyAffairs,
      'safetyMobility': safetyMobility,

      // Mood info
      'hasDepressiveIllness': hasDepressiveIllness,
      'depressiveFrequency': depressiveFrequency,
      'moodLevel': moodLevel,
      'moodWorseInMorning': moodWorseInMorning,
      'moodConstantlyLow': moodConstantlyLow,
      'canSmile': canSmile,
      'canLaugh': canLaugh,
      'hasNormalAppetiteAndEnjoyment': hasNormalAppetiteAndEnjoyment,
      'enjoyment': enjoyment,
      'hasCrying': hasCrying,
      'cryFrequency': cryFrequency,
      'feelsLifeWorth': feelsLifeWorth,
      'hasSuicidalThoughts': hasSuicidalThoughts,
      'suicidalFrequency': suicidalFrequency,
      'feelsNotWantToBeHere': feelsNotWantToBeHere,
      'notWantToBeHereFrequency': notWantToBeHereFrequency,
      'wantToDie': wantToDie,
      'wantToDieFrequency': wantToDieFrequency,
      'hasTriedEndingLife': hasTriedEndingLife,
      'hasEndingLifeThoughts': hasEndingLifeThoughts,
      'lifeEndingThoughts': lifeEndingThoughts,
      'hasInjuries': hasInjuries,
      'injured': injured,
      'hasHospitalAdmission': hasHospitalAdmission,
      'admittedToHospital': admittedToHospital,
      'hasSelfHarmed': hasSelfHarmed,
      'selfHarmed': selfHarmed,
      'hasAcquiredInjury': hasAcquiredInjury,
      'acquiredInjury': acquiredInjury,
      'hasGuilt': hasGuilt,
      'guiltYourself': guiltYourself,
      'bloodVesselDamage': bloodVesselDamage,
      'nerveDamage': nerveDamage,
      'requiredStitches': requiredStitches,
      'requiredSurgery': requiredSurgery,
      'permanentDamageFromSelfHarm': permanentDamageFromSelfHarm,
      'hasConfidenceAndSelfEsteem': hasConfidenceAndSelfEsteem,
      'selfEsteemLevel': selfEsteemLevel,
      'overlyHappyFrequency': overlyHappyFrequency,
      'excessivelyFlirty': excessivelyFlirty,
      'increasedSexDrive': increasedSexDrive,
      'recklessSpending': recklessSpending,
      'undressedInPublic': undressedInPublic,
      'buysBeyondMeans': buysBeyondMeans,
      'highRiskActivities': highRiskActivities,
      'inflatedSelfEsteem': inflatedSelfEsteem,
      'feelsSuperior': feelsSuperior,
      'believesInPowers': believesInPowers,
      'feelsWealthyOrGenius': feelsWealthyOrGenius,
      'angerLevel': angerLevel,
      'agitationLevel': agitationLevel,
      'lowMoodDuration': lowMoodDuration,
      'elatedMoodDuration': elatedMoodDuration,

      // Mood assessment
      'selectedPhysicalSymptom': selectedPhysicalSymptom,
      'moodLevels': moodLevels,
      'moodAffectLife': moodAffectLife,
      'extremeEnergyPeriods': extremeEnergyPeriods,
      'recklessSpendingFrequency': recklessSpendingFrequency,
      'isTakingMedications': isTakingMedications,
      'alcoholDrugUseFrequency': alcoholDrugUseFrequency,
      'medicalConditions': medicalConditions,

      'imagePath': imagePath,
    };
  }

  @override
  String toString() {
    return 'Patient(\n'
        'id: $id,\n'
        'doctorUserId: $doctorUserId,\n'
        'fullName: $fullName,\n'
        'email: $email,\n'
        'contact: $contact,\n'
        'address: $address,\n'
        'dateOfBirth: $dateOfBirth,\n'
        'genderBornWith: $genderBornWith,\n'
        'genderIdentifiedWith: $genderIdentifiedWith,\n'
        'weight: $weight,\n'
        'height: $height,\n'
        'bloodPressure: $bloodPressure,\n'
        'pulse: $pulse,\n'
        'allergies: $allergies,\n'
        'kinRelation: $kinRelation,\n'
        'kinFullName: $kinFullName,\n'
        'kinContactNumber: $kinContactNumber,\n'
        'gpDetails: $gpDetails,\n'
        'preferredLanguage: $preferredLanguage,\n'
        'notes: ${notes?.map((n) => n.toString()).join(', ')},\n'
        'hasPhysicalDisabilities: $hasPhysicalDisabilities,\n'
        'physicalDisabilitySpecify: $physicalDisabilitySpecify,\n'
        'requiresWheelchairAccess: $requiresWheelchairAccess,\n'
        'wheelchairSpecify: $wheelchairSpecify,\n'
        'needsSpecialCommunication: $needsSpecialCommunication,\n'
        'communicationSpecify: $communicationSpecify,\n'
        'hasHearingImpairments: $hasHearingImpairments,\n'
        'hearingSpecify: $hearingSpecify,\n'
        'hasVisualImpairments: $hasVisualImpairments,\n'
        'visualSpecify: $visualSpecify,\n'
        'environmentalFactors: $environmentalFactors,\n'
        'otherAccessibilityNeeds: $otherAccessibilityNeeds,\n'
        'hasHealthInsurance: $hasHealthInsurance,\n'
        'insuranceProvider: $insuranceProvider,\n'
        'policyNumber: $policyNumber,\n'
        'insuranceClaimContact: $insuranceClaimContact,\n'
        'linkedHospitals: $linkedHospitals,\n'
        'additionalHealthBenefits: $additionalHealthBenefits,\n'
        'hasPastMedicalHistory: $hasPastMedicalHistory,\n'
        'pastMedicalHistory: $pastMedicalHistory,\n'
        'hasFamilyHistory: $hasFamilyHistory,\n'
        'familyHistory: $familyHistory,\n'
        'hasMedicationHistory: $hasMedicationHistory,\n'
        'medicationHistory: $medicationHistory,\n'
        'hasAllergatic: $hasAllergatic,\n'
        'hasMedicationAllergatic: $hasMedicationAllergatic,\n'
        'medicationAllergatic: $medicationAllergatic,\n'
        'hasTakingMedication: $hasTakingMedication,\n'
        'takingMedication: $takingMedication,\n'
        'hasMentalMedication: $hasMentalMedication,\n'
        'mentalMedication: $mentalMedication,\n'
        'isVisitedPsychiatrist: $isVisitedPsychiatrist,\n'
        'hasDiagnosisHistory: $hasDiagnosisHistory,\n'
        'diagnosisHistory: $diagnosisHistory,\n'
        'isPsychiatricallyHospitalized: $isPsychiatricallyHospitalized,\n'
        'is72HourMentallyDetentionOrder: $is72HourMentallyDetentionOrder,\n'
        'hasDetainedMentalHealth: $hasDetainedMentalHealth,\n'
        'numberOfMentallyDetained: $numberOfMentallyDetained,\n'
        'detainedMentalHealthTreatment: $detainedMentalHealthTreatment,\n'
        'hasSeekingHelp: $hasSeekingHelp,\n'
        'seekingHelp: $seekingHelp,\n'
        'isPlannedPregnancy: $isPlannedPregnancy,\n'
        'isMaternalSubstanceUseDuringPregnancy: $isMaternalSubstanceUseDuringPregnancy,\n'
        'isBirthDelayed: $isBirthDelayed,\n'
        'isBirthInduced: $isBirthInduced,\n'
        'isBirthHypoxia: $isBirthHypoxia,\n'
        'isImmediatePostNatalComplications: $isImmediatePostNatalComplications,\n'
        'isRequireOxygenOrIncubator: $isRequireOxygenOrIncubator,\n'
        'isFeedWellAsNewborn: $isFeedWellAsNewborn,\n'
        'isSleepWellAsNewborn: $isSleepWellAsNewborn,\n'
        'hasFamilyMentalHealthHistory: $hasFamilyMentalHealthHistory,\n'
        'familyRelationshipDetails: $familyRelationshipDetails,\n'
        'familyMentalHealthCondition: $familyMentalHealthCondition,\n'
        'hasBeenHospitalizedForMentalHealth: $hasBeenHospitalizedForMentalHealth,\n'
        'numberOfAdmissions: $numberOfAdmissions,\n'
        'duration: $duration,\n'
        'outcome: $outcome,\n'
        'showerAbility: $showerAbility,\n'
        'showerFrequency: $showerFrequency,\n'
        'dressingAbility: $dressingAbility,\n'
        'eatingAbility: $eatingAbility,\n'
        'foodType: $foodType,\n'
        'toiletingAbility: $toiletingAbility,\n'
        'groomingAbility: $groomingAbility,\n'
        'menstrualManagement: $menstrualManagement,\n'
        'householdTasks: $householdTasks,\n'
        'dailyAffairs: $dailyAffairs,\n'
        'safetyMobility: $safetyMobility,\n'
        'hasDepressiveIllness: $hasDepressiveIllness,\n'
        'depressiveFrequency: $depressiveFrequency,\n'
        'moodLevel: $moodLevel,\n'
        'moodWorseInMorning: $moodWorseInMorning,\n'
        'moodConstantlyLow: $moodConstantlyLow,\n'
        'canSmile: $canSmile,\n'
        'canLaugh: $canLaugh,\n'
        'hasNormalAppetiteAndEnjoyment: $hasNormalAppetiteAndEnjoyment,\n'
        'enjoyment: $enjoyment,\n'
        'hasCrying: $hasCrying,\n'
        'cryFrequency: $cryFrequency,\n'
        'feelsLifeWorth: $feelsLifeWorth,\n'
        'hasSuicidalThoughts: $hasSuicidalThoughts,\n'
        'suicidalFrequency: $suicidalFrequency,\n'
        'feelsNotWantToBeHere: $feelsNotWantToBeHere,\n'
        'notWantToBeHereFrequency: $notWantToBeHereFrequency,\n'
        'wantToDie: $wantToDie,\n'
        'wantToDieFrequency: $wantToDieFrequency,\n'
        'hasTriedEndingLife: $hasTriedEndingLife,\n'
        'hasEndingLifeThoughts: $hasEndingLifeThoughts,\n'
        'lifeEndingThoughts: $lifeEndingThoughts,\n'
        'hasInjuries: $hasInjuries,\n'
        'injured: $injured,\n'
        'hasHospitalAdmission: $hasHospitalAdmission,\n'
        'admittedToHospital: $admittedToHospital,\n'
        'hasSelfHarmed: $hasSelfHarmed,\n'
        'selfHarmed: $selfHarmed,\n'
        'hasAcquiredInjury: $hasAcquiredInjury,\n'
        'acquiredInjury: $acquiredInjury,\n'
        'hasGuilt: $hasGuilt,\n'
        'guiltYourself: $guiltYourself,\n'
        'bloodVesselDamage: $bloodVesselDamage,\n'
        'nerveDamage: $nerveDamage,\n'
        'requiredStitches: $requiredStitches,\n'
        'requiredSurgery: $requiredSurgery,\n'
        'permanentDamageFromSelfHarm: $permanentDamageFromSelfHarm,\n'
        'hasConfidenceAndSelfEsteem: $hasConfidenceAndSelfEsteem,\n'
        'selfEsteemLevel: $selfEsteemLevel,\n'
        'overlyHappyFrequency: $overlyHappyFrequency,\n'
        'excessivelyFlirty: $excessivelyFlirty,\n'
        'increasedSexDrive: $increasedSexDrive,\n'
        'recklessSpending: $recklessSpending,\n'
        'undressedInPublic: $undressedInPublic,\n'
        'buysBeyondMeans: $buysBeyondMeans,\n'
        'highRiskActivities: $highRiskActivities,\n'
        'inflatedSelfEsteem: $inflatedSelfEsteem,\n'
        'feelsSuperior: $feelsSuperior,\n'
        'believesInPowers: $believesInPowers,\n'
        'feelsWealthyOrGenius: $feelsWealthyOrGenius,\n'
        'angerLevel: $angerLevel,\n'
        'agitationLevel: $agitationLevel,\n'
        'lowMoodDuration: $lowMoodDuration,\n'
        'elatedMoodDuration: $elatedMoodDuration,\n'
        'selectedPhysicalSymptom: $selectedPhysicalSymptom,\n'
        'moodLevels: $moodLevels,\n'
        'moodAffectLife: $moodAffectLife,\n'
        'extremeEnergyPeriods: $extremeEnergyPeriods,\n'
        'recklessSpendingFrequency: $recklessSpendingFrequency,\n'
        'isTakingMedications: $isTakingMedications,\n'
        'alcoholDrugUseFrequency: $alcoholDrugUseFrequency,\n'
        'medicalConditions: $medicalConditions,\n'
        'imagePath: $imagePath\n'
        ')';
  }
}
