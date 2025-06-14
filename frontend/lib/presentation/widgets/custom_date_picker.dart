import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final String? label;

  const CustomDatePicker({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
    this.label,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime selectedDate;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;

    // Initialize controllers with current date positions
    dayController = FixedExtentScrollController(
      initialItem: selectedDate.day - 1,
    );
    monthController = FixedExtentScrollController(
      initialItem: selectedDate.month - 1,
    );
    yearController = FixedExtentScrollController(
      initialItem: selectedDate.year - 1950,
    );
  }

  int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _updateDate() {
    widget.onDateChanged(selectedDate);
  }

  void _onDayChanged(int index) {
    final maxDays = getDaysInMonth(selectedDate.year, selectedDate.month);
    final day = (index + 1).clamp(1, maxDays);
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
    });
    _updateDate();
  }

  void _onMonthChanged(int index) {
    final month = index + 1;
    final maxDays = getDaysInMonth(selectedDate.year, month);
    final day = selectedDate.day.clamp(1, maxDays);
    setState(() {
      selectedDate = DateTime(selectedDate.year, month, day);
    });
    _updateDate();

    // Update day controller if current day exceeds max days in new month
    if (selectedDate.day != day) {
      dayController.animateToItem(
        day - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onYearChanged(int index) {
    final year = 1950 + index;
    final maxDays = getDaysInMonth(year, selectedDate.month);
    final day = selectedDate.day.clamp(1, maxDays);
    setState(() {
      selectedDate = DateTime(year, selectedDate.month, day);
    });
    _updateDate();

    // Update day controller if current day exceeds max days in new year (leap year case)
    if (selectedDate.day != day) {
      dayController.animateToItem(
        day - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxDays = getDaysInMonth(selectedDate.year, selectedDate.month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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
              // Date Display Header
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${selectedDate.day}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    DateFormat('MMMM').format(selectedDate),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${selectedDate.year}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Scrollable Date Pickers
              SizedBox(
                height: 120,
                child: Row(
                  children: [
                    // Day Picker
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            'Day',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: dayController,
                              itemExtent: 40,
                              physics: FixedExtentScrollPhysics(),
                              onSelectedItemChanged: _onDayChanged,
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index < 0 || index >= maxDays) {
                                    return null;
                                  }
                                  final day = index + 1;
                                  final isSelected = day == selectedDate.day;
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '$day',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Month Picker
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            'Month',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: monthController,
                              itemExtent: 40,
                              physics: FixedExtentScrollPhysics(),
                              onSelectedItemChanged: _onMonthChanged,
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index < 0 || index >= 12) return null;
                                  final month = DateFormat(
                                    'MMMM',
                                  ).format(DateTime(2023, index + 1));
                                  final isSelected =
                                      index + 1 == selectedDate.month;
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      month,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Year Picker
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            'Year',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: yearController,
                              itemExtent: 40,
                              physics: FixedExtentScrollPhysics(),
                              onSelectedItemChanged: _onYearChanged,
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index < 0 || index >= 100) return null;
                                  final year = 1950 + index;
                                  final isSelected = year == selectedDate.year;
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$year',
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
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }
}
