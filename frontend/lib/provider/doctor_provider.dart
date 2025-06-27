import 'dart:convert';

import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/data/models/invoice_model.dart';
import 'package:doctor_app/data/models/notes_model.dart';
import 'package:doctor_app/data/models/task_model.dart';
import 'package:doctor_app/data/services/doctor_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _service = DoctorService();

  String userName = '';
  String greeting = '';

  AppointmentModel? _appointment;
  AppointmentModel? get appointment => _appointment;

  TaskModel? _task;
  TaskModel? get task => _task;

  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> get appointments => _appointments;

  List<InvoiceModel> _invoices = [];
  List<InvoiceModel> get invoices => _invoices;

  List<Note> _notes = []; // ✅ added
  List<Note> get notes => _notes;

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  void setAppointments(List<AppointmentModel> appts) {
    _appointments = appts;
    notifyListeners();
  }

  void setTasks(List<TaskModel> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void setInvoices(List<InvoiceModel> invoices) {
    _invoices = invoices;
    print(invoices);
    notifyListeners();
  }

  void setAppointment(AppointmentModel appointment) {
    _appointment = appointment;
    notifyListeners();
  }

  void setNotes(List<Note> notes) {
    _notes = notes;
    notifyListeners();
  }

  void setTask(TaskModel task) {
    _task = task;
    notifyListeners();
  }

  Future<void> getHomeData() async {
    try {
      final headerData = await _service.getHomeHeaderData();
      userName = headerData['name']!;
      greeting = headerData['greeting']!;

      await loadAppointments();
      await loadTasks();
      await loadInvoices();

      notifyListeners();
    } catch (e) {
      print('❌ Error in getHomeData: $e');
    }
  }

  List<AppointmentModel> getAppointmentsForWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    return _appointments.where((appointment) {
      return appointment.appointmentDate.isAfter(startOfWeek) &&
          appointment.appointmentDate.isBefore(endOfWeek);
    }).toList();
  }

  // Fetch appointments and tasks for the current month
  List<AppointmentModel> getAppointmentsForMonth() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

    return _appointments.where((appointment) {
      return appointment.appointmentDate.isAfter(startOfMonth) &&
          appointment.appointmentDate.isBefore(endOfMonth);
    }).toList();
  }

  // Fetch appointments and tasks for the current year
  List<AppointmentModel> getAppointmentsForYear() {
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime endOfYear = DateTime(now.year + 1, 1, 1);

    return _appointments.where((appointment) {
      return appointment.appointmentDate.isAfter(startOfYear) &&
          appointment.appointmentDate.isBefore(endOfYear);
    }).toList();
  }

  // Similar methods for tasks...
  List<TaskModel> getTasksForWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    return _tasks.where((task) {
      return task.taskDueDate.isAfter(startOfWeek) &&
          task.taskDueDate.isBefore(endOfWeek);
    }).toList();
  }

  List<TaskModel> getTasksForMonth() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

    return _tasks.where((task) {
      return task.taskDueDate.isAfter(startOfMonth) &&
          task.taskDueDate.isBefore(endOfMonth);
    }).toList();
  }

  List<TaskModel> getTasksForYear() {
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime endOfYear = DateTime(now.year + 1, 1, 1);

    return _tasks.where((task) {
      return task.taskDueDate.isAfter(startOfYear) &&
          task.taskDueDate.isBefore(endOfYear);
    }).toList();
  }

  Future<bool> saveAppointment(BuildContext context) async {
    if (_appointment == null) return false;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');
      if (userJson == null) return false;

      final userMap = jsonDecode(userJson);
      final doctorId = userMap['id'];

      _appointment!.doctorId = doctorId;

      final result = await _service.createAppointment(_appointment!);

      if (result['success']) {
        await loadAppointments();
        ToastHelper.showSuccess(context, result['message']);
        Navigator.pop(context);
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
  }

  Future<void> loadInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson == null) return;

    final userMap = jsonDecode(userJson);
    final doctorId = userMap['id'];

    final invoices = await _service.fetchInvoices(doctorId);
    setInvoices(invoices);
  }

  Future<bool> saveTask(BuildContext context) async {
    if (_task == null) return false;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');
      if (userJson == null) return false;

      final userMap = jsonDecode(userJson);
      final userId = userMap['id'];

      _task!.userId = userId;

      final result = await _service.createTask(_task!);

      if (result['success']) {
        await loadTasks();
        ToastHelper.showSuccess(context, result['message']);
      } else {
        ToastHelper.showError(context, result['message']);
      }

      return result['success'];
    } catch (e) {
      print("Error in Save Task: $e");
      return false;
    }
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson == null) return;

    final userMap = jsonDecode(userJson);
    final userId = userMap['id'];

    final tasks = await _service.fetchTasks(userId);
    setTasks(tasks);
  }

  Future<void> createNote(BuildContext context, Note note) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return;

      final userMap = jsonDecode(userJson);
      note.doctorUserId = userMap['id'];

      final result = await _service.createNote(note);

      if (result['success']) {
        await fetchNotes(note.patientId!);
        ToastHelper.showSuccess(context, result['message']);

        Navigator.popAndPushNamed(
          context,
          Routes.notesScreen,
          arguments: _notes,
        );
      } else {
        ToastHelper.showError(context, result['message']);
      }
    } catch (e) {
      print("❌ Error in createNote: $e");
    }
  }

  Future<void> updateNote(BuildContext context, Note note, int noteId) async {
    try {
      final result = await _service.updateNote(note, noteId);

      if (result['success']) {
        await fetchNotes(note.patientId!);
        ToastHelper.showSuccess(context, result['message']);

        Navigator.popAndPushNamed(
          context,
          Routes.notesScreen,
          arguments: _notes,
        );
      } else {
        ToastHelper.showError(context, result['message']);
      }
    } catch (e) {
      print("❌ Error in updateNote: $e");
    }
  }

  Future<void> fetchNotes(int patientId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return;

      final userMap = jsonDecode(userJson);
      final doctorUserId = userMap['id'];

      final notes = await _service.fetchNotes(patientId, doctorUserId);
      setNotes(notes);
    } catch (e) {
      print("❌ Error fetching notes: $e");
    }
  }
}
