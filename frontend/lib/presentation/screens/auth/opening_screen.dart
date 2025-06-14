import 'dart:ui';

import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/create_account_dialog.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:http/http.dart' as http;

class OpenningScreen extends StatelessWidget {
  const OpenningScreen({super.key});

  Future<void> pingBackend() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/');
    try {
      final response = await http.get(url);
      print('✅ Backend response: ${response.body}');
    } catch (e) {
      print('❌ Error connecting to backend: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image section
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      ImagePath.openningScreenImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  const Text(
                    'Explore the app',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  const Text(
                    'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryCustomButton(
                    text: 'Log In',
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.loginScreen);
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedCustomButton(
                    text: 'Create an account',
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder:
                            (context) => Stack(
                              children: [
                                // Blurred background
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 2,
                                    sigmaY: 2,
                                  ),
                                  child: Container(
                                    color: Colors.black.withOpacity(
                                      0.1,
                                    ), // darken behind blur
                                  ),
                                ),
                                // Center the dialog
                                Center(child: const CreateAccountDialog()),
                              ],
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.black26),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Or Register with',
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.black26),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Social icon buttons in a row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialIconButton(
                        icon: const Icon(
                          SimpleIcons.facebook,
                          color: SimpleIconColors.facebook,
                        ),
                        onPressed: () {},
                      ),
                      SocialIconButton(
                        icon: const Icon(
                          SimpleIcons.google,
                          color: SimpleIconColors.googlecardboard,
                        ),
                        onPressed: () {},
                      ),
                      SocialIconButton(
                        icon: const Icon(
                          SimpleIcons.apple,
                          color: SimpleIconColors.applearcade,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Explore as guest button
                  OutlinedCustomButton(
                    text: 'Explore as a guest',
                    onPressed: pingBackend,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
