import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:flutter/material.dart';

class AllPatientsReportsScreen extends StatelessWidget {
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

  AllPatientsReportsScreen({super.key});

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

          // Reports List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return PatientReportCard(patient: patients[index]);
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
  final Map<String, dynamic> patient;

  const PatientReportCard({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> reports = patient['reports'];

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
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              patient['name'],
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
              // Header Row
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),

                  color: AppColors.tableColor,
                ), // Light purple-blue header
                children: [
                  _buildTableCell('Report\nname', isHeader: true),
                  _buildTableCell('Type', isHeader: true),
                  _buildTableCell('Date', isHeader: true),
                  _buildTableCell('Time', isHeader: true),
                  _buildTableCell('Actions', isHeader: true),
                ],
              ),
              // Data Rows
              ...reports.asMap().entries.map((entry) {
                Map<String, dynamic> report = entry.value;
                return TableRow(
                  decoration: BoxDecoration(color: AppColors.tableColor),
                  children: [
                    _buildTableCell(report['name']),
                    _buildTableCell(report['type']),
                    _buildTableCell(report['date']),
                    _buildTableCell(report['time']),
                    _buildTableCell('⋮', isAction: true),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    bool isAction = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Text(
        text,
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
