import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/patient_header_card.dart';
import 'package:doctor_app/presentation/widgets/patient_list_item.dart';
import 'package:flutter/material.dart';

class GroupProfileScreen extends StatefulWidget {
  final Map<String, dynamic> patientsGroup;
  const GroupProfileScreen({Key? key, required this.patientsGroup})
    : super(key: key);

  List<dynamic> get members => patientsGroup['members'] as List<dynamic>? ?? [];

  @override
  State<GroupProfileScreen> createState() => _GroupProfileScreenState();
}

class _GroupProfileScreenState extends State<GroupProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,

        centerTitle: true,
        title: const Text(
          'Group Profile',
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
                name: widget.patientsGroup['group_name'] ?? 'N/A',
                age: widget.patientsGroup['purpose'] ?? 'N/A',
                condition: widget.members.length.toString(),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Members: ${widget.members.length}',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),

            // Patient list (fixed height inside scrollable column)
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: widget.members.length,
                itemBuilder: (context, index) {
                  final patient = widget.members[index];
                  return PatientListItem(
                    name: patient['name'],
                    phoneNumber: patient['phoneNumber'],
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'view') {
                          print('View clicked for ${patient['name']}');
                        } else if (value == 'make_admin') {
                          print('Make Admin clicked for ${patient['name']}');
                        } else if (value == 'remove') {
                          print('Remove clicked for ${patient['name']}');
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Text('View'),
                            ),
                            const PopupMenuItem(
                              value: 'make_admin',
                              child: Text('Make Admin'),
                            ),
                            const PopupMenuItem(
                              value: 'remove',
                              child: Text('Remove'),
                            ),
                          ],
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  );
                },
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
