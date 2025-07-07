// provider/call_provider.dart
import 'dart:convert';

import 'package:doctor_app/data/models/call_model.dart';
import 'package:doctor_app/data/services/call_service.dart'; // Naya CallService import karein
import 'package:doctor_app/data/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallProvider with ChangeNotifier {
  final CallService _callService = CallService(); // Naya CallService instance
  final SocketService _socketService = SocketService();

  List<Map<String, dynamic>> _callHistory = [];
  List<CallModel> _calls = [];

  int? _selectedCallConversationId;
  // String? _chatSecret;
  int? _otherUserId;
  int? _currentUserId;

  CallProvider() {
    _socketService.onNewMessageReceived = _handleNewRealtimeCall;
    _initCurrentUserId(); // ✅ Add this call
  }

  bool _isLoading = false;

  List<Map<String, dynamic>> get callHistory => _callHistory;
  List<CallModel> get calls => _calls;

  int? get selectedConversationId => _selectedCallConversationId;
  bool get isLoading => _isLoading;

  Future<void> _initCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _currentUserId = jsonDecode(userJson)['id'];
      print('✅ CallProvider: Current user ID set to $_currentUserId');
    } else {
      print('🔴 CallProvider: User data not found in SharedPreferences.');
    }
  }

  // ✅ Real-time message receive hone par call hoga
  void _handleNewRealtimeCall(Map<String, dynamic> callData) {
    if (_currentUserId == null) {
      print(
        '🔴 Warning: _currentUserId is null when handling new real-time call.',
      );
      return;
    }

    if (callData['call_conversation_id'] == _selectedCallConversationId) {
      final newCall = CallModel.fromJson(callData);

      bool callsExistsById = _calls.any(
        (msg) => msg.id == newCall.id && newCall.id != null,
      );

      if (newCall.callerId == _currentUserId) {
        int indexToUpdate = _calls.indexWhere(
          (msg) =>
              msg.callerId == _currentUserId &&
              msg.startTime == newCall.startTime &&
              msg.endTime == newCall.endTime &&
              msg.id == null,
        );

        if (indexToUpdate != -1) {
          _calls[indexToUpdate] = newCall;
          print('✅ Own sent call updated with server ID: ${newCall.id}');
        } else {
          if (!callsExistsById) {
            _calls.add(newCall);
            print(
              '✅ Own Call added as it was not found as temp: ${newCall.id}',
            );
          }
        }
      } else {
        if (!callsExistsById) {
          _calls.add(newCall);
          print('✅ Received new calls from other user: ${newCall.id}');
        } else {
          print(
            'ℹ️ Received duplicate calls by ID from other user. Not adding.',
          );
        }
      }
      _calls.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
      notifyListeners();
    }
    loadCallHistory();
  }

  Future<void> loadCallHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _callHistory = await _callService.fetchCallHistory();
      print(_callHistory);
    } catch (e) {
      print("🔴 Error loading conversations: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchUsersForNewCall() async {
    return await _callService.fetchUsersForCall();
  }

  // ✅ Select user to chat (either new or existing conversation)
  Future<void> selectUserForChat(int otherUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final callConvo = await _callService.getOrCreateCallConversation(
        otherUserId,
      );
      _selectedCallConversationId = callConvo['call_conversation_id'];
      _otherUserId = otherUserId;

      await loadCalls();
    } catch (e) {
      print("🔴 Error selecting user for call: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Load messages for current conversation
  Future<void> loadCalls() async {
    if (_selectedCallConversationId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _calls = await _callService.fetchCalls(_selectedCallConversationId!);
    } catch (e) {
      print("🔴 Error loading Calls: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // ✅ Clear current selection (optional)
  void clearCalls() {
    _selectedCallConversationId = null;
    _calls = [];
    _otherUserId = null;
    _currentUserId = null;
    notifyListeners();
  }
}
