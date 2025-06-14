import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // The original full list of appointments
  final List<Map<String, String>> _allAppointments = [
    {'Date': '1 June 24', 'Id': '231', 'Time': '11:20 pm', 'Mode': 'Online'},
    {'Date': '3 July 24', 'Id': '232', 'Time': '1:20 pm', 'Mode': 'Physical'},
    {'Date': '15 Sep 24', 'Id': '233', 'Time': '10:15 pm', 'Mode': 'Online'},
    {'Date': '21 Nov 24', 'Id': '234', 'Time': '8:00 pm', 'Mode': 'Online'},
    {'Date': '20 Jan 25', 'Id': '235', 'Time': '6:30 pm', 'Mode': 'Physical'},
    {'Date': '12 June 25', 'Id': '236', 'Time': '5:00 am', 'Mode': 'Online'},
    {'Date': '1 July 25', 'Id': '237', 'Time': '9:00 am', 'Mode': 'Physical'},
    {'Date': '10 July 25', 'Id': '238', 'Time': '3:00 pm', 'Mode': 'Online'},
    {'Date': '18 July 25', 'Id': '239', 'Time': '7:00 pm', 'Mode': 'Physical'},
    {'Date': '25 July 25', 'Id': '240', 'Time': '10:00 am', 'Mode': 'Online'},
    {'Date': '1 Aug 25', 'Id': '241', 'Time': '1:00 pm', 'Mode': 'Physical'},
    {'Date': '8 Aug 25', 'Id': '242', 'Time': '4:00 pm', 'Mode': 'Online'},
  ];

  // The list that will be displayed, filtered based on search query
  List<Map<String, String>> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all appointments when the screen loads
    _filteredAppointments = List.from(_allAppointments);
  }

  void _filterAppointments(String query) {
    setState(() {
      if (query.isEmpty) {
        // If query is empty, show all appointments
        _filteredAppointments = List.from(_allAppointments);
      } else {
        // Filter appointments based on query (case-insensitive)
        _filteredAppointments =
            _allAppointments.where((appointment) {
              final date = appointment['Date']?.toLowerCase() ?? '';
              final id = appointment['Id']?.toLowerCase() ?? '';
              final time = appointment['Time']?.toLowerCase() ?? '';
              final mode = appointment['Mode']?.toLowerCase() ?? '';
              final searchQuery = query.toLowerCase();

              return date.contains(searchQuery) ||
                  id.contains(searchQuery) ||
                  time.contains(searchQuery) ||
                  mode.contains(searchQuery);
            }).toList();
      }
    });
  }

  Widget _buildAppointmentsTable() {
    // Check if there are any appointments to display
    if (_filteredAppointments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No appointments found.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children:
              _filteredAppointments.map((appointment) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.calendar_today_outlined),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Date: ${appointment['Date'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.credit_card_outlined),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'ID: ${appointment['Id'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.access_time_outlined),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Time: ${appointment['Time'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.language_outlined),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Mode: ${appointment['Mode'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
          'Appointments',
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
            onChanged:
                _filterAppointments, // This will now trigger the actual filtering
            onAddPressed: () {
              Navigator.pushNamed(context, Routes.addNewAppointmentsScreen);
            },
            onTap: () {
              // Handle tap if needed, e.g., show a search overlay
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Text(
                  'This is a list of all [patient’s name] previous and current appointments.',
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
                      'Appointments',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.calendar_today_rounded, color: Colors.grey[600]),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 10),
          const SizedBox(height: 24),
          Expanded(
            // Ensures the scrollable table takes remaining space
            child: _buildAppointmentsTable(),
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
