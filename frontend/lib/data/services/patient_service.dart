import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientService {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> addPatient(Patient patient) async {
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
          print('✅ Image file attached: ${file.path}');
        } else {
          print('⚠️ Image file does not exist at ${file.path}');
        }
      } else {
        print('ℹ️ No image path provided for patient.');
      }

      // Add form fields
      request.fields['fullName'] = patient.fullName;
      request.fields['contact'] = patient.contact!;
      request.fields['email'] = patient.email!;
      request.fields['address'] = patient.address!;
      request.fields['weight'] = patient.weight ?? '';
      request.fields['height'] = patient.height ?? '';
      request.fields['bloodPressure'] = patient.bloodPressure ?? '';
      request.fields['pulse'] = patient.pulse ?? '';
      request.fields['allergies'] = patient.allergies ?? '';
      request.fields['dateOfBirth'] = patient.dateOfBirth!;
      request.fields['doctorUserId'] = patient.doctorUserId.toString();

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

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
      return data.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<Map<String, dynamic>> updatePatientFields(
    int patientId,
    Map<String, dynamic> updatedFields,
  ) async {
    final url = Uri.parse('${ApiConstants.updatePatientHistory}/$patientId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedFields),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Unknown error occurred',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> fetchHealthRecords(
    int patientId,
    int userId,
  ) async {
    try {
      final token = await getToken();
      final url = Uri.parse(
        '${ApiConstants.fetchHealthRecords}/$userId/$patientId',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final List<dynamic> records = data['health_record'] ?? [];
        return records.cast<Map<String, dynamic>>();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch health records');
      }
    } catch (e) {
      print('❌ Exception in fetchHealthRecords: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateFavouriteStatus(
    int patientId,
    bool isFavourite,
  ) async {
    final url = Uri.parse('${ApiConstants.updateFavouriteStatus}');

    final data = {'patient_id': patientId, 'favourite_status': isFavourite};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Unknown error occurred',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
