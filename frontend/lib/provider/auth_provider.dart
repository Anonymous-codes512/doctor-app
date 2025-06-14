import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<bool> register(
    BuildContext context,
    String name,
    String email,
    String password,
    String role, {
    String? phone,
  }) async {
    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
      role: role,
      phone: phone,
    );

    if (result['success']) {
      ToastHelper.showSuccess(context, result['message']);
    } else {
      ToastHelper.showError(context, result['message']);
    }

    return result['success'];
  }

  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    final result = await _authService.login(email: email, password: password);

    if (result['success']) {
      ToastHelper.showSuccess(context, result['message']);
    } else {
      ToastHelper.showError(context, result['message']);
    }

    return result['success'];
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.loginScreen,
      (route) => false,
    );
  }

  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }
}
