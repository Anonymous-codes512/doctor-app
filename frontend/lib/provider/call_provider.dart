import 'dart:convert';

import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/call_model.dart';
import 'package:doctor_app/data/services/call_service.dart';
import 'package:doctor_app/data/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CallProvider with ChangeNotifier {
  final CallService _callService = CallService();
  final SocketService _socketService = SocketService();

  List<Map<String, dynamic>> _callHistory = [];
  List<Map<String, dynamic>> get callHistory => _callHistory;
  List<CallModel> _calls = [];
  List<CallModel> get calls => _calls;

  int? _selectedCallConversationId;
  int? get selectedConversationId => _selectedCallConversationId;

  String? _agoraChannelName;
  String? get agoraChannelName => _agoraChannelName;

  String? _agoraToken;
  String? get agoraToken => _agoraToken;

  int? _otherUserId;
  int? _currentUserId;
  String? _currentUserName;

  int? _currentCallRecordId;
  String? _currentCallType;

  Map<String, dynamic>? _incomingCallData;
  Map<String, dynamic>? get incomingCallData => _incomingCallData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int? get currentCallRecordId => _currentCallRecordId;
  String? get currentCallType => _currentCallType;
  int? get currentUserId => _currentUserId;
  int? get otherUserId => _otherUserId;

  // Constructor ab sirf services initialize karega, socket ko nahi
  CallProvider() {
    _loadCurrentUser();
  }

  /// ✅ CallProvider ko initialize karta hai.
  /// Current user ID fetch karta hai aur phir SocketService ko initialize karta hai.
  void init() {
    print("Initializing CallProvider listeners...");
    if (_socketService.socketInstance != null &&
        _socketService.socketInstance!.connected) {
      print("Socket already connected, setting up listeners.");
      _setupSocketListeners();
    } else {
      print("Socket not connected, waiting for connection.");
      // Agar socket connected nahi hai, toh connect hone ke baad listeners setup karein
      _socketService.socketInstance?.onConnect((_) {
        print("Socket re-connected, setting up listeners.");
        _setupSocketListeners();
      });
    }
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final userData = jsonDecode(userString);
      _currentUserId = userData['id'];
      _currentUserName = userData['name'];
      print(
        "✅ Current user loaded: ID: $_currentUserId, Name: $_currentUserName",
      );
      _socketService.initSocket(
        _currentUserId!,
      ); // Socket ko user ID ke saath initialize karein
      _setupSocketListeners(); // Socket listeners ko yahan bhi setup karein
    } else {
      print("⚠️ No current user found in shared preferences.");
    }
  }

  void _setupSocketListeners() {
    // Incoming Call Listener
    _socketService.onIncomingCall = (data) {
      print("Incoming Call Event Data: $data");
      _handleIncomingCall(data);
    };

    // Call Accepted Listener
    _socketService.onCallAccepted = (data) {
      print("Call Accepted Event Data: $data");
      handleCallAccepted(data);
    };

    // Call Ended Listener
    _socketService.onCallEnded = (data) {
      print("Call Ended Event Data: $data");
      _handleCallEnded(data);
    };

    // Call Error Listener
    _socketService.onCallError = (data) {
      print("Call Error Event Data: $data");
      _handleCallError(data);
    };
  }

  // ✅ Incoming call data ko handle karein
  void _handleIncomingCall(Map<String, dynamic> data) {
    if (data.containsKey('caller_id') &&
        data.containsKey('caller_name') &&
        data.containsKey(
          'call_record_id',
        ) && // Call Record ID yahan available hai
        data.containsKey('call_type')) {
      _incomingCallData = data; // Incoming call data ko store karein
      _currentCallRecordId = data['call_record_id']; // <--- Yahan set karein
      _currentCallType = data['call_type']; // <--- Yahan bhi set karein

      print("Incoming call data set: $_incomingCallData");
      print(
        "Incoming CallRecord ID set: $_currentCallRecordId, Type: $_currentCallType",
      ); // Debug print
      notifyListeners(); // Listeners ko notify karein takay UI update ho sake
    } else {
      print("🔴 Error: Incomplete incoming call data received: $data");
      // ToastHelper.showError(context, 'Received incomplete call data');
    }
  }

  // ✅ Call accepted event ko handle karein
  void handleCallAccepted(Map<String, dynamic> data) {
    print("✅ Call Accepted Data: $data");
    if (data.containsKey('call_record_id') &&
        data.containsKey('call_type') &&
        data.containsKey('channel_name') && // <-- Yeh check shamil karein
        data.containsKey('token')) {
      // <-- Yeh check shamil karein
      _currentCallRecordId = data['call_record_id'];
      _currentCallType = data['call_type'];
      _agoraChannelName =
          data['channel_name']; // <-- channel_name assign karein
      _agoraToken = data['token']; // <-- token assign karein
      _isLoading = false;
      _incomingCallData =
          null; // Call accept hone ke baad incoming data clear karein
      notifyListeners();
      print(
        "Agora Channel Name: $_agoraChannelName, Token: $_agoraToken set in provider.",
      ); // Tasdeeq ke liye yeh print shamil karein
    } else {
      print("🔴 Error: Incomplete call accepted data received: $data");
      // ToastHelper.showError(context, 'Call acceptance failed due to incomplete data');
    }
  }

  // ✅ Call ended event ko handle karein
  void _handleCallEnded(Map<String, dynamic> data) {
    print("❌ Call Ended Data: $data");
    _resetCallState();
    print("✅ Call ended successfully.");
    // ToastHelper.showInfo(context, 'Call ended.');
  }

  // ✅ Call error event ko handle karein
  void _handleCallError(Map<String, dynamic> data) {
    print("🚨 Call Error Data: $data");
    _resetCallState(); // Error hone par state reset karein
    // ToastHelper.showError(context, 'Call error: ${data['message']}');
  }

  // ✅ Current user ki ID aur naam ko initialize karein
  // ignore: unused_element
  Future<void> _initCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        _currentUserId = userData['id'];
        _currentUserName = userData['name'];
        print(
          '✅ CallProvider: Current user ID set to $_currentUserId, Name: $_currentUserName',
        );
      } catch (e) {
        print(
          '🔴 CallProvider: Error decoding user data from SharedPreferences: $e',
        );
        _currentUserId = null;
        _currentUserName = null;
      }
    } else {
      print('🔴 CallProvider: User data not found in SharedPreferences.');
      _currentUserId = null;
      _currentUserName = null;
    }
  }

  Future<void> loadCallHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _callHistory = await _callService.fetchCallHistory();
      print('✅ Call History Loaded: $_callHistory');
    } catch (e) {
      print("🔴 Error loading call history: $e");
      // Optional: ToastHelper.showError(context, 'Failed to load call history.');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchUsersForNewCall() async {
    _isLoading = true;
    notifyListeners();
    try {
      final users = await _callService.fetchUsersForCall();
      print('✅ Users for new call fetched: ${users.length} users');
      return users;
    } catch (e) {
      print("🔴 Error fetching users for new call: $e");
      // Optional: ToastHelper.showError(context, 'Failed to fetch users for call.');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Call karne ke liye user ko select karein
  Future<void> selectUserForCall(int otherUserId) async {
    if (_currentUserId == null) {
      print("🔴 Error: Current user ID is null. Cannot select user for call.");

      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final callConvo = await _callService.getOrCreateCallConversation(
        otherUserId,
      );
      _selectedCallConversationId = callConvo['call_conversation_id'];
      _agoraChannelName = callConvo['channel_name'];
      _agoraToken = callConvo['token'];
      _otherUserId = otherUserId;

      print(
        '✅ Selected user for call: $_otherUserId, Conversation ID: $_selectedCallConversationId on channel: $_agoraChannelName with token: $_agoraToken',
      );

      await loadCalls(); // Selected user ke liye calls load karein
    } catch (e) {
      print("🔴 Error selecting user for call: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Conversation ke liye calls ko load karein
  Future<void> loadCalls() async {
    if (_selectedCallConversationId == null) {
      print(
        "🔴 Error: Cannot load calls, _selectedCallConversationId is null.",
      );
      // Optional: ToastHelper.showWarning(context, 'No active conversation selected.');
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      _calls = await _callService.fetchCalls(_selectedCallConversationId!);
      print('✅ Calls loaded for conversation ID: $_selectedCallConversationId');
    } catch (e) {
      print("🔴 Error loading Calls for conversation: $e");
      // Optional: ToastHelper.showError(context, 'Failed to load calls.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Current selection aur call state ko clear karein
  void clearCallSelection() {
    _selectedCallConversationId = null;
    _calls = [];
    _otherUserId = null;
    _currentCallRecordId = null;
    _currentCallType = null;
    _incomingCallData = null;
    _agoraChannelName = null;
    _agoraToken = null;
    _isLoading = false; // Ensure loading is false
    notifyListeners();
    print('✅ Call selection and state cleared.');
  }

  // ✅ Call shuru karne ka function (outgoing call)
  Future<void> startCall({
    required String callType,
    required BuildContext context,
  }) async {
    if (_currentUserId == null ||
        _otherUserId == null ||
        _currentUserName == null) {
      print("🔴 Error: Cannot start call, missing user IDs or caller name.");
      ToastHelper.showError(
        context,
        'Please log in again or select a user to call.',
      );
      return;
    }

    _isLoading = true;
    _currentCallType = callType;
    _incomingCallData =
        null; // Outgoing call ke liye incoming data clear karein
    notifyListeners();

    try {
      _socketService.startCall(
        callerId: _currentUserId!,
        receiverId: _otherUserId!,
        callerName: _currentUserName!,
        callType: callType,
      );
      print(
        '📞 Attempting to start $callType call from $_currentUserName to $_otherUserId',
      );
      // Yehan par isLoading ko false na karein, kyuki abhi call accepted nahi hui
      // isLoading ko _handleCallAccepted ya _handleCallError mein false kiya jayega
    } catch (e) {
      print("🔴 Error starting call: $e");
      ToastHelper.showError(context, 'Failed to start call. Please try again.');
      _isLoading = false; // Error hone par loading state reset karein
      notifyListeners();
    }
  }

  /// Incoming call ko accept karne ka function
  void acceptIncomingCall(BuildContext context) {
    if (_incomingCallData == null ||
        _currentUserId == null ||
        _currentCallRecordId == null) {
      print(
        "🔴 Error: Cannot accept call, no incoming call data or missing user info.",
      );
      ToastHelper.showError(context, 'No incoming call to accept.');
      return;
    }
    try {
      _socketService.acceptCall(
        callRecordId: _currentCallRecordId!,
        callerId: _incomingCallData!['caller_id'], // Caller ID incoming data se
        receiverId: _currentUserId!, // Current user receiver hai
      );
      // isLoading aur incomingCallData ko handleCallAccepted mein set karein
      print(
        "✅ Call accepted request sent for CallRecord ID: $_currentCallRecordId",
      );
      // notifyListeners(); // Ye yahan zaruri nahi, _handleCallAccepted handle karega
    } catch (e) {
      print("🔴 Error accepting incoming call: $e");
      ToastHelper.showError(context, 'Failed to accept call.');
    }
  }

  /// Call end karne ka function
  void endCall({required String callStatus, required BuildContext context}) {
    if (_currentCallRecordId == null || _currentUserId == null) {
      print(
        "🔴 Error: Cannot end call, missing active callRecordId or currentUserId.",
      );
      ToastHelper.showError(context, 'No active call to end.');
      return;
    }
    try {
      _socketService.endCall(
        callRecordId: _currentCallRecordId!,
        enderId: _currentUserId!,
        callStatus: callStatus,
      );
      _resetCallState(); // State ko reset karein
      print(
        "❌ Ending call with status: $callStatus for CallRecord ID: $_currentCallRecordId",
      );
      // _incomingCallData = null; // _resetCallState() mein bhi hai
      // notifyListeners(); // _resetCallState() mein bhi hai
    } catch (e) {
      print("🔴 Error ending call: $e");
      ToastHelper.showError(context, 'Failed to end call.');
    }
  }

  // ✅ Call state ko reset karne ke liye utility function
  void _resetCallState() {
    _currentCallRecordId = null;
    _currentCallType = null;
    _incomingCallData = null;
    _agoraChannelName = null; // Agora details bhi clear karein
    _agoraToken = null;
    _isLoading = false;
    notifyListeners();
    print('✅ Call state reset.');
  }

  // Agar aapko CallModel class ki definition chahiye, to yahan ho sakti hai
  // Ya phir aapki data/models/call_model.dart file mein check karein.
}
