import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  Function(Map<String, dynamic>)? onIncomingCall; // Ab map data receive karega
  Function(Map<String, dynamic>)? onCallAccepted; // Ab map data receive karega
  Function(Map<String, dynamic>)? onCallEnded; // Ab map data receive karega
  Function(Map<String, dynamic>)? onCallError;

  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;
  io.Socket? _socket;
  Function(Map<String, dynamic>)? onNewMessageReceived;
  SocketService._internal();
  io.Socket? get socketInstance => _socket;

  void initSocket(int userId, {Function(Map<String, dynamic>)? onCall}) {
    if (_socket != null && _socket!.connected) {
      print('ℹ️ Socket already connected. Skipping re-initialization.');
      return;
    }
    _socket = io.io(ApiConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();
    onIncomingCall = onCall; // 👈 Store callback

    _socket!.onConnect((_) {
      print('✅ Flutter Socket connected');
      _socket!.emit('join', {'user_id': userId});
      print('✅ Emitted join event with user_id: $userId');
      _listenToCallEvents();
    });

    _socket!.onConnectError((data) {
      print('❌ Socket Connect Error: $data');
    });

    _socket!.onDisconnect((_) {
      print('🔌 Flutter Socket disconnected');
    });

    _socket!.on('new_message', (data) {
      print('📩 Real-time message received: $data');
      if (onNewMessageReceived != null) {
        onNewMessageReceived!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.onError((data) {
      print('‼️ Socket Error: $data');
    });

    _socket!.onAny((event, data) {
      print('🔍 Socket Event: $event, Data: $data');
    });
  }

  // data/services/socket_service.dart
  // ...
  void _listenToCallEvents() {
    _socket!.on('incoming_call', (data) {
      print('🔍 Socket Event: incoming_call, Data: $data');
      onIncomingCall?.call(data); // Null-safe call
      print('📞 Incoming call received: $data');
    });
    // ...
    _socket!.on('call_accepted', (data) {
      print("✅ Call accepted: $data");
      if (onCallAccepted != null) {
        onCallAccepted!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('call_ended', (data) {
      print("🛑 Call ended: $data");
      if (onCallEnded != null) {
        onCallEnded!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('call_error', (data) {
      print("❌ Call error: $data");
      if (onCallError != null) {
        onCallError!(Map<String, dynamic>.from(data));
      }
    });
  }

  void sendMessageViaSocket(Map<String, dynamic> messageData) {
    // ✅ Message bhejne se pehle bhi _socket ko null aur connected check karein
    if (_socket != null && _socket!.connected) {
      _socket!.emit('send_message', messageData);
      print("📤 Real-time message emitted via Socket: $messageData");
    } else {
      print("⚠️ Socket not connected. Cannot send message via Socket.");
      // Aap yahan koi UI message show kar sakte hain ya message ko retry kar sakte hain
    }
  }

  void disconnectSocket() {
    // ✅ Disconnect karne se pehle bhi _socket ko null aur connected check karein
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
      _socket!.dispose(); // Resources release karein
      _socket = null; // ✅ Dispose ke baad _socket ko null kar dein
      print('🔌 Socket disconnected and disposed.');
    }
  }

  void startCall({
    required int callerId,
    required int receiverId,
    required String callerName,
    required String callType, // 'audio' ya 'video'
  }) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('start_call', {
        'caller_id': callerId,
        'receiver_id': receiverId,
        'caller_name': callerName,
        'call_type': callType, // New parameter
      });
      print(
        "📞 Emitted start_call event: Caller $callerId, Receiver $receiverId, Type $callType",
      );
    } else {
      print("⚠️ Socket not connected. Cannot start call.");
    }
  }

  // ✅ Updated acceptCall method to include callRecordId
  void acceptCall({
    required int callerId,
    required int receiverId,
    required int callRecordId, // New parameter
  }) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('accept_call', {
        'caller_id': callerId,
        'receiver_id': receiverId,
        'call_record_id': callRecordId,
      });
      print("✅ Emitted accept_call event for CallRecord ID: $callRecordId");
    } else {
      print("⚠️ Socket not connected. Cannot accept call.");
    }
  }

  // ✅ Updated endCall method to include callRecordId and callStatus
  void endCall({
    required int callRecordId,
    required int enderId, // Wo user jo call end kar raha hai
    required String
    callStatus, // 'completed', 'cancelled', 'rejected', 'missed'
  }) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('end_call', {
        'call_record_id': callRecordId,
        'ender_id': enderId,
        'call_status': callStatus,
      });
      print(
        "🛑 Emitted end_call event for CallRecord ID: $callRecordId, Status: $callStatus",
      );
    } else {
      print("⚠️ Socket not connected. Cannot end call.");
    }
  }
}
