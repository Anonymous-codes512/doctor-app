import 'dart:io';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/report_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewReportScreen extends StatefulWidget {
  const AddNewReportScreen({super.key});

  @override
  State<AddNewReportScreen> createState() => _AddNewReportScreenState();
}

class _AddNewReportScreenState extends State<AddNewReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController patientNameCtrl = TextEditingController();
  final TextEditingController patientEmailCtrl = TextEditingController();
  final TextEditingController reportNameCtrl = TextEditingController();
  final TextEditingController paymentAmountCtrl = TextEditingController();

  File? selectedFile;
  String selectedType = 'PDF';
  String paymentStatus = 'Paid';
  String paymentMethod = 'Cash';

  final List<String> types = ['PDF', 'Image'];
  final List<String> paymentStatusList = ['Paid', 'Unpaid'];
  final List<String> paymentMethodList = ['Cash', 'Card', 'Online'];

  void pickFile() async {
    FilePickerResult? result;

    // Pick files based on selected type
    if (selectedType == 'PDF') {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
    } else if (selectedType == 'Image') {
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
    }

    if (result != null) {
      setState(() {
        selectedFile = File(result!.files.single.path!);
      });
    }
  }

  void submitReport() {
    if (_formKey.currentState!.validate() && selectedFile != null) {
      final reportModel = ReportModel(
        patientName: patientNameCtrl.text.trim(),
        patientEmail: patientEmailCtrl.text.trim(),
        reportName: reportNameCtrl.text.trim(),
        reportType: selectedType,
        reportDate: DateTime.now().toIso8601String(),
        reportTime: TimeOfDay.now().format(context),
        fileUrl: '',
        paymentAmount: double.parse(paymentAmountCtrl.text),
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
      );
      Provider.of<DoctorProvider>(
        context,
        listen: false,
      ).addReport(reportModel, selectedFile!, context);
    } else {
      ToastHelper.showError(context, 'Please fill all fields & pick a file');
    }
  }

  String get fileName {
    if (selectedFile == null) return '';
    return selectedFile!.path.split('/').last;
  }

  @override
  void dispose() {
    patientNameCtrl.dispose();
    patientEmailCtrl.dispose();
    reportNameCtrl.dispose();
    paymentAmountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: const Text(
          'Add New Report',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LabeledTextField(
                label: 'Patient Name',
                hintText: 'Enter patient name',
                controller: patientNameCtrl,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              LabeledTextField(
                label: 'Patient Email',
                hintText: 'Enter patient email',
                controller: patientEmailCtrl,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  final emailRegex = RegExp(
                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                  );
                  if (!emailRegex.hasMatch(val)) return 'Enter valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              LabeledTextField(
                label: 'Report Name',
                hintText: 'Enter report name',
                controller: reportNameCtrl,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              LabeledDropdown(
                label: 'Report Type',
                items: types,
                selectedValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                    // Clear selected file when type changes
                    selectedFile = null;
                  });
                },
              ),

              const SizedBox(height: 20),
              GestureDetector(
                onTap: pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        selectedFile != null
                            ? Colors.green[50]
                            : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          selectedFile != null
                              ? Colors.green
                              : Colors.grey[300]!,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selectedFile != null
                            ? Icons.check_circle
                            : Icons.upload_file,
                        size: 40,
                        color:
                            selectedFile != null
                                ? Colors.green
                                : Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedFile != null
                            ? 'File Selected'
                            : 'Tap to Select ${selectedType}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              selectedFile != null
                                  ? Colors.green[700]
                                  : Colors.grey[700],
                        ),
                      ),
                      if (selectedFile != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                fileName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              LabeledTextField(
                label: 'Payment Amount',
                hintText: 'Enter payment amount',
                controller: paymentAmountCtrl,
                keyboardType: TextInputType.number,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              LabeledDropdown(
                label: 'Payment Status',
                items: paymentStatusList,
                selectedValue: paymentStatus,
                onChanged: (value) {
                  setState(() {
                    paymentStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 12),

              LabeledDropdown(
                label: 'Payment Method',
                items: paymentMethodList,
                selectedValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              PrimaryCustomButton(
                text: 'Submit Report',
                onPressed: submitReport,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
