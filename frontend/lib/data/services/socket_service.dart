import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  // ✅ Ab 'late' keyword hata kar isko nullable bana dein
  io.Socket? _socket;

  // New messages ke liye callback function
  Function(Map<String, dynamic>)? onNewMessageReceived;

  SocketService._internal();

  // Socket instance ko get karne ke liye, agar aapko bahar access karna ho
  io.Socket? get socketInstance => _socket;

  void initSocket(int userId) {
    // ✅ Pehle check karein ke _socket null nahi hai AUR connected bhi hai
    if (_socket != null && _socket!.connected) {
      print('ℹ️ Socket already connected. Skipping re-initialization.');
      return; // Agar pehle se connected hai, to kuch na karein
    }

    // ✅ Agar _socket null hai ya disconnected hai, to usko initialize karein
    _socket = io.io(ApiConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // Manual connect karenge
      // 'query': {'user_id': userId.toString()} // Agar authentication query mein chahiye
    });

    _socket!.connect(); // ✅ Initialize hone ke baad connect karein

    _socket!.onConnect((_) {
      print('✅ Flutter Socket connected');
      _socket!.emit('join', {'user_id': userId});
      print('✅ Emitted join event with user_id: $userId');
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
      // Optional: Har event ko log karein debugging ke liye
      // print('Socket Event: $event, Data: $data');
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
}
