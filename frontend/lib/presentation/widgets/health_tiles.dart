import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback? onTap;

  const HealthTile({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFcad2ee),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon and title in a Row
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 8), // Spacing between icon and title
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 12), // Spacing between title and steps
            // If steps icons are passed, display them below the title
          ],
        ),
      ),
    );
  }
}

class LargeHealthTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final List<Widget> stepsIcons;
  final VoidCallback? onTap;

  const LargeHealthTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.stepsIcons,
    this.onTap,
  }) : super(key: key);

  // Permission request function
  Future<void> _requestPermission(BuildContext context) async {
    var status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      print("Permission granted!");
      // Proceed with the desired action (e.g., navigation)
      if (onTap != null) onTap!();
    } else {
      print("Permission denied!");
      // Show a dialog or prompt user to grant permission
      _showPermissionDialog(context);
    }
  }

  // Method to show a permission dialog if permission is denied
  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.directions_walk),
              SizedBox(width: 8),
              Text('Physical Activity Permission Required'),
            ],
          ),
          content: Text('Without this permission, this feature will not work.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await Permission.activityRecognition.request();
                Navigator.of(context).pop();
              },
              child: Text('Allow'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => _requestPermission(
            context,
          ), // Call the permission request function here
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFcad2ee),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                icon,
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [...stepsIcons, const SizedBox(width: 50)],
            ),
          ],
        ),
      ),
    );
  }
}
