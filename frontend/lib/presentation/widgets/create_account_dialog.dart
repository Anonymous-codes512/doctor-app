import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:flutter/material.dart';

class CreateAccountDialog extends StatelessWidget {
  const CreateAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button top-right
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 20),
              ),
            ),
            const SizedBox(height: 8),
            // Top Image or Icon
            SizedBox(
              height: 100,
              child: Image.asset(
                ImagePath.createAccountDialogImage, // Replace with your asset
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Create Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            const Text(
              "Please choose how you want to create your account:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            // Options list
            Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  title: const Text(
                    "Patient",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("For personal medical appointments"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                      context,
                      Routes.registerScreen,
                      arguments: 'patient',
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: const Icon(
                      Icons.medical_services,
                      color: Colors.green,
                    ),
                  ),
                  title: const Text(
                    "Doctor",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("For healthcare professionals"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                      context,
                      Routes.registerScreen,
                      arguments: 'doctor',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
