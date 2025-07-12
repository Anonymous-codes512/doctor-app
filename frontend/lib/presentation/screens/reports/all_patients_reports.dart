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

class AllPatientsReportsScreen extends StatefulWidget {
  AllPatientsReportsScreen({super.key});

  @override
  State<AllPatientsReportsScreen> createState() =>
      _AllPatientsReportsScreenState();
}

class _AllPatientsReportsScreenState extends State<AllPatientsReportsScreen> {
  final List<Map<String, dynamic>> patients = [
    {
      "name": "Ali Raza",
      "reports": [
        {
          "name": "Medical Prescription",
          "type": "PDF",
          "date": "12/01/25",
          "time": "09:00 am",
        },
        {
          "name": "MRI report",
          "type": "PDF",
          "date": "12/01/25",
          "time": "09:00 am",
        },
        {
          "name": "Blood Test Results",
          "type": "Image",
          "date": "12/01/25",
          "time": "09:00 am",
        },
        {
          "name": "X-Ray",
          "type": "Image",
          "date": "12/01/25",
          "time": "09:00 am",
        },
        {"name": "CBP", "type": "PDF", "date": "12/01/25", "time": "09:00 am"},
      ],
    },
    {
      "name": "Mehak Khan",
      "reports": [
        {
          "name": "Medical Prescription",
          "type": "PDF",
          "date": "12/01/25",
          "time": "09:00 am",
        },
        {
          "name": "MRI report",
          "type": "PDF",
          "date": "12/01/25",
          "time": "09:00 am",
        },
        {
          "name": "Blood Test Results",
          "type": "Image",
          "date": "12/01/25",
          "time": "09:00 am",
        },
        {
          "name": "X-Ray",
          "type": "Image",
          "date": "12/01/25",
          "time": "09:00 am",
        },
        {"name": "CBP", "type": "PDF", "date": "12/01/25", "time": "09:00 am"},
      ],
    },
  ];

  late List<ReportModel> reportModel;
  late DoctorProvider doctorProvider;

  @override
  void initState() {
    super.initState();

    doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    doctorProvider.fetchReports();
    reportModel = doctorProvider.reports;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: Text(
          'Reports',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWithAddButton(
            controller: TextEditingController(),
            onChanged: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            onAddPressed: () {
              Navigator.pushNamed(context, Routes.addNewReportScreen);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),

          // Reports Header
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Reports',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Icon(Icons.qr_code_scanner, color: Colors.grey[600]),
              ],
            ),
          ),

          Expanded(
            child: Consumer<DoctorProvider>(
              builder: (context, provider, _) {
                final reports = provider.reports;
                if (reports.isEmpty) {
                  return Center(child: Text('No reports found.'));
                }
                final Map<String, List<ReportModel>> grouped = {};
                for (var report in reports) {
                  final key = '${report.patientName} (${report.patientEmail})';
                  grouped.putIfAbsent(key, () => []).add(report);
                }
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: grouped.keys.length,
                  itemBuilder: (context, index) {
                    final patientName = grouped.keys.elementAt(index);
                    final patientReports = grouped[patientName]!;

                    return PatientReportCard(
                      patientName: patientName,
                      reports: patientReports,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> searchHistory = ['something', 'something something'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Reports',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Search History
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey[600], size: 20),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            searchHistory[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              searchHistory.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PatientReportCard extends StatelessWidget {
  final String patientName;
  final List<ReportModel> reports;

  const PatientReportCard({
    Key? key,
    required this.patientName,
    required this.reports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
            child: Text(
              patientName.split('(')[0].trim(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),

          // Reports Table
          Table(
            border: TableBorder.all(color: AppColors.borderColor, width: 0.5),
            children: [
              TableRow(
                decoration: BoxDecoration(color: AppColors.tableColor),
                children: [
                  _buildTableCell(text: 'Report\nName', isHeader: true),
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
                      icon: Icons.link,
                      text: report.fileUrl,
                      isAction: true,
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
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
