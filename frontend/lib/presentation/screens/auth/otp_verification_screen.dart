import 'dart:async';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final int _otpLength = 4;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  String? _errorMessage;
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _otpLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value[0];
    }
    if (value.isNotEmpty && index < _otpLength - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    setState(() {});
  }

  Future<void> _onVerifyPressed() async {
    final otpCode = _controllers.map((c) => c.text).join();

    if (otpCode.length < _otpLength) {
      setState(() {
        _errorMessage = 'Please fill the code';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).verifyResetOtp(context, widget.email, otpCode);

    if (success) {
      Navigator.pushNamed(
        context,
        Routes.resetPasswordScreen,
        arguments: widget.email,
      );
    }

    setState(() => _isVerifying = false);
  }

  Future<void> _onResendPressed() async {
    if (!_canResend || _isResending) return;

    setState(() => _isResending = true);

    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).sendResetCode(context, widget.email);

    if (success) {
      for (var c in _controllers) {
        c.clear();
      }
      FocusScope.of(context).requestFocus(_focusNodes[0]);
      _startTimer();
    }

    setState(() => _isResending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
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
              const SizedBox(height: 24),
              const Text(
                'Please check your email',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    const TextSpan(text: 'We’ve sent a code to '),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (index) {
                  return SizedBox(
                    width: 56,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.gradientBottom.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.gradientBottom,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppColors.errorColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 24),
              PrimaryCustomButton(
                text: 'Verify',
                isLoading: _isVerifying,
                onPressed: _isVerifying ? null : _onVerifyPressed,
              ),
              const SizedBox(height: 24),
              Center(
                child:
                    _canResend
                        ? GestureDetector(
                          onTap: _onResendPressed,
                          child:
                              _isResending
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                    'Send code again',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                        )
                        : Text(
                          'Send code again  00:${_secondsRemaining.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
