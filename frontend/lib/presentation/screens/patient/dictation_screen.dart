import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/dictation_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';

enum RecordingState { idle, recording, paused, stopped }

class DictationScreen extends StatefulWidget {
  const DictationScreen({Key? key}) : super(key: key);

  @override
  State<DictationScreen> createState() => _DictationScreenState();
}

class _DictationScreenState extends State<DictationScreen> {
  RecordingState _recordingState = RecordingState.idle;
  Timer? _timer;
  int _recordingTime = 0;
  String _dictationText = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _previousDictations = [
    {'fileName': 'prescription', 'date': '20/01/25', 'time': '03:20pm'},
    {'fileName': 'follow up', 'date': '20/01/25', 'time': '03:20pm'},
    {'fileName': 'prescription', 'date': '20/01/25', 'time': '03:20pm'},
    {'fileName': 'consultation', 'date': '20/01/25', 'time': '03:20pm'},
    {'fileName': 'checkup', 'date': '20/01/25', 'time': '03:20pm'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Map<String, String>> get _filteredDictations {
    if (_searchQuery.isEmpty) {
      return _previousDictations;
    }
    return _previousDictations.where((dictation) {
      final fileName = dictation['fileName']!.toLowerCase();
      final date = dictation['date']!.toLowerCase();
      return fileName.contains(_searchQuery) || date.contains(_searchQuery);
    }).toList();
  }

  void _startRecording() {
    setState(() {
      _recordingState = RecordingState.recording;
      _recordingTime = 0;
      _dictationText = '';
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingTime++;
      });
    });
  }

  void _pauseRecording() {
    setState(() {
      _recordingState = RecordingState.paused;
    });
    _timer?.cancel();
  }

  void _resumeRecording() {
    setState(() {
      _recordingState = RecordingState.recording;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingTime++;
      });
    });
  }

  void _stopRecording() {
    setState(() {
      _recordingState = RecordingState.stopped;
    });
    _timer?.cancel();
  }

  void _cancelRecording() {
    setState(() {
      _recordingState = RecordingState.idle;
      _recordingTime = 0;
      _dictationText = '';
    });
    _timer?.cancel();
  }

  void _saveToPatientFolder() {
    showDialog(
      context: context,
      builder:
          (context) => FileNameDialog(
            onSave: (fileName) {
              // Save the dictation with the given filename
              setState(() {
                _previousDictations.insert(0, {
                  'fileName': fileName.isEmpty ? 'Untitled' : fileName,
                  'date':
                      '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().substring(2)}',
                  'time':
                      '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                });
                _recordingState = RecordingState.idle;
                _recordingTime = 0;
                _dictationText = '';
              });
            },
          ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildIdleState() {
    return Column(
      children: [
        const SizedBox(height: 60),
        DictationButton(
          onPressed: _startRecording,
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
            const Text(
              'To start dictation press button',
              style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 40),
        _buildPreviousDictations(),
      ],
    );
  }

  Widget _buildRecordingState() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'Recording: ${_formatTime(_recordingTime)} sec',
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 30),
        DictationButton(
          onPressed: _pauseRecording,
          icon: Icons.fiber_manual_record,
          backgroundColor: AppColors.primaryColor,
          iconColor: Colors.white,
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ControlButton(
                text: 'Stop',
                onPressed: _stopRecording,
                backgroundColor: AppColors.cancelledEventColor,
              ),
              ControlButton(
                text: 'Pause',
                onPressed: _pauseRecording,
                backgroundColor: AppColors.pendingTaskColor,
              ),
              ControlButton(
                text: 'Cancel',
                onPressed: _cancelRecording,
                backgroundColor: AppColors.cancelButtonColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildDictationTextArea(),
      ],
    );
  }

  Widget _buildPausedState() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Paused',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 30),
        DictationButton(
          onPressed: _resumeRecording,
          icon: Icons.pause,
          backgroundColor: Colors.grey[400]!,
          iconColor: Colors.black,
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ControlButton(
                text: 'Stop',
                onPressed: _stopRecording,
                backgroundColor: AppColors.cancelledEventColor,
              ),
              ControlButton(
                text: 'Resume',
                onPressed: _resumeRecording,
                backgroundColor: AppColors.completedTaskColor,
              ),
              ControlButton(
                text: 'Cancel',
                onPressed: _cancelRecording,
                backgroundColor: AppColors.cancelButtonColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildDictationTextArea(),
      ],
    );
  }

  Widget _buildStoppedState() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Recording stopped',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 30),
        DictationButton(
          onPressed: () {}, // No action for stopped state
          icon: Icons.stop,
          backgroundColor: Colors.grey[400]!,
          iconColor: Colors.black,
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ControlButton(
                text: 'Stop',
                onPressed: _cancelRecording,
                backgroundColor: AppColors.cancelledEventColor,
              ),
              ControlButton(
                text: 'Save',
                onPressed: _saveToPatientFolder,
                backgroundColor: AppColors.primaryColor,
              ),
              ControlButton(
                text: 'Cancel',
                onPressed: _cancelRecording,
                backgroundColor: AppColors.cancelButtonColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildDictationTextArea(),
      ],
    );
  }

  Widget _buildDictationTextArea() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _dictationText.isEmpty
            ? 'your dictation will appear here...'
            : _dictationText,
        style: TextStyle(
          fontSize: 16,
          color: _dictationText.isEmpty ? Colors.grey[500] : Colors.black,
        ),
      ),
    );
  }

  Widget _buildPreviousDictations() {
    final filteredDictations = _filteredDictations;

    if (filteredDictations.isEmpty && _searchQuery.isNotEmpty) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Previous Dictations:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No dictations found for "$_searchQuery"',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (_previousDictations.isEmpty) {
      return Column(
        children: [
          const Text(
            'Previous Dictations:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Icon(Icons.block, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No previous dictations yet',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Previous Dictations:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (_searchQuery.isNotEmpty)
                Text(
                  '${filteredDictations.length} of ${_previousDictations.length}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: filteredDictations.length,
            itemBuilder: (context, index) {
              final dictation = filteredDictations[index];
              return DictationItem(
                fileName: dictation['fileName']!,
                date: dictation['date']!,
                time: dictation['time']!,
                onTap: () {
                  // Handle tap on dictation item
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dictation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
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
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),

          // Title with sound icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dictation',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.graphic_eq, color: Colors.grey[600]),
              ],
            ),
          ),

          const Divider(height: 40),

          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child:
                  _recordingState == RecordingState.idle
                      ? _buildIdleState()
                      : _recordingState == RecordingState.recording
                      ? _buildRecordingState()
                      : _recordingState == RecordingState.paused
                      ? _buildPausedState()
                      : _buildStoppedState(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
