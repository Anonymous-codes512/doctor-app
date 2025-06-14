import 'package:flutter/material.dart';

class TimeSelectorWidget extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimeSelectorWidget({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  _TimeSelectorWidgetState createState() => _TimeSelectorWidgetState();
}

class _TimeSelectorWidgetState extends State<TimeSelectorWidget> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = selectedTime.format(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time_outlined, color: Colors.grey[700]),
                const SizedBox(width: 12),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
