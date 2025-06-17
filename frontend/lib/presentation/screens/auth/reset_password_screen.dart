import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/error_dialog.dart';
import 'package:doctor_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;
  bool _isResetting = false;

  void _toggleVisibility(String field) {
    setState(() {
      if (field == 'password') {
        _passwordVisible = !_passwordVisible;
      } else if (field == 'confirm') {
        _passwordConfirmVisible = !_passwordConfirmVisible;
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _showErrorDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Error",
      barrierColor: Colors.black.withOpacity(0.3),
      pageBuilder: (context, anim1, anim2) {
        return CustomDialog(
          onClose: () => Navigator.of(context).pop(),
          title: "Warning!",
          message: "Your passwords don’t match",
          type: MessageType.warning,
        );
      },
      transitionBuilder:
          (context, anim1, anim2, child) =>
              FadeTransition(opacity: anim1, child: child),
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  Future<void> _resetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_passwordController.text != _passwordConfirmController.text) {
      _showErrorDialog();
      return;
    }

    setState(() {
      _isResetting = true;
    });

    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).resetPassword(
      context,
      widget.email.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      Navigator.pushNamed(context, Routes.passwordChangedScreen);
    }

    setState(() {
      _isResetting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black87),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Reset password',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Please type something you\'ll remember',
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 24),

                      // Password with toggle visibility
                      LabeledTextField(
                        label: 'New Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () => _toggleVisibility('password'),
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Confirm password with toggle visibility
                      LabeledTextField(
                        label: 'Confirm new password',
                        hintText: 'Repeat password',
                        controller: _passwordConfirmController,
                        obscureText: !_passwordConfirmVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter confirm password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () => _toggleVisibility('confirm'),
                          child: Icon(
                            _passwordConfirmVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      PrimaryCustomButton(
                        text: _isResetting ? 'Resetting...' : 'Reset password',
                        onPressed: _isResetting ? null : _resetPassword,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
