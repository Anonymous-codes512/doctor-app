// lib/screens/incoming_call_screen.dart
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_app/provider/call_provider.dart'; // Apni CallProvider ka path theek karein

class IncomingCallScreen extends StatefulWidget {
  final Map<String, dynamic> callData;

  const IncomingCallScreen({Key? key, required this.callData})
    : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  late final String callerId;
  late final String callerName;
  late final int callRecordId;
  late final String callType;

  @override
  void initState() {
    super.initState();
    callerId = widget.callData['caller_id'].toString();
    callerName = widget.callData['caller_name'] ?? 'Unknown Caller';
    callRecordId = widget.callData['call_record_id'] ?? 0;
    callType = widget.callData['call_type'] ?? 'Audio';
  }

  void _acceptCall(BuildContext context) {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    callProvider.handleCallAccepted({
      'caller_id': callerId,
      'receiver_id': callProvider.otherUserId.toString(),
      'call_record_id': callRecordId,
      'caller_name': callerName,
      'call_status': 'accepted',
      'call_type': callType,
    });
    Navigator.of(context).pop();
  }

  void _rejectCall(BuildContext context) {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    callProvider.endCall(
      callStatus: 'rejected',
      context: context,
    ); // CallProvider ka method call karein
    Navigator.of(context).pop(); // Incoming call screen band karein
  }

  @override
  Widget build(BuildContext context) {
    print('📞📞📞incoming call screen called ${widget.callData}');
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: AppColors.primaryColor.withOpacity(0.3),
              child: const Icon(Icons.person, size: 70, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Text(
              callerName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Incoming $callType Call',
              style: TextStyle(
                fontSize: 22,
                color: AppColors.textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag:
                          'rejectCallFab', // Yahan unique tag diya gaya hai
                      onPressed: () => _rejectCall(context),
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.call_end, size: 35),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag:
                          'acceptCallFab', // Yahan unique tag diya gaya hai
                      onPressed: () => _acceptCall(context),
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.call, size: 35),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
