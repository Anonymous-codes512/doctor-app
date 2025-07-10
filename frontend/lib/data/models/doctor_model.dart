class DoctorModel {
  int? id;
  int? doctorUserId;
  String? imagePath;
  String? fullName;
  String? email;
  String? contact;
  String? dateOfBirth;
  String? gender;
  String? bloodGroup;
  String? specialization;
  String? subSpecialization;
  String? yearsOfExperience;
  String? qualification;
  String? registrationNumber;
  String? practiceName;
  String? practiceAddress;
  double? initialConsultationFee;
  String? sessionType;
  String? sessionDuration;

  // String? professionalCvLink;

  DoctorModel({
    this.id,
    this.doctorUserId,
    this.imagePath,
    this.fullName,
    this.email,
    this.contact,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.specialization,
    this.subSpecialization,
    this.yearsOfExperience,
    this.qualification,
    this.registrationNumber,
    this.practiceName,
    this.practiceAddress,
    this.initialConsultationFee,
    this.sessionType,
    this.sessionDuration,
  });
  static DoctorModel fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      doctorUserId: json['doctorUserId'],
      imagePath: json['imagePath'],
      fullName: json['fullName'],
      email: json['email'],
      contact: json['contact'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      specialization: json['specialization'],
      subSpecialization: json['subSpecialization'],
      yearsOfExperience: json['yearsOfExperience'],
      qualification: json['qualification'],
      registrationNumber: json['registrationNumber'],
      practiceName: json['practiceName'],
      practiceAddress: json['practiceAddress'],
      initialConsultationFee: json['initialConsultationFee'],
      sessionType: json['sessionType'],
      sessionDuration: json['sessionDuration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorUserId': doctorUserId,
      'imagePath': imagePath,
      'fullName': fullName,
      'email': email,
      'contact': contact,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'specialization': specialization,
      'subSpecialization': subSpecialization,
      'yearsOfExperience': yearsOfExperience,
      'qualification': qualification,
      'registrationNumber': registrationNumber,
      'practiceName': practiceName,
      'practiceAddress': practiceAddress,
      'initialConsultationFee': initialConsultationFee,
      'sessionType': sessionType,
      'sessionDuration': sessionDuration,
    };
  }

  @override
  String toString() {
    return 'DoctorModel(\n'
        'id: $id,\n'
        'doctorUserId: $doctorUserId,\n'
        'imagePath : $imagePath, \n'
        'fullName : $fullName, \n'
        'email : $email, \n'
        'contact : $contact, \n'
        'dateOfBirth : $dateOfBirth, \n'
        'gender : $gender, \n'
        'bloodGroup : $bloodGroup, \n'
        'specialization : $specialization, \n'
        'subSpecialization : $subSpecialization, \n'
        'yearsOfExperience : $yearsOfExperience, \n'
        'qualification : $qualification, \n'
        'registrationNumber : $registrationNumber, \n'
        'practiceName : $practiceName, \n'
        'practiceAddress : $practiceAddress, \n'
        'initialConsultationFee : $initialConsultationFee, \n'
        'sessionType : $sessionType, \n'
        'sessionDuration : $sessionDuration, \n'
        ')';
  }
}
