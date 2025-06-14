import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final String? label;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
    this.label,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TimeOfDay selectedTime;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController amPmController; // For AM/PM selection

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;

    // Convert 24-hour initialTime to 12-hour format for display and controller initialization
    int initialHour12 = selectedTime.hourOfPeriod; // 1-12
    // If it's 12 AM (0 hour), the hourOfPeriod is 12, and the period is AM.
    // If it's 12 PM (12 hour), the hourOfPeriod is 12, and the period is PM.
    // So, initialItem for hourController should be `hour12 - 1` (0-indexed for 1-12).
    // The initialAmPmIndex is 0 for AM, 1 for PM.
    int initialAmPmIndex = selectedTime.period == DayPeriod.am ? 0 : 1;

    hourController = FixedExtentScrollController(
      initialItem: initialHour12 - 1,
    );
    minuteController = FixedExtentScrollController(
      initialItem: selectedTime.minute,
    );
    amPmController = FixedExtentScrollController(initialItem: initialAmPmIndex);
  }

  void _updateTime() {
    widget.onTimeChanged(selectedTime);
  }

  void _onHourChanged(int index) {
    // Convert 0-11 index to 1-12 hour format
    int hour12 = index + 1; // This gives 1-12

    // Convert to 24-hour format based on current AM/PM period
    int newHour24;
    if (selectedTime.period == DayPeriod.am) {
      newHour24 =
          hour12 == 12 ? 0 : hour12; // 12 AM (hour 0), 1-11 AM (hour 1-11)
    } else {
      newHour24 =
          hour12 == 12
              ? 12
              : hour12 + 12; // 12 PM (hour 12), 1-11 PM (hour 13-23)
    }

    setState(() {
      selectedTime = TimeOfDay(hour: newHour24, minute: selectedTime.minute);
    });
    _updateTime();
  }

  void _onMinuteChanged(int index) {
    setState(() {
      selectedTime = TimeOfDay(hour: selectedTime.hour, minute: index);
    });
    _updateTime();
  }

  void _onAmPmChanged(int index) {
    final newPeriod = index == 0 ? DayPeriod.am : DayPeriod.pm;

    // Adjust hour based on AM/PM change while preserving time of day logic
    int newHour = selectedTime.hour;
    if (selectedTime.period == DayPeriod.am && newPeriod == DayPeriod.pm) {
      // If current time is 12 AM (hour 0), it becomes 12 PM (hour 12)
      // Otherwise, add 12 hours (e.g., 1 AM -> 1 PM, i.e., hour 1 -> hour 13)
      newHour = (newHour == 0) ? 12 : (newHour + 12);
    } else if (selectedTime.period == DayPeriod.pm &&
        newPeriod == DayPeriod.am) {
      // If current time is 12 PM (hour 12), it becomes 12 AM (hour 0)
      // Otherwise, subtract 12 hours (e.g., 1 PM -> 1 AM, i.e., hour 13 -> hour 1)
      newHour = (newHour == 12) ? 0 : (newHour - 12);
    }

    setState(() {
      selectedTime = TimeOfDay(hour: newHour, minute: selectedTime.minute);
    });
    _updateTime();
  }

  @override
  Widget build(BuildContext context) {
    // Format the selected time for display
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final String formattedTime = localizations.formatTimeOfDay(
      selectedTime,
      alwaysUse24HourFormat: false, // Ensure 12-hour format with AM/PM
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        if (widget.label != null) const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Time Display Header (similar to Date Display Header in DatePicker)
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Center the time display
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey[600],
                  ), // Clock icon
                  const SizedBox(width: 8),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ), // Larger font for readability
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Scrollable Time Pickers
              SizedBox(
                height: 120, // Keep consistent height with date picker
                child: Row(
                  children: [
                    // Hour Picker
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            'Hour', // Label directly above the picker
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: hourController,
                              itemExtent: 40,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: _onHourChanged,
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index < 0 || index >= 12) {
                                    return null; // Hours 1-12
                                  }
                                  final hour =
                                      index + 1; // Convert 0-indexed to 1-12
                                  final isSelected =
                                      hour == selectedTime.hourOfPeriod;
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      hour.toString().padLeft(
                                        2,
                                        '0',
                                      ), // Format as 01, 02, etc.
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.black
                                                : Colors.grey,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                                childCount: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Minute Picker
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            'Minute', // Label directly above the picker
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: minuteController,
                              itemExtent: 40,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: _onMinuteChanged,
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index < 0 || index >= 60) {
                                    return null; // Minutes 0-59
                                  }
                                  final minute = index;
                                  final isSelected =
                                      minute == selectedTime.minute;
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      minute.toString().padLeft(
                                        2,
                                        '0',
                                      ), // Format as 00, 01, etc.
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.black
                                                : Colors.grey,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                                childCount: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // AM/PM Picker
                    Expanded(
                      flex:
                          1, // Give it some flex so it aligns better with others
                      child: Column(
                        children: [
                          Text(
                            'Period', // Label directly above the picker
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: amPmController,
                              itemExtent: 40,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: _onAmPmChanged,
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index < 0 || index >= 2) return null;
                                  final period = index == 0 ? 'AM' : 'PM';
                                  final isSelected =
                                      (index == 0 &&
                                          selectedTime.period ==
                                              DayPeriod.am) ||
                                      (index == 1 &&
                                          selectedTime.period == DayPeriod.pm);
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      period,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.black
                                                : Colors.grey,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                                childCount: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    amPmController.dispose();
    super.dispose();
  }
}
