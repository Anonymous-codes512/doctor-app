import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/material.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final Color backgroundColor;
  final Color textColor;

  const AudioMessageWidget({
    Key? key,
    required this.audioUrl,
    required this.isMe,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  _AudioMessageWidgetState createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      // Configure audio session for proper behavior
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((playerState) {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;

        if (processingState == ProcessingState.loading) {
          setState(() => _isLoading = true);
        } else if (processingState == ProcessingState.ready) {
          setState(() => _isLoading = false);
        }

        if (isPlaying != _isPlaying) {
          setState(() => _isPlaying = isPlaying);
        }
      });

      // Listen to duration changes
      _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() => _duration = duration);
        }
      });

      // Listen to position changes
      _audioPlayer.positionStream.listen((position) {
        setState(() => _position = position);
      });
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
    }
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_audioPlayer.playing) {
        await _audioPlayer.play();
      } else {
        try {
          await _audioPlayer.setUrl(widget.audioUrl);
          await _audioPlayer.play();
        } catch (e) {
          debugPrint('Error playing audio: $e');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not play audio: $e')));
        }
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: widget.textColor,
                size: 30,
              ),
              onPressed: _isLoading ? null : _playPauseAudio,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice message',
                    style: TextStyle(color: widget.textColor, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    percent:
                        _duration.inSeconds > 0
                            ? _position.inSeconds / _duration.inSeconds
                            : 0,
                    lineHeight: 2,
                    progressColor: widget.textColor.withOpacity(0.5),
                    backgroundColor: widget.textColor.withOpacity(0.2),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: TextStyle(
                          color: widget.textColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: TextStyle(
                          color: widget.textColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: LinearProgressIndicator(minHeight: 2, color: Colors.white),
          ),
      ],
    );
  }
}
