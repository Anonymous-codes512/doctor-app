import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/screens/video/video_calling_screen.dart';
import 'package:doctor_app/presentation/screens/voice/calling_screen.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final TextEditingController _controller = TextEditingController(text: '+92');

  void _onKeyPressed(String value) {
    setState(() {
      _controller.text += value;
    });
  }

  void _clearInput() {
    setState(() {
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dialpadData = [
      ['1', ''],
      ['2', 'ABC'],
      ['3', 'DEF'],
      ['4', 'GHI'],
      ['5', 'JKL'],
      ['6', 'MNO'],
      ['7', 'PQRS'],
      ['8', 'TUV'],
      ['9', 'WXYZ'],
      ['*', ''],
      ['0', '+'],
      ['#', ''],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEEE9F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon:
                      _controller.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearInput,
                          )
                          : null,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: AppColors.infoColor.withValues(alpha: 0.1),
                border: const Border(
                  top: BorderSide(color: AppColors.infoColor, width: 1),
                  bottom: BorderSide(color: AppColors.infoColor, width: 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  '02:39 am IST, 21 Oct, Monday',
                  style: TextStyle(fontSize: 14, color: AppColors.textColor),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dialpad
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                itemCount: dialpadData.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final digit = dialpadData[index][0];
                  final subText = dialpadData[index][1];
                  return GestureDetector(
                    onTap: () => _onKeyPressed(digit),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          digit,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subText.isNotEmpty)
                          Text(
                            subText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        const Divider(thickness: 0.6),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomButton(Icons.videocam, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoCallingScreen(),
                      ),
                    );
                  }, 'Video call'),
                  _buildBottomButton(Icons.message, () {}, 'Message'),
                  _buildBottomButton(
                    Icons.call,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CallingScreen(),
                        ),
                      );
                    },
                    'Voice call',
                    color: AppColors.successColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(
    IconData icon,
    void Function()? onPressed,
    String label, {
    Color color = AppColors.iconBackgroundColor,
  }) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            elevation: 4,
          ),
          onPressed: onPressed,
          child: Icon(icon, color: Colors.white),
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
