import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Custom header without background and with horizontal layout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              // No background color here to keep it transparent
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(ImagePath.profileAvatar),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Dr. Staller Kane',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'doctor@example.com',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.homeScreen,
                  (route) => false,
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Invite colleagues'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy policy'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
