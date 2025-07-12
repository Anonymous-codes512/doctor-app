import 'package:dio/dio.dart';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/data/models/report_model.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CorrespondenceScreen extends StatefulWidget {
  final int patientId;
  CorrespondenceScreen({super.key, required this.patientId});

  @override
  State<CorrespondenceScreen> createState() => _CorrespondenceScreenState();
}

class _CorrespondenceScreenState extends State<CorrespondenceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedTab = 'Files';

  // Dummy data for Communications
  final List<Map<String, String>> _communications = [
    {
      'doctor': 'Dr. Smith',
      'message': 'Please review lab results and follow up',
      'date': '1 June 25',
      'time': '11:20 pm',
    },
    {
      'doctor': 'Dr. Smith',
      'message': 'Please review lab results and follow up',
      'date': '1 June 25',
      'time': '11:20 pm',
    },
    {
      'doctor': 'Dr. Smith',
      'message': 'Please review lab results and follow up',
      'date': '1 June 25',
      'time': '11:20 pm',
    },
    {
      'doctor': 'Dr. Smith',
      'message': 'Please review lab results and follow up',
      'date': '1 June 25',
      'time': '11:20 pm',
    },
  ];

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
    setState(() {});
  }

  void _onTabChanged(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        Expanded(
          child: _buildTab(
            'Files',
            selectedTab == 'Files',
            () => _onTabChanged('Files'),
          ),
        ),
        Expanded(
          child: _buildTab(
            'Communications',
            selectedTab == 'Communications',
            () => _onTabChanged('Communications'),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center the text and underline
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  isSelected
                      ? AppColors.primaryColor
                      : AppColors.secondaryTextColor, // Centralized color
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 2,
            width:
                double
                    .infinity, // Make the underline span the full width of the tab
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildFilesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: AppColors.primaryColor, width: 1.0),
            outside:
                BorderSide
                    .none, // No outer border for cells, handled by container
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: AppColors.tableColor),
              children: [
                _buildTableCell(text: 'File Name', isHeader: true),
                _buildTableCell(text: 'Type', isHeader: true),
                _buildTableCell(text: 'Date', isHeader: true),
                _buildTableCell(text: 'Time', isHeader: true),
                _buildTableCell(text: 'Visit', isHeader: true),
              ],
            ),
            ...reports.map((report) {
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
      ),
    );
  }

  Widget _buildCommunicationsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children:
              _communications.map((comm) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Doctor Column
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.tableColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              comm['doctor']!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // Message Column
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.tableColor,
                              border: Border(
                                left: BorderSide(color: AppColors.primaryColor),
                                right: BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(comm['message']!),
                          ),
                        ),
                        // Date & Time Column
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.tableColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(comm['date']!),
                                Text(comm['time']!),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  TableCell _buildTableCell({
    Color? backgroundColor,
    String? text,
    IconData? icon,
    bool isHeader = false,
    bool isAction = false,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        color: backgroundColor,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Correspondence',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 18),
                Text(
                  'From here, you can access, manage, and securely store patient files and communications.',
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
                      'Correspondence',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.folder_sharp, color: Colors.grey[600]),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 10),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: [Expanded(child: _buildTabBar())]),
          ),

          // Main content area - conditionally display tables
          Expanded(
            child:
                selectedTab == 'Files'
                    ? _buildFilesTable()
                    : _buildCommunicationsTable(),
          ),
          const SizedBox(height: 24),
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
