import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/error_dialog.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/social_icon_button.dart';
import 'package:doctor_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';

class RegisterScreen extends StatefulWidget {
  final String role;
  const RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _termsError;
  bool _termsAccepted = false;
  bool _passwordVisible = false;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    print('User role is: ${widget.role}');
  }

  Future<void> _onSignupPressed() async {
    setState(() {
      _termsError = null;
    });

    if (!_formKey.currentState!.validate()) {
      _showErrorDialog(
        title: 'Validation Error',
        message: 'Please fill all required fields correctly.',
        type: MessageType.error,
      );
      return;
    }

    if (!_termsAccepted) {
      setState(() {
        _termsError = 'Please accept the terms and privacy policy';
      });
      _showErrorDialog(
        title: 'Terms Not Accepted',
        message: 'Please accept the terms and privacy policy',
        type: MessageType.error,
      );
      return;
    }

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      context,
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      widget.role,
    );

    setState(() => _isLoading = false);
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    }
  }

  void _showErrorDialog({
    required String title,
    required String message,
    MessageType type = MessageType.error,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Error",
      barrierColor: Colors.black.withOpacity(0.3),
      pageBuilder: (context, anim1, anim2) {
        return CustomDialog(
          onClose: () => Navigator.of(context).pop(),
          title: title,
          message: message,
          type: type,
        );
      },
      transitionBuilder:
          (context, anim1, anim2, child) =>
              FadeTransition(opacity: anim1, child: child),
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
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
                      child: const Icon(Icons.arrow_back_ios_new, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Create your account',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
                ),
                const SizedBox(height: 24),

                LabeledTextField(
                  label: 'Username',
                  hintText: 'Your username',
                  controller: _usernameController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter username'
                              : null,
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Email',
                  hintText: 'Your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    return emailRegex.hasMatch(value)
                        ? null
                        : 'Enter valid email';
                  },
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  validator:
                      (value) =>
                          value == null || value.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                  suffixIcon: GestureDetector(
                    onTap: _togglePasswordVisibility,
                    child: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Checkbox(
                      activeColor: AppColors.primaryColor,
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                          if (_termsAccepted) _termsError = null;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          text: 'I accept the ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'terms and privacy policy',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_termsError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text(
                      _termsError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 24),

                PrimaryCustomButton(
                  text: _isLoading ? 'Registering...' : 'Sign up',
                  onPressed: _isLoading ? null : _onSignupPressed,
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Or Register with',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SocialIconButton(
                      icon: const Icon(
                        Icons.facebook,
                        color: Color(0xFF1877F2),
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                    SocialIconButton(
                      icon: const Icon(
                        SimpleIcons.google,
                        color: SimpleIconColors.googlecardboard,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                    SocialIconButton(
                      icon: const Icon(
                        Icons.apple,
                        color: Colors.black,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap:
                          () =>
                              Navigator.pushNamed(context, Routes.loginScreen),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
