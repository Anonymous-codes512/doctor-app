import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

class AgoraAudioHandler {
  final String appId;
  final String token;
  final String channelName;

  late RtcEngine _engine;
  bool _joined = false;

  AgoraAudioHandler({
    required this.appId,
    required this.token,
    required this.channelName,
  });

  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.enableAudio();
    await _engine.startPreview();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          _joined = true;
          debugPrint("✅ Joined channel: ${connection.channelId}");
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("👤 Remote user joined: $remoteUid");
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("👋 Remote user left: $remoteUid");
        },
        onLeaveChannel: (connection, stats) {
          _joined = false;
          debugPrint("❌ Left channel: ${connection.channelId}");
        },
      ),
    );
  }

  Future<void> join() async {
    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leave() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> mute(bool shouldMute) async {
    await _engine.muteLocalAudioStream(shouldMute);
  }

  Future<void> switchSpeaker(bool enableSpeaker) async {
    await _engine.setEnableSpeakerphone(enableSpeaker);
  }

  bool get isJoined => _joined;
}
