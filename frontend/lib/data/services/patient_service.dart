import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';

class PatientService {
  Future<Map<String, dynamic>> addPatient(Patient patient) async {
    print("🧾 Submitting Patient: $patient");

    try {
      final uri = Uri.parse(ApiConstants.createPatient);
      final request = http.MultipartRequest('POST', uri);

      // Attach the image file if path is valid
      if (patient.imagePath != null && patient.imagePath!.isNotEmpty) {
        final file = File(patient.imagePath!);
        if (await file.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              file.path,
              filename: basename(file.path),
            ),
          );
        } else {
          print('⚠️ Image file does not exist at ${file.path}');
        }
      }

      // Add form fields
      request.fields['fullName'] = patient.fullName;
      request.fields['contact'] = patient.contact;
      request.fields['email'] = patient.email;
      request.fields['address'] = patient.address;
      request.fields['weight'] = patient.weight!;
      request.fields['height'] = patient.height!;
      request.fields['bloodPressure'] = patient.bloodPressure!;
      request.fields['pulse'] = patient.pulse!;
      request.fields['allergies'] = patient.allergies!;
      request.fields['dateOfBirth'] = patient.dateOfBirth;

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print('📥 Backend Response: ${response.body}');
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': body['message']};
      } else {
        return {'success': false, 'message': body['message']};
      }
    } catch (e) {
      print("❌ Exception in addPatient: $e");
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  Future<List<Patient>> getPatientsForDoctor(int userId) async {
    final url = Uri.parse('${ApiConstants.fetchPatients}/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['patients'];
      for (var patient in data) {
        print(patient);
      }
      return data.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }
}
