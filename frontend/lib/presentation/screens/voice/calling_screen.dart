import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({
    super.key,
    required int callRecordId,
    required int callerId,
    required receiverId,
  });

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  bool isTranscribing = false;

  void _toggleTranscribe(bool value) async {
    setState(() {
      isTranscribing = value;
    });

    if (value) {
      await _showTranscriptionSheet();
    }
  }

  Future<void> _showTranscriptionSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TranscriptionBottomSheet(),
    );
    // Do NOT turn off toggle when sheet closes
  }

  void _openTranscriptionAgain() {
    if (isTranscribing) {
      _showTranscriptionSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEE9F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),

            const Text(
              'Calling...',
              style: TextStyle(fontSize: 14, color: AppColors.textColor),
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Transcribe',
                  style: TextStyle(fontSize: 14, color: AppColors.textColor),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: isTranscribing,
                  onChanged: _toggleTranscribe,
                  activeColor: AppColors.primaryColor,
                ),

                if (isTranscribing)
                  IconButton(
                    icon: const Icon(Icons.subdirectory_arrow_left),
                    tooltip: 'Open Transcription',
                    onPressed: _openTranscriptionAgain,
                  ),
              ],
            ),

            const SizedBox(height: 100),

            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.iconBackgroundColor,
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '+92 8622365663',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),

            const SizedBox(height: 100),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAction(Icons.bluetooth, 'Bluetooth'),
                  _buildAction(Icons.mic_off, 'Mute'),
                  _buildAction(Icons.volume_up, 'Speaker'),
                  _buildAction(Icons.person_add, 'Add'),
                ],
              ),
            ),

            const SizedBox(height: 100),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(18),
              ),
              child: const Icon(Icons.call_end, color: Colors.white),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.iconBackgroundColor,
          child: Icon(icon, color: AppColors.textColor),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textColor),
        ),
      ],
    );
  }
}

class TranscriptionBottomSheet extends StatelessWidget {
  const TranscriptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Align(
              //   alignment: Alignment.topRight,
              //   child: GestureDetector(
              //     onTap: () => Navigator.pop(context),
              //     child: const Icon(
              //       Icons.close,
              //       size: 28,
              //       color: AppColors.textColor,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),

              const Text(
                'Date: May 25, 2025',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Time: 10:30 AM',
                style: TextStyle(fontSize: 16, color: AppColors.textColor),
              ),
              const SizedBox(height: 4),
              const Text(
                'Patient: Sarah Ahmed',
                style: TextStyle(fontSize: 16, color: AppColors.textColor),
              ),
              const SizedBox(height: 4),
              const Text(
                'Psychiatrist: Dr. Khalid Mehmood',
                style: TextStyle(fontSize: 16, color: AppColors.textColor),
              ),

              const SizedBox(height: 24),

              const Text(
                'Call Transcription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.infoColor),
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.backgroundColor,
                  ),
                  child: SingleChildScrollView(
                    child: const Text(
                      '''Patient: I'm a bit anxious, to be honest. I had trouble sleeping last night.

Psychiatrist: I see. Can you tell me what was on your mind while trying to sleep?

Patient: I kept replaying some past conversations and worrying about work deadlines.

Psychiatrist: That's understandable. Let's talk through those thoughts one at a time.''',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
