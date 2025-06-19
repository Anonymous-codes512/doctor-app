import 'dart:convert';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'phone_number': phone,
        }),
      );

      final body = jsonDecode(response.body);
      return {
        'success': response.statusCode == 201,
        'message': body['message'] ?? 'Something went wrong',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = jsonDecode(response.body);
      print(body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', body['token']);
        await prefs.setString('user', jsonEncode(body['user']));
        await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);

        return {
          'success': true,
          'message': body['message'] ?? 'Login successful',
          'role': body['user']['role'] ?? 'unknown',
        };
      } else {
        return {'success': false, 'message': body['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('loginTime');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final loginTime = prefs.getInt('loginTime');

    if (token != null && loginTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final difference = now - loginTime;
      return difference < 12 * 60 * 60 * 1000; // 12 hours in milliseconds
    }
    return false;
  }

  Future<Map<String, dynamic>> sendResetCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.sendResetCode),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Reset code sent successfully.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Failed to send reset code.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Please check your connection.',
      };
    }
  }

  Future<Map<String, dynamic>> verifyResetOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.verifyResetOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'OTP verified successfully.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Invalid OTP or expired.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again later.',
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword(
    String email,
    String newPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': newPassword}),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Password reset successfully.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Failed to reset password.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Could not reset password. Check your internet connection.',
      };
    }
  }
}
