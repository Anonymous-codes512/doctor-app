import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:flutter/material.dart';

class CorrespondenceScreen extends StatefulWidget {
  const CorrespondenceScreen({Key? key}) : super(key: key);

  @override
  State<CorrespondenceScreen> createState() => _CorrespondenceScreenState();
}

class _CorrespondenceScreenState extends State<CorrespondenceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedTab = 'Files'; // Initial selected tab

  // Dummy data for Files
  final List<Map<String, String>> _files = [
    {
      'fileName': 'Medical Prescription',
      'type': 'PDF',
      'date': '12/01/25',
      'time': '09:00 am',
    },
    {
      'fileName': 'Medical Prescription',
      'type': 'PDF',
      'date': '12/01/25',
      'time': '09:00 am',
    },
    {
      'fileName': 'Blood Test Results',
      'type': 'image',
      'date': '12/01/25',
      'time': '09:00 am',
    },
    {
      'fileName': 'Blood Test Results',
      'type': 'image',
      'date': '12/01/25',
      'time': '09:00 am',
    },
    {
      'fileName': 'Doctor\'s Notes',
      'type': 'PDF',
      'date': '12/01/25',
      'time': '09:00 am',
    },
    {
      'fileName': 'Doctor\'s Notes',
      'type': 'PDF',
      'date': '12/01/25',
      'time': '09:00 am',
    },
    {
      'fileName': 'Doctor\'s Notes',
      'type': 'PDF',
      'date': '12/01/25',
      'time': '09:00 am',
    },
    {
      'fileName': 'Doctor\'s Notes',
      'type': 'PDF',
      'date': '12/01/25',
      'time': '09:00 am',
    },
  ];

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

  void _filterCorrespondence(String query) {
    setState(() {
      // In a real application, you would filter the lists here based on the query.
      // For now, we just trigger a rebuild.
    });
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
                _buildTableHeader('File name'),
                _buildTableHeader('Type'),
                _buildTableHeader('Date'),
                _buildTableHeader('Time'),
                _buildTableHeader('Actions'),
              ],
            ),
            ..._files.map((file) {
              return TableRow(
                decoration: BoxDecoration(color: AppColors.tableColor),
                children: [
                  _buildTableCell(file['fileName']!),
                  _buildTableCell(file['type']!),
                  _buildTableCell(file['date']!),
                  _buildTableCell(file['time']!),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                        onPressed: () {
                          // Handle actions button press
                        },
                      ),
                    ),
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

  TableCell _buildTableHeader(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  TableCell _buildTableCell(String text, {Color? backgroundColor}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        color: backgroundColor, // Set the background color here
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text, textAlign: TextAlign.center),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Correspondence',
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
          // Search bar
          SearchBarWithAddButton(
            controller: _searchController,
            onChanged: _filterCorrespondence,
            onAddPressed: () {
              Navigator.pushNamed(context, Routes.newCorrespondenceScreen);
            },
            onTap: () {
              // Handle tap if needed, e.g., show a search overlay
            },
          ),

          // Title with sound icon
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
