import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/dictation_widgets.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

enum RecordingState { idle, recording, paused, stopped }

class DictationScreen extends StatefulWidget {
  final int patientId;
  const DictationScreen({super.key, required this.patientId});

  @override
  State<DictationScreen> createState() => _DictationScreenState();
}

class _DictationScreenState extends State<DictationScreen> {
  RecordingState _recordingState = RecordingState.idle;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  TextEditingController _dictationText = TextEditingController();

  Timer? _timer;
  int _recordingTime = 0;
  String _searchQuery = '';
  String? _recordingPath;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _previousDictations = [];
  bool _isRecorderInitialized = false;
  // Naya state variable loader ko control karne ke liye
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreviousDictations();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
    _initRecorder().then((_) {
      print('initiliazation....');
      setState(() {
        _isRecorderInitialized = true;
      });
    });
  }

  Future<void> _loadPreviousDictations() async {
    final dictations = await Provider.of<DoctorProvider>(
      context,
      listen: false,
    ).fetchDictations(widget.patientId);
    setState(() {
      _previousDictations =
          dictations
              .where(
                (dictation) =>
                    dictation['fileName']!.toLowerCase().contains(_searchQuery),
              )
              .toList(); // search filter yahan bhi apply kiya
    });
  }

  Future<void> _initRecorder() async {
    print("Initializing recorder...");
    var status = await Permission.microphone.request();
    print("Microphone permission status: $status");
    if (status.isGranted) {
      try {
        if (!_isRecorderInitialized) {
          await _recorder.openRecorder();
          print("Recorder opened successfully.");
          setState(() {
            _isRecorderInitialized = true;
          });
        } else {
          print("Recorder already open.");
          setState(() {
            _isRecorderInitialized = true;
          });
        }
      } catch (e) {
        print("Error opening recorder: $e");
        setState(() {
          _isRecorderInitialized = false;
        });
      }
    } else {
      print("Cannot open recorder: Permission not granted.");
      setState(() {
        _isRecorderInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.closeRecorder();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _copyToDownloads() async {
    final downloads = Directory('/storage/emulated/0/Download');
    final newPath = '${downloads.path}/dictation.wav';
    await File(_recordingPath!).copy(newPath);
    print("✅ Copied to Downloads: $newPath");
  }

  Future<void> _startRecording() async {
    print("START RECORDING FUNCTION CALLED AT: ${DateTime.now()}");
    if (!_isRecorderInitialized) {
      print(
        "Recorder is not initialized before starting. Trying to re-initialize.",
      );
      await _initRecorder();
      if (!_isRecorderInitialized) {
        print(
          "Failed to initialize recorder after re-initialization. Cannot start recording.",
        );
        return;
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    _recordingPath =
        '${dir.path}/dictation_note_${DateTime.now().millisecondsSinceEpoch}.aac';

    try {
      await _recorder.startRecorder(
        toFile: _recordingPath,
        codec: Codec.aacADTS,
        audioSource: AudioSource.microphone,
      );

      print(
        "🎙️ Recorder started successfully at: ${DateTime.now()} Path: $_recordingPath",
      );
      setState(() {
        _recordingState = RecordingState.recording;
        _recordingTime = 0;
        _dictationText.text = 'your dictation will appear here...';
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _recordingTime++);
      });
    } catch (e) {
      print("Error starting recorder: $e");
      print("Error starting recorder at ${DateTime.now()}: $e");

      setState(() {
        _recordingState = RecordingState.idle;
      });
    }
  }

  Future<void> _pauseRecording() async {
    await _recorder.pauseRecorder();
    _timer?.cancel();
    setState(() => _recordingState = RecordingState.paused);
  }

  Future<void> _resumeRecording() async {
    await _recorder.resumeRecorder();
    setState(() => _recordingState = RecordingState.recording);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordingTime++);
    });
  }

  Future<void> _stopRecording() async {
    print("STOP RECORDING FUNCTION CALLED AT: ${DateTime.now()}");
    try {
      await _recorder.stopRecorder();
      _copyToDownloads(); // Pehle downloads mein copy kar lein
      print("🎙️ Recorder stopped successfully at: ${DateTime.now()}");

      _timer?.cancel();
      setState(() => _recordingState = RecordingState.stopped);
      await _sendToBackend(); // Backend ko send karein
    } catch (e) {
      print("Error stopping recorder at ${DateTime.now()}: $e");
    }
  }

  void _cancelRecording() {
    _recorder.stopRecorder();
    _timer?.cancel();
    setState(() {
      _recordingState = RecordingState.idle;
      _recordingTime = 0;
      _dictationText.text = 'your dictation will appear here...';
      _recordingPath = null;
    });
  }

  Future<void> _sendToBackend() async {
    if (_recordingPath == null) return;

    setState(() {
      _isLoading = true; // Loader show karein
    });

    try {
      final uri = Uri.parse(ApiConstants.sendAudioFileForTranscription);
      final req = http.MultipartRequest('POST', uri);
      req.files.add(await http.MultipartFile.fromPath('file', _recordingPath!));
      final res = await req.send();

      if (res.statusCode == 200) {
        final str = await res.stream.bytesToString();
        final data = jsonDecode(str);
        print('Transcription of provided Audio : $data');
        setState(() => _dictationText.text = data['text']);
      } else {
        setState(() => _dictationText.text = '❌ Transcription error');
        print('Transcription API Error: ${res.statusCode}');
        final errorBody = await res.stream.bytesToString();
        print('Error Response Body: $errorBody');
      }
    } catch (e) {
      print("Error sending to backend: $e");
      setState(() => _dictationText.text = '❌ Network error');
    } finally {
      setState(() {
        _isLoading = false; // Loader hide karein
      });
    }
  }

  void _saveToPatientFolder() {
    showDialog(
      context: context,
      builder:
          (context) => FileNameDialog(
            onSave: (fileName) async {
              print('Save Click');
              final newDictation = {
                'patient_id': widget.patientId,
                'dictation_text': _dictationText.text.trim(),
                'fileName':
                    fileName.isEmpty ? 'General Prescription' : fileName,
                'date':
                    '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().substring(2)}',
                'time':
                    '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
              };

              await Provider.of<DoctorProvider>(
                context,
                listen: false,
              ).addNewDictation(newDictation, context);

              setState(() {
                _recordingState = RecordingState.idle;
                _recordingTime = 0;
                _dictationText.text = '';
                // Save hone ke baad previous dictations ko dobara load karein
                _loadPreviousDictations();
              });
            },
          ),
    );
  }

  String _formatTime(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext ctx) {
    // Filtered list search query ke mutabiq
    final filteredDictations =
        _previousDictations
            .where(
              (dictation) =>
                  dictation['fileName']!.toLowerCase().contains(_searchQuery),
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(ctx),
        ),
        title: const Text('Dictation', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search dictations...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                            : null,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dictation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.graphic_eq, color: Colors.grey[600]),
                  ],
                ),
              ),
              const Divider(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildBasedOnState(filteredDictations),
                ),
              ),
            ],
          ),
          // Loader (conditional visibility)
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Processing dictation...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBasedOnState(List<Map<String, String>> filteredDictations) {
    switch (_recordingState) {
      case RecordingState.idle:
        return _buildIdle(filteredDictations);
      case RecordingState.recording:
        return _buildRecording();
      case RecordingState.paused:
        return _buildPaused();
      case RecordingState.stopped:
        return _buildStopped();
    }
  }

  Widget _buildIdle(List<Map<String, String>> filteredDictations) {
    return Column(
      children: [
        const SizedBox(height: 60),
        DictationButton(
          onPressed: () {
            if (_isRecorderInitialized) {
              _startRecording();
            }
          },
          icon: Icons.mic_none_rounded,
          backgroundColor: Colors.grey[400]!,
          iconColor: Colors.black87,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, color: AppColors.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              _isRecorderInitialized
                  ? 'To start dictation press button'
                  : 'Initializing recorder...',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 40),
        _buildPreviousDictationsUI(filteredDictations),
      ],
    );
  }

  Widget _buildRecording() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'Recording: ${_formatTime(_recordingTime)}',
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        const SizedBox(height: 30),
        DictationButton(
          onPressed: _pauseRecording,
          icon: Icons.fiber_manual_record,
          backgroundColor: AppColors.primaryColor,
          iconColor: Colors.white,
        ),
        const SizedBox(height: 40),
        _buildActionButtons(
          stop: _stopRecording,
          pause: _pauseRecording,
          cancel: _cancelRecording,
        ),
        const SizedBox(height: 20),
        _buildDictationArea(),
      ],
    );
  }

  Widget _buildPaused() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text('Paused', style: TextStyle(color: AppColors.primaryColor)),
        const SizedBox(height: 30),
        DictationButton(
          onPressed: _resumeRecording,
          icon: Icons.pause,
          backgroundColor: Colors.grey[400]!,
          iconColor: Colors.black,
        ),
        const SizedBox(height: 40),
        _buildActionButtons(
          stop: _stopRecording,
          resume: _resumeRecording,
          cancel: _cancelRecording,
        ),
        const SizedBox(height: 20),
        _buildDictationArea(),
      ],
    );
  }

  Widget _buildStopped() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Recording stopped',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        const SizedBox(height: 30),
        DictationButton(
          onPressed: () {},
          icon: Icons.stop,
          backgroundColor: Colors.grey[400]!,
          iconColor: Colors.black,
        ),
        const SizedBox(height: 40),
        _buildActionButtons(
          stop: _cancelRecording, // Yahan stop ko cancel ke liye use kiya
          save: _saveToPatientFolder,
          cancel: _cancelRecording,
        ),
        const SizedBox(height: 20),
        _buildDictationArea(),
      ],
    );
  }

  Widget _buildActionButtons({
    Function? stop,
    Function? pause,
    Function? resume,
    Function? cancel,
    Function? save,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceEvenly, // Buttons ko evenly distribute karein
        children: [
          if (stop != null)
            Expanded(
              child: ControlButton(
                text: 'Stop',
                onPressed: stop as void Function(),
                backgroundColor: AppColors.cancelledEventColor,
              ),
            ),
          SizedBox(width: 8), // Buttons ke darmiyan space
          if (pause != null)
            Expanded(
              child: ControlButton(
                text: 'Pause',
                onPressed: pause as void Function(),
                backgroundColor: AppColors.pendingTaskColor,
              ),
            ),
          if (resume != null)
            Expanded(
              child: ControlButton(
                text: 'Resume',
                onPressed: resume as void Function(),
                backgroundColor: AppColors.completedTaskColor,
              ),
            ),
          SizedBox(width: 8),
          if (save != null)
            Expanded(
              child: ControlButton(
                text: 'Save',
                onPressed: save as void Function(),
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          if (cancel != null)
            Expanded(
              child: ControlButton(
                text: 'Cancel',
                onPressed: cancel as void Function(),
                backgroundColor: AppColors.cancelButtonColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDictationArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LabeledTextField(
        maxline: 7,
        hintText: 'your dictation will appear here...',
        controller: _dictationText,
      ),
    );
  }

  Widget _buildPreviousDictationsUI(
    List<Map<String, String>> filteredDictations,
  ) {
    if (filteredDictations.isEmpty && _searchQuery.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.block, size: 50, color: Colors.grey),
            Text(
              'No previous dictations yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    if (filteredDictations.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 50, color: Colors.grey),
            Text(
              'No dictations found for "$_searchQuery"',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Previous Dictations:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height:
              300, // Fixed height for ListView to avoid rendering issues with SingleChildScrollView
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: filteredDictations.length,
            itemBuilder: (ctx, i) {
              final d = filteredDictations[i];
              return DictationItem(
                fileName: d['fileName'] ?? '',
                date: d['date'] ?? '',
                time: d['time'] ?? '',
                onTap: () async {
                  if (d['fileUrl'] != null && d['fileUrl']!.isNotEmpty) {
                    final fixedFilePath = d['fileUrl']!.replaceAll(r'\', '/');
                    final fullUrl =
                        '${ApiConstants.imageBaseUrl}$fixedFilePath';

                    print('📂 Downloading and opening: $fullUrl');

                    // Loader yahan bhi dikha sakte hain agar file download mein time lagta hai
                    // setState(() { _isLoading = true; });

                    try {
                      final dir = await getTemporaryDirectory();
                      final fileName = fullUrl.split('/').last;
                      final filePath = '${dir.path}/$fileName';

                      await Dio().download(fullUrl, filePath);

                      final result = await OpenFilex.open(filePath);
                      print('✅ Opened: ${result.message}');
                    } catch (e) {
                      print('❌ Error opening file: $e');
                      // Error message dikha sakte hain
                    } finally {
                      // setState(() { _isLoading = false; });
                    }
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
