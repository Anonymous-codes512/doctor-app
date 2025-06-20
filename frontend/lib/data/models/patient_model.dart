class Patient {
  final int? id;
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

  Patient({
    this.id,
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
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      contact: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '', // <-- fix here
      dateOfBirth: json['dateOfBirth'] ?? '',
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() => {
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
  };

  @override
  String toString() {
    return 'Patient(fullName: $fullName, contact: $contact, email: $email, address: $address, weight: $weight, height: $height, bloodPressure: $bloodPressure, pulse: $pulse, allergies: $allergies, dateOfBirth: $dateOfBirth, imagePath: $imagePath)';
  }
}
