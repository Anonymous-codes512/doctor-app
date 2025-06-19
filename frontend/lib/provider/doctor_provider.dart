import 'dart:convert';

import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/data/services/doctor_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _service = DoctorService();

  String userName = '';
  String greeting = '';

  AppointmentModel? _appointment;
  AppointmentModel? get appointment => _appointment;

  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> get appointments => _appointments;

  void setAppointments(List<AppointmentModel> appts) {
    _appointments = appts;
    notifyListeners();
  }

  Future<void> getHomeData() async {
    try {
      final headerData = await _service.getHomeHeaderData();
      userName = headerData['name']!;
      greeting = headerData['greeting']!;

      loadAppointments();

      notifyListeners();
    } catch (e) {
      print('❌ Error in getHomeData: $e');
    }
  }

  void setAppointment(AppointmentModel appointment) {
    _appointment = appointment;
    notifyListeners();
  }

  Future<bool> saveAppointment(BuildContext context) async {
    if (_appointment == null) return false;

    try {
      // ✅ Read user from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');
      if (userJson == null) return false;

      final userMap = jsonDecode(userJson);
      final doctorId = userMap['id'];

      // ✅ Set doctor ID before calling API
      _appointment!.doctorId = doctorId;

      final result = await _service.createAppointment(_appointment!);

      if (result['success']) {
        ToastHelper.showSuccess(context, result['message']);
      } else {
        ToastHelper.showError(context, result['message']);
      }

      return result['success'];
    } catch (e) {
      print("Error in saveAppointment: $e");
      return false;
    }
  }

  Future<void> loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson == null) return;

    final userMap = jsonDecode(userJson);
    final doctorId = userMap['id'];

    final appts = await _service.fetchAppointments(doctorId);
    setAppointments(appts);
    for (var appointment in _appointments) {
      print(appointment);
    }
  }
}
