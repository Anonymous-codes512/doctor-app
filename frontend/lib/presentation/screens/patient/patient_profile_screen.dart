import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/menu_list_item.dart';
import 'package:doctor_app/presentation/widgets/patient_header_card.dart';
import 'package:flutter/material.dart';

class PatientProfileScreen extends StatefulWidget {
  final Map<String, dynamic> patient;
  const PatientProfileScreen({Key? key, required this.patient})
    : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Patient Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PatientHeaderCard(
                name: widget.patient['name'] ?? 'N/A',
                age: '${widget.patient['age']?.toString()} Years',
                condition: widget.patient['condition'] ?? 'Allergic',
                phone: widget.patient['phone'] ?? '9456379036',
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.phone, const Color(0xFF4A6CF7), () {}),

                _actionButton(
                  Icons.chat_bubble_outline,
                  const Color(0xFF10B981),
                  () => {},
                ),

                _actionButton(
                  Icons.video_call,
                  const Color(0xFFF59E0B),
                  () => () {},
                ),
                _actionButton(
                  Icons.email_outlined,
                  const Color(0xFFEF4444),
                  () => () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Menu Items
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  MenuListItem(
                    icon: Icons.person_outline,
                    title: 'Personal Details',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.personalDetailsScreen,
                        arguments: widget.patient,
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.analytics_outlined,
                    title: 'Personal Stats',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.personalStatsScreen);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.note_outlined,
                    title: 'Notes',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.notesScreen);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.mic_outlined,
                    title: 'Dictation',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.dictationScreen);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.email_outlined,
                    title: 'Correspondence',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.correspondenceScreen);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Appointments',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.appointmentsScreen);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.description_outlined,
                    title: 'Reports',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.patientReportScreen);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.history,
                    title: 'History',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.historyScreen);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.schedule_outlined,
                    title: 'Pre-Appointment Info',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.monitor_heart_outlined,
                    title: 'Health Tracker',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  MenuListItem(
                    icon: Icons.quiz_outlined,
                    title: 'Questionnaire',
                    onTap: () {},
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
