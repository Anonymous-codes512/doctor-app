import 'dart:convert';

import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/data/services/patient_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientProvider with ChangeNotifier {
  final PatientService _service = PatientService();

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  Patient? _selectedPatient;
  Patient? get selectedPatient => _selectedPatient;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setPatients(List<Patient> patients) {
    _patients = patients;
    notifyListeners();
  }

  void setSelectedPatient(Patient patient) {
    _selectedPatient = patient;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> addPatient(Patient patient, BuildContext context) async {
    _setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return false;

      final userMap = jsonDecode(userJson);
      final userId = userMap['id'];
      patient.doctorUserId = userId;
      final result = await _service.addPatient(patient);
      if (result['success']) {
        ToastHelper.showSuccess(context, result['message']);
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.myPatientsScreen,
          (route) => false,
        );
        return true;
      } else {
        ToastHelper.showError(context, result['message']);
        return false;
      }
    } catch (e) {
      print('Error adding patient: $e');
      ToastHelper.showError(context, 'Failed to add patient');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPatients() async {
    _setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return;

      final userMap = jsonDecode(userJson);
      final userId = userMap['id'];

      final fetchedPatients = await _service.getPatientsForDoctor(userId);

      setPatients(fetchedPatients);
    } catch (e) {
      print('Error fetching patients: $e');
      _patients = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Map<String, dynamic>>> fetchHealthRecords(int patientId) async {
    _setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return [];

      final userMap = jsonDecode(userJson);
      final userId = userMap['id'];

      final fetchedHealthRecords = await _service.fetchHealthRecords(
        patientId,
        userId,
      );
      return fetchedHealthRecords;
    } catch (e) {
      print('Error fetching patients: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePatientFields(
    BuildContext context, {
    required int patientId,
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      final result = await _service.updatePatientFields(
        patientId,
        updatedFields,
      );

      if (result['success']) {
        ToastHelper.showSuccess(context, result['message']);
        await fetchPatients();
        Navigator.pop(context);
      } else {
        ToastHelper.showError(context, result['message']);
        print('❌ Failed to update fields: ${result['message']}');
      }
    } catch (e) {
      print('🚨 Exception in updatePatientFields: $e');
      ToastHelper.showError(context, 'Error while updating fields');
    }
  }

  Future<void> updateFavouriteStatus(
    BuildContext context,
    int patientId,
    bool isFavourite,
  ) async {
    try {
      final result = await _service.updateFavouriteStatus(
        patientId,
        isFavourite,
      );
      if (result['success']) {
        ToastHelper.showSuccess(context, result['message']);

        final index = _patients.indexWhere((p) => p.id == patientId);
        if (index != -1) {
          _patients[index].isFavourite = isFavourite;
          notifyListeners(); // 👈 this triggers UI rebuild
        }
        await fetchPatients();
      } else {
        ToastHelper.showError(context, result['message']);
        print('❌ Failed to update fields: ${result['message']}');
      }
    } catch (e) {
      print('🚨 Exception in updatePatientFields: $e');
      ToastHelper.showError(context, 'Error while updating fields');
    }
  }

  Patient? getPatientById(int id) {
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
