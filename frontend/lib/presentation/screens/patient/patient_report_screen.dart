import 'package:dio/dio.dart';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/report_model.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PatientReportScreen extends StatefulWidget {
  final int patientId;
  final String patientEmail;
  final String patientName;

  const PatientReportScreen({
    super.key,
    required this.patientId,
    required this.patientEmail,
    required this.patientName,
  });

  @override
  State<PatientReportScreen> createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  final TextEditingController _searchController = TextEditingController();

  late DoctorProvider doctorProvider;
  late List<ReportModel> reports;

  @override
  void initState() {
    super.initState();
    doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    doctorProvider.fetchReports();
    reports =
        doctorProvider.reports
            .where((report) => report.patientId == widget.patientId)
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reports',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchBarWithAddButton(
            controller: _searchController,
            onChanged: (value) {},
            onAddPressed: () {
              Navigator.pushNamed(
                context,
                Routes.addNewReportScreen,
                arguments: {
                  'patientId': widget.patientId,
                  'patientEmail': widget.patientEmail,
                  'patientName': widget.patientName,
                },
              );
            },
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Text(
                  // This text assumes a single patient context for reports
                  '[patient’s name] medical reports.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reports',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.description_outlined, color: Colors.grey[600]),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 10),
          const SizedBox(height: 24),
          Expanded(
            child:
                reports.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.do_disturb_alt_rounded,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          Text(
                            'No reports yet.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : SinglePatientReportTable(reports: reports),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class SinglePatientReportTable extends StatelessWidget {
  final List<ReportModel> reports;

  const SinglePatientReportTable({Key? key, required this.reports})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        border: TableBorder.all(color: AppColors.borderColor, width: 0.5),
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2.5),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: AppColors.tableColor),
            children: [
              _buildTableCell(text: 'Report\nname', isHeader: true),
              _buildTableCell(text: 'Type', isHeader: true),
              _buildTableCell(text: 'Date', isHeader: true),
              _buildTableCell(text: 'Time', isHeader: true),
              _buildTableCell(text: 'Visit', isHeader: true),
            ],
          ),
          // Data Rows
          ...reports.asMap().entries.map((entry) {
            ReportModel report = entry.value;
            return TableRow(
              decoration: BoxDecoration(color: AppColors.tableColor),
              children: [
                _buildTableCell(text: report.reportName),
                _buildTableCell(text: report.reportType),
                _buildTableCell(text: report.reportDate.split('T').first),
                _buildTableCell(text: report.reportTime),
                _buildTableCell(
                  text: report.fileUrl,
                  icon: Icons.link,
                  isAction: true,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableCell({
    String? text,
    IconData? icon,
    bool isHeader = false,
    bool isAction = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      child:
          icon != null
              ? IconButton(
                icon: Icon(icon, color: AppColors.primaryColor, size: 25),
                onPressed: () async {
                  if (text != null && text.isNotEmpty) {
                    final fixedFilePath = text.replaceAll(r'\', '/');
                    final fullUrl =
                        '${ApiConstants.imageBaseUrl}$fixedFilePath';
                    final fileName = fullUrl.split('/').last;

                    print('📂 Downloading and opening: $fullUrl');

                    try {
                      final dir = await getTemporaryDirectory();
                      final filePath = '${dir.path}/$fileName';

                      await Dio().download(fullUrl, filePath);

                      final result = await OpenFilex.open(filePath);
                      print('✅ Opened: ${result.message}');
                    } catch (e) {
                      print('❌ Error opening file: $e');
                    }
                  }
                },
              )
              : Text(
                text!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: isAction ? TextAlign.center : TextAlign.left,
              ),
    );
  }
}
