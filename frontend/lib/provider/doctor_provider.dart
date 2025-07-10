import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_confirm_dialog/animated_confirm_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/data/models/doctor_model.dart';
import 'package:doctor_app/data/models/invoice_model.dart';
import 'package:doctor_app/data/models/notes_model.dart';
import 'package:doctor_app/data/models/task_model.dart';
import 'package:doctor_app/data/services/doctor_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _service = DoctorService();

  String userName = '';
  String greeting = '';
  String profileImage = '';
  String doctorEmail = '';

  late DoctorModel _doctor;
  DoctorModel get doctor => _doctor;

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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setDoctor(DoctorModel doctor) {
    _doctor = doctor;
    notifyListeners();
  }

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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  ImageProvider? refineImagePath(String image_url) {
    String? fixedImagePath;
    ImageProvider? avatarImage;
    if (image_url.isNotEmpty) {
      fixedImagePath = image_url.replaceAll(r'\', '/');
    }
    if (fixedImagePath != null && fixedImagePath.isNotEmpty) {
      final fullUrl =
          ApiConstants.imageBaseUrl.endsWith('/')
              ? ApiConstants.imageBaseUrl.substring(
                0,
                ApiConstants.imageBaseUrl.length - 1,
              )
              : ApiConstants.imageBaseUrl;

      final cleanedPath =
          fixedImagePath.startsWith('/')
              ? fixedImagePath.substring(1)
              : fixedImagePath;

      final imageUrl = '$fullUrl/$cleanedPath';

      avatarImage = NetworkImage(imageUrl);
    }
    return avatarImage;
  }

  Future<void> getHomeData() async {
    try {
      final headerData = await _service.getHomeHeaderData();
      userName = headerData['name']!;
      greeting = headerData['greeting']!;

      await loadAppointments();
      await loadTasks();
      await loadInvoices();
      await fetchDoctorProfile();
      notifyListeners();
    } catch (e) {
      print('❌ Error in getHomeData: $e');
    }
  }

  Future<void> fetchDoctorProfile() async {
    _setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');
      if (userJson == null) return;

      final userMap = jsonDecode(userJson);
      final doctorId = userMap['id'];

      final doctorData = await _service.fetchDoctor(doctorId);
      print(doctorData);
      if (doctorData != null) {
        doctorEmail = doctorData.email ?? '';
        profileImage = doctorData.imagePath ?? '';

        setDoctor(doctorData);
        _setLoading(false);
      } else {
        print("❌ Doctor data not found");
        _setLoading(false);
      }
    } catch (e) {
      print("❌ Error in fetchDoctorProfile: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateDoctor(DoctorModel doctor, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');
      if (userJson == null) return;

      final userMap = jsonDecode(userJson);
      doctor.doctorUserId = userMap['id'];

      final result = await _service.updateDoctor(doctor);

      if (result['success']) {
        ToastHelper.showSuccess(context, result['message']);
        await fetchDoctorProfile();
        Navigator.pop(context);
      } else {
        ToastHelper.showError(context, result['message']);
        print("❌ Failed to update doctor: ${result['message']}");
      }
    } catch (e) {
      print("❌ Error in updateDoctor: $e");
      ToastHelper.showError(context, 'Failed to update doctor profile');
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
          arguments: {'notes': _notes, 'patientId': note.patientId},
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
          arguments: {'notes': _notes, 'patientId': note.patientId},
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

  Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 30) {
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    // For platforms other than Android or if all above conditions fail
    return false;
  }

  Future<void> downloadInvoice(
    BuildContext context,
    InvoiceModel invoiceData,
  ) async {
    try {
      final status = await requestStoragePermission();
      if (!status) {
        ToastHelper.showError(context, 'Storage permission denied.');
        return;
      }

      final Uint8List pdfBytes = await _generateInvoicePdf(invoiceData);
      // Let the user choose a directory to save the PDF
      final directory = await FilePicker.platform.getDirectoryPath();

      // Check if directory is selected
      if (directory == null) {
        ToastHelper.showError(context, 'No directory selected.');
        return;
      }

      // Create the file path and save the PDF
      final file = File('$directory/invoice_${invoiceData.invoiceNumber}.pdf');
      await file.writeAsBytes(pdfBytes);

      ToastHelper.showSuccess(context, 'Invoice saved to selected directory');
    } catch (e) {
      ToastHelper.showError(context, 'Failed to save invoice: $e');
    }
  }

  Future<void> printInvoice(
    BuildContext context,
    InvoiceModel invoiceData,
  ) async {
    try {
      final Uint8List pdfBytes = await _generateInvoicePdf(invoiceData);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );

      ToastHelper.showSuccess(context, 'Invoice Printed Successfully');
    } catch (e) {
      ToastHelper.showError(context, 'Error While Printing $e');
    }
  }

  Future<void> shareInvoice(
    BuildContext context,
    InvoiceModel invoiceData,
  ) async {
    try {
      // 1. Generate the PDF
      final Uint8List pdfBytes = await _generateInvoicePdf(invoiceData);

      // 2. Get a temporary directory to save the file
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/invoice_${invoiceData.invoiceNumber}.pdf';
      final File pdfFile = File(filePath);

      // 3. Write the PDF bytes to the file
      await pdfFile.writeAsBytes(pdfBytes);

      // 4. Share the PDF file using share_plus
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Invoice ${invoiceData.invoiceNumber}',
        text:
            'Please find attached your invoice for ${invoiceData.patientName}.',
      );

      ToastHelper.showSuccess(context, 'Invoice Shared Successfully!');
    } catch (e) {
      // It's good practice to log the error for debugging
      print('Error while sharing invoice: $e');
      ToastHelper.showError(context, 'Error while sharing invoice: $e');
    }
  }

  void deleteInvoice(BuildContext context, String? invoiceNo) {
    if (invoiceNo == null) {
      ToastHelper.showError(context, 'Invoice Number is null.');
      return;
    }

    showCustomDialog(
      context: context,
      title: 'Confirm Deletion',
      message: 'Are you sure you want to delete invoice $invoiceNo ?',
      cancelButtonText: 'Cancel',
      confirmButtonText: 'Delete',
      cancelButtonColor: AppColors.errorColor,
      cancelButtonTextColor: AppColors.backgroundColor,
      confirmButtonColor: AppColors.successColor,
      confirmButtonTextColor: AppColors.backgroundColor,
      onCancel: () {
        Navigator.of(context).pop();
      },
      onConfirm: () async {
        final response = await _service.deleteInvoice(invoiceNo);
        if (response['success']) {
          ToastHelper.showSuccess(context, response['message']);
          await loadInvoices();
        } else {
          ToastHelper.showError(context, response['message']);
        }
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      isFlip: true, // You can set isFlip to true for 3D rotation effect
    );
  }

  void markAsPaid(BuildContext context, String? invoiceNo) {
    if (invoiceNo != null) {
      showCustomDialog(
        context: context,
        title: 'Confirm Updation',
        message: 'Are you sure you want to update invoice $invoiceNo ?',
        cancelButtonText: 'Cancel',
        confirmButtonText: 'Update',
        cancelButtonColor: AppColors.errorColor,
        cancelButtonTextColor: AppColors.backgroundColor,
        confirmButtonColor: AppColors.successColor,
        confirmButtonTextColor: AppColors.backgroundColor,
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () async {
          final response = await _service.markAsPaid(invoiceNo);
          if (response['success']) {
            ToastHelper.showSuccess(context, response['message']);
            await loadInvoices();
          } else {
            ToastHelper.showError(context, response['message']);
          }
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        isFlip: true,
      );
    } else {
      ToastHelper.showError(context, 'Invoice Number is null.');
      return;
    }
  }

  Future<Uint8List> _generateInvoicePdf(InvoiceModel invoiceData) async {
    final pdf = pw.Document();

    // Define some styles for the PDF
    final pw.TextStyle headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blue800,
    );
    final pw.TextStyle sectionHeaderStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.grey800,
    );
    final pw.TextStyle labelStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );
    final pw.TextStyle valueStyle = pw.TextStyle(color: PdfColors.grey700);
    final pw.TextStyle totalLabelStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );
    final pw.TextStyle totalValueStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.green700,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(child: pw.Text('INVOICE', style: headerStyle)),
              pw.SizedBox(height: 20),

              // Invoice Details
              pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Invoice Details', style: sectionHeaderStyle),
                    pw.Divider(),
                    _buildDetailRow(
                      labelStyle,
                      valueStyle,
                      'Invoice No:',
                      invoiceData.invoiceNumber ?? '',
                    ),
                    _buildDetailRow(
                      labelStyle,
                      valueStyle,
                      'Patient Name:',
                      invoiceData.patientName ?? '',
                    ),
                    _buildDetailRow(
                      labelStyle,
                      valueStyle,
                      'Status:',
                      invoiceData.paymentStatus ?? '',
                    ),
                    _buildDetailRow(
                      labelStyle,
                      valueStyle,
                      'Amount Due:',
                      '\$${invoiceData.amountDue?.toStringAsFixed(2)}',
                    ),
                    _buildDetailRow(
                      labelStyle,
                      valueStyle,
                      'Issued Date:',
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(invoiceData.dueDate ?? DateTime.now()),
                    ),
                    _buildDetailRow(
                      labelStyle,
                      valueStyle,
                      'Due Date:',
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(invoiceData.dueDate ?? DateTime.now()),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Summary
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 1),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Summary', style: sectionHeaderStyle),
                    pw.Divider(),
                    _buildSummaryRow(
                      labelStyle,
                      valueStyle,
                      'Sub Total:',
                      '\$${invoiceData.amountDue?.toStringAsFixed(2)}',
                    ),
                    _buildSummaryRow(
                      labelStyle,
                      valueStyle,
                      'Tax:',
                      '\$${(0.0).toStringAsFixed(2)}',
                    ),
                    _buildSummaryRow(
                      labelStyle,
                      valueStyle,
                      'Discount:',
                      '-\$${(0.0).toStringAsFixed(2)}',
                    ),
                    pw.Divider(thickness: 2),
                    _buildSummaryRow(
                      totalLabelStyle,
                      totalValueStyle,
                      'Grand Total:',
                      '\$${invoiceData.amountDue?.toStringAsFixed(2)}',
                    ),
                    _buildSummaryRow(
                      labelStyle,
                      valueStyle,
                      'Amount Paid:',
                      '\$${invoiceData.amountDue?.toStringAsFixed(2)}',
                    ),
                    _buildSummaryRow(
                      labelStyle,
                      valueStyle,
                      'Remaining Amount:',
                      '\$${(0.0).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Text(
                  'Thank you for your business!',
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // Helper function to build a detail row in the PDF
  pw.Widget _buildDetailRow(
    pw.TextStyle labelStyle,
    pw.TextStyle valueStyle,
    String label,
    String value,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: labelStyle),
          pw.Text(value, style: valueStyle),
        ],
      ),
    );
  }

  // Helper function to build a summary row in the PDF
  pw.Widget _buildSummaryRow(
    pw.TextStyle labelStyle,
    pw.TextStyle valueStyle,
    String label,
    String value,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: labelStyle),
          pw.Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
