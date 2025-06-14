import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:flutter/material.dart';

class PatientReportScreen extends StatefulWidget {
  const PatientReportScreen({Key? key}) : super(key: key);

  @override
  State<PatientReportScreen> createState() => _PatientReportScreenState(); // Changed state class name
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  // Changed state class name
  final TextEditingController _searchController = TextEditingController();

  // This list now represents individual reports, not "patients" with reports.
  final List<Map<String, String>> _allReports = [
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
    {"name": "X-Ray", "type": "Image", "date": "12/01/25", "time": "09:00 am"},
    {"name": "CBP", "type": "PDF", "date": "12/01/25", "time": "09:00 am"},
    {
      "name": "Blood Sugar Test",
      "type": "PDF",
      "date": "12/01/25",
      "time": "09:00 am",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reports',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWithAddButton(
            controller: _searchController,
            onChanged: (value) {},
            onAddPressed: () {},
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
                _allReports.isEmpty
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
                    : SinglePatientReportTable(reports: _allReports),
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

// Renamed and refactored PatientReportCard to SinglePatientReportTable
// because it now displays a table of reports, not a card for a single patient.
class SinglePatientReportTable extends StatelessWidget {
  final List<Map<String, String>> reports; // Now expects a list of reports

  const SinglePatientReportTable({Key? key, required this.reports})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We remove the outer Container with padding and box shadow
    // as it's better to manage padding/margin within the ListView.builder itself,
    // or wrap this entire table in a single container.
    // Given the previous setup, we'll just have the Table directly.
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ), // Apply padding here
      child: Table(
        border: TableBorder.all(color: AppColors.borderColor, width: 0.5),
        columnWidths: const {
          0: FlexColumnWidth(3), // Report Name
          1: FlexColumnWidth(1.5), // Type
          2: FlexColumnWidth(2), // Date
          3: FlexColumnWidth(2), // Time
          4: FlexColumnWidth(1.5), // Actions
        },
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(
              // No top radius here if TableBorder.all is used,
              // as the border will be drawn on all sides.
              // If you want rounded corners for the table itself,
              // you'd typically wrap the Table in a Container with borderRadius.
              color: AppColors.tableColor,
            ),
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
            Map<String, String> report = entry.value; // Corrected type here
            return TableRow(
              // Alternating row colors could be added here if desired
              decoration: BoxDecoration(
                color: AppColors.tableColor, // Example alternating row color
              ),
              children: [
                _buildTableCell(
                  report['name']!,
                ), // Use '!' since we know keys exist
                _buildTableCell(report['type']!),
                _buildTableCell(report['date']!),
                _buildTableCell(report['time']!),
                _buildTableCell('⋮', isAction: true),
              ],
            );
          }),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ), // Adjust padding for cells
      alignment:
          isAction
              ? Alignment.center
              : Alignment.centerLeft, // Align action icon centrally
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
          color: Colors.black,
        ),
        // No explicit TextAlign for non-action cells, let alignment handle it.
      ),
    );
  }
}
