import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  final int patientId;
  const AppointmentsScreen({super.key, required this.patientId});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Store all appointments for this patient fetched from Provider
  List<AppointmentModel> _allAppointments = [];

  // Filtered list of appointments to display (still AppointmentModel for easier filtering)
  List<AppointmentModel> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();

    final appointments =
        Provider.of<DoctorProvider>(context, listen: false).appointments;

    // Filter appointments for the given patientId
    _allAppointments =
        appointments
            .where((appt) => appt.patientId == widget.patientId)
            .toList();

    _filteredAppointments = List.from(_allAppointments);

    print('Patient ID: ${widget.patientId}, Appointments: $_allAppointments');
  }

  void _filterAppointments(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAppointments = List.from(_allAppointments);
      } else {
        final lowerQuery = query.toLowerCase();

        _filteredAppointments =
            _allAppointments.where((appt) {
              // Check multiple fields for the search query
              return appt.patientName.toLowerCase().contains(lowerQuery) ||
                  appt.appointmentReason!.toLowerCase().contains(lowerQuery) ||
                  appt.appointmentMode!.toLowerCase().contains(lowerQuery) ||
                  appt.paymentMode!.toLowerCase().contains(lowerQuery) ||
                  appt.description.toLowerCase().contains(lowerQuery) == true ||
                  appt.fee.toString().contains(lowerQuery) ||
                  appt.duration.toString().contains(lowerQuery) ||
                  appt.appointmentDate.toString().contains(lowerQuery) ||
                  appt.appointmentTime.toString().contains(lowerQuery);
            }).toList();
      }
    });
  }

  Widget _buildAppointmentsTable() {
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
                // Format date & time nicely
                final timeStr =
                    '${appointment.appointmentTime.hour.toString().padLeft(2, '0')}:${appointment.appointmentTime.minute.toString().padLeft(2, '0')}';

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
                        // Date and ID (use appointment id if available)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Date: ${appointment.appointmentDate.day.toString().padLeft(2, '0')}-${appointment.appointmentDate.month.toString().padLeft(2, '0')}-${appointment.appointmentDate.year.toString().substring(2)}',
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
                                children: [
                                  const Icon(Icons.credit_card_outlined),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'ID: ${appointment.patientId}',
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
                        // Time and Mode
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_outlined),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Time: $timeStr',
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
                                children: [
                                  const Icon(Icons.language_outlined),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Mode: ${appointment.appointmentMode}',
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
                        // const SizedBox(height: 16),
                        // Reason & Fee & Payment Mode
                        // Text(
                        //   'Reason: ${appointment.appointmentReason}',
                        //   style: const TextStyle(fontWeight: FontWeight.w500),
                        // ),
                        // Text(
                        //   'Fee: ${appointment.fee}',
                        //   style: const TextStyle(fontWeight: FontWeight.w500),
                        // ),
                        // Text(
                        //   'Payment Mode: ${appointment.paymentMode}',
                        //   style: const TextStyle(fontWeight: FontWeight.w500),
                        // ),
                        // if (appointment.description != null &&
                        //     appointment.description!.isNotEmpty) ...[
                        //   const SizedBox(height: 8),
                        //   Text(
                        //     'Description: ${appointment.description}',
                        //     style: const TextStyle(fontStyle: FontStyle.italic),
                        //   ),
                        // ],
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
        title: const Text(
          'Appointments',
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
            onChanged: _filterAppointments,
            // onAddPressed callback mein
            onAddPressed: () {
              Navigator.pushNamed(
                context,
                Routes.addNewAppointmentsScreen,
                arguments: widget.patientId,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Text(
                  'This is a list of all previous and current appointments for the patient.',
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
          Expanded(child: _buildAppointmentsTable()),
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
