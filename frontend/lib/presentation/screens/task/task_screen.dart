import 'dart:math';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/screens/task/task_filter_popup.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _CalendarScreenState();
}

enum ViewType { grid, list }

enum CalendarFilter {
  day,
  week,
  month,
  year,
  addTask,
  addAppointment,
} // Added 'week' to enum

class _CalendarScreenState extends State<TaskScreen> {
  ViewType currentView = ViewType.list;
  CalendarFilter selectedFilter = CalendarFilter.day;
  DateTime? _selectedCalendarDay;

  static const double _buttonHeight = 50;
  static const double _horizontalPadding = 16;
  static const double _spacing = 16;

  final List<Map<String, dynamic>> tasksData = [
    {
      'time': '09:00 am',
      'taskName': 'Morning Exercise',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Monday',
      'date': DateTime(2025, 6, 5), // Example: Monday of current week
    },
    {
      'time': '10:30 am',
      'taskName': 'Review Documents',
      'status': 'Completed',
      'statusColor': Colors.green,
      'day': 'Tuesday',
      'date': DateTime(2025, 6, 6), // Example: Tuesday of current week
    },
    {
      'time': '11:00 am',
      'taskName': 'Team Meeting',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Wednesday',
      'date': DateTime(2025, 6, 4), // Example: Today
    },
    {
      'time': '02:00 pm',
      'taskName': 'Prepare Presentation',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Wednesday',
      'date': DateTime(2025, 6, 4), // Example: Today
    },
    {
      'time': '03:30 pm',
      'taskName': 'Client Call',
      'status': 'Confirmed',
      'statusColor':
          Colors.blue, // Using blue for 'Confirmed' tasks (new status color)
      'day': 'Thursday',
      'date': DateTime(2025, 6, 5), // Example: Thursday of current week
    },
    {
      'time': '08:00 am',
      'taskName': 'Reply to Emails',
      'status': 'Completed',
      'statusColor': Colors.green,
      'day': 'Friday',
      'date': DateTime(2025, 6, 6), // Example: Friday of current week
    },
    {
      'time': '09:00 am',
      'taskName': 'Weekly Report',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Saturday',
      'date': DateTime(2025, 6, 7), // Example: Saturday of current week
    },
    {
      'time': '09:00 am',
      'taskName': 'Weekend Planning',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Sunday',
      'date': DateTime(2025, 6, 8), // Example: Sunday of current week
    },
    {
      'time': '09:00 am',
      'taskName': 'Monthly Review',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Monday',
      'date': DateTime(2025, 7, 14), // Example: Next month
    },
    {
      'time': '10:00 am',
      'taskName': 'Annual Audit Prep',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Tuesday',
      'date': DateTime(2026, 1, 15), // Example: Next year
    },
  ];

  void _onFilterChanged(CalendarFilter filter) {
    setState(() {
      selectedFilter = filter;
      // For month/year, force grid view. For day/week, allow toggling.
      if (filter == CalendarFilter.month || filter == CalendarFilter.year) {
        currentView = ViewType.grid; // Calendar view is always grid-like
      } else {
        currentView =
            ViewType.list; // Default to list for day/week, user can toggle
      }
    });

    // Navigate to the new screens based on filter
    if (filter == CalendarFilter.addTask) {
      Navigator.pushNamed(context, Routes.addNewTaskScreen);
    } else if (filter == CalendarFilter.addAppointment) {
      Navigator.pushNamed(context, Routes.addNewAppointmentScreen);
    }
  }

  // Helper method to get tasks for a specific day
  List<Map<String, dynamic>> _getTasksForDay(DateTime day) {
    return tasksData.where((task) {
      DateTime taskDate = task['date'];
      return DateUtils.isSameDay(taskDate, day);
    }).toList();
  }

  // Task action methods
  void _markTaskCompleted(Map<String, dynamic> task) {
    setState(() {
      task['status'] = 'Completed';
      task['statusColor'] = Colors.green;
    });
  }

  void _onViewToggle(ViewType view) {
    setState(() {
      currentView = view;
    });
  }

  void _rescheduleTask(Map<String, dynamic> task) {
    // Add logic for rescheduling task
  }

  void _cancelTask(Map<String, dynamic> task) {
    // Add logic for canceling task
  }

  // Search Bar Widget
  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search, color: AppColors.iconColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: _spacing / 1.5),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) =>
                        const TaskFilterPopup(), // Ensure correct popup
              );
            },
          ),
        ),
      ],
    );
  }

  // Filter Buttons Widget
  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildFilterButton('Today', CalendarFilter.day)),
        const SizedBox(width: 2),
        Expanded(
          child: _buildFilterButton('Week', CalendarFilter.week),
        ), // Changed filter to CalendarFilter.week
        const SizedBox(width: 2),
        Expanded(
          child: _buildFilterButton('Month', CalendarFilter.month),
        ), // Corrected month filter
        const SizedBox(width: 2),
        Expanded(child: _buildFilterButton('Year', CalendarFilter.year)),
        const SizedBox(width: 2),
        Expanded(
          child: _buildActionButton('Add\nTask', CalendarFilter.addTask),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String text, CalendarFilter filter) {
    final isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () => _onFilterChanged(filter),
      child: Container(
        alignment: Alignment.center,
        height: _buttonHeight,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.buttonBgColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, CalendarFilter filter) {
    return GestureDetector(
      onTap: () => _onFilterChanged(filter),
      child: Container(
        alignment: Alignment.center,
        height: _buttonHeight,
        decoration: const BoxDecoration(color: AppColors.buttonBgColor),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textColor,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Toggle Buttons for Grid/List View
  Widget _buildToggleButtons() {
    // Hide toggle buttons for month and year views as they use a fixed calendar grid
    if (selectedFilter == CalendarFilter.month ||
        selectedFilter == CalendarFilter.year) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.grid_view),
          color:
              currentView == ViewType.grid
                  ? AppColors.primaryColor
                  : AppColors.iconColor,
          onPressed: () => _onViewToggle(ViewType.grid),
        ),
        IconButton(
          icon: const Icon(Icons.list),
          color:
              currentView == ViewType.list
                  ? AppColors.primaryColor
                  : AppColors.iconColor,
          onPressed: () => _onViewToggle(ViewType.list),
        ),
      ],
    );
  }

  // Filtered Content Widget for the main calendar view
  Widget _buildContentList() {
    if (selectedFilter == CalendarFilter.day) {
      DateTime today = DateTime.now();
      List<Map<String, dynamic>> todayTasks = _getTasksForDay(today);
      if (todayTasks.isEmpty) {
        return _buildNoTasksMessage('No tasks for today.');
      }
      return _buildDayViewContent(
        tasks: todayTasks,
        dayHeader: _formatDayHeader(today),
        cardBuilder: _buildTaskCard,
      );
    } else if (selectedFilter == CalendarFilter.week) {
      return _buildWeekViewContent();
    } else if (selectedFilter == CalendarFilter.month) {
      return _buildMonthView();
    } else if (selectedFilter == CalendarFilter.year) {
      return _buildYearView();
    }
    return const SizedBox.shrink();
  }

  // New method for no tasks message
  Widget _buildNoTasksMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textColor.withOpacity(0.7),
        ),
      ),
    );
  }

  // Refactored _buildDayViewContent to be generic for any list of tasks
  Widget _buildDayViewContent({
    required List<Map<String, dynamic>> tasks,
    required String dayHeader,
    required Widget Function(Map<String, dynamic>) cardBuilder,
  }) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink(); // Don't show header if no tasks
    }

    if (currentView == ViewType.list) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.infoColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildDayHeader(dayHeader), ...tasks.map(cardBuilder)],
        ),
      );
    } else {
      // Grid view
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayHeader(dayHeader),
          _buildTaskTableHeader(),
          ...tasks.map((data) => _buildTaskTableRow(data)),
        ],
      );
    }
  }

  // New method for building week view content
  Widget _buildWeekViewContent() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(
      Duration(days: now.weekday - 1),
    ); // Monday

    List<Widget> weekDayWidgets = [];
    bool hasTasksInWeek = false;

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      List<Map<String, dynamic>> dayTasks = _getTasksForDay(day);

      if (dayTasks.isNotEmpty) {
        hasTasksInWeek = true;
        weekDayWidgets.add(
          _buildDayViewContent(
            tasks: dayTasks,
            dayHeader: _formatDayHeader(day),
            cardBuilder: _buildTaskCard,
          ),
        );
        if (i < 6) {
          // Add spacing between days, but not after the last day
          weekDayWidgets.add(const SizedBox(height: _spacing));
        }
      }
    }

    if (!hasTasksInWeek) {
      return _buildNoTasksMessage('No tasks for this week.');
    }

    return Column(children: weekDayWidgets);
  }

  // Helper to format day headers (reused from AppointmentScreen)
  String _formatDayHeader(DateTime date) {
    DateTime now = DateTime.now();
    if (DateUtils.isSameDay(date, now)) {
      return 'Today';
    } else if (DateUtils.isSameDay(date, now.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else if (DateUtils.isSameDay(
      date,
      now.subtract(const Duration(days: 1)),
    )) {
      return 'Yesterday';
    } else {
      return '${_getWeekdayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)}';
    }
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  Widget _buildDayHeader(String day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        day,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _buildTaskTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Month View Calendar Widget
  Widget _buildMonthView() {
    DateTime now = DateTime.now();
    String monthName = _getMonthName(now.month);
    int currentYear = now.year;

    // Filter tasks for the current month
    List<Map<String, dynamic>> monthTasks =
        tasksData.where((task) {
          DateTime taskDate = task['date'];
          return taskDate.year == currentYear && taskDate.month == now.month;
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$monthName $currentYear Tasks', // Updated header
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        _buildCalendarGrid(now, monthTasks), // Pass filtered tasks
      ],
    );
  }

  // Year View Widget
  Widget _buildYearView() {
    DateTime now = DateTime.now();
    String currentYear = now.year.toString();

    // Filter tasks for the current year
    List<Map<String, dynamic>> yearTasks =
        tasksData.where((task) {
          DateTime taskDate = task['date'];
          return taskDate.year == now.year;
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$currentYear Tasks',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        _buildCalendarGrid(
          DateTime(now.year, 1, 1), // Start from Jan 1st of current year
          yearTasks, // Pass filtered tasks for the year
        ),
      ],
    );
  }

  // Calendar Grid Widget - now accepts tasks list
  Widget _buildCalendarGrid(
    DateTime currentMonth,
    List<Map<String, dynamic>> filteredTasks,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildWeekDaysHeader(),
          _buildCalendarDays(currentMonth, filteredTasks),
        ],
      ),
    );
  }

  // Week Days Header
  Widget _buildWeekDaysHeader() {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: _spacing),
      child: Row(
        children:
            weekDays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  // Calendar Days Grid - now uses filteredTasks
  Widget _buildCalendarDays(
    DateTime currentMonth,
    List<Map<String, dynamic>> filteredTasks,
  ) {
    List<Widget> dayWidgets = [];

    // Get first day of month and calculate starting position
    DateTime firstDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );
    // Adjust weekday to be 0-indexed where Monday is 0
    int startingWeekday = (firstDayOfMonth.weekday - 1 + 7) % 7;

    // Get days in current month
    int daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    // Add empty cells for days before month starts
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(
        _buildCalendarDay(
          firstDayOfMonth.subtract(Duration(days: startingWeekday - i)),
          false,
          filteredTasks, // Pass filtered tasks
        ),
      );
    }

    // Add days of current month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      dayWidgets.add(
        _buildCalendarDay(date, true, filteredTasks),
      ); // Pass filtered tasks
    }

    // Add empty cells to complete the grid
    while (dayWidgets.length % 7 != 0) {
      DateTime lastDayInGrid =
          dayWidgets.isNotEmpty && dayWidgets.last.key is ValueKey<DateTime>
              ? (dayWidgets.last.key as ValueKey<DateTime>).value
              : DateTime(
                currentMonth.year,
                currentMonth.month + 1,
                0,
              ); // Fallback

      dayWidgets.add(
        _buildCalendarDay(
          lastDayInGrid.add(const Duration(days: 1)),
          false,
          filteredTasks,
        ), // Pass filtered tasks
      );
    }

    // Group days into weeks
    List<Widget> weeks = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      weeks.add(Row(children: dayWidgets.sublist(i, i + 7)));
    }

    return Column(children: weeks);
  }

  // Individual Calendar Day Widget - now uses filteredTasks
  Widget _buildCalendarDay(
    DateTime fullDate,
    bool isCurrentMonth,
    List<Map<String, dynamic>> filteredTasks,
  ) {
    bool isToday = DateUtils.isSameDay(fullDate, DateTime.now());
    bool isSelected = DateUtils.isSameDay(fullDate, _selectedCalendarDay);

    List<Map<String, dynamic>> dayEvents = [];

    if (isCurrentMonth) {
      dayEvents =
          filteredTasks.where((task) {
            // Use filteredTasks here
            DateTime taskDate = task['date'];
            return DateUtils.isSameDay(taskDate, fullDate);
          }).toList();
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isCurrentMonth) {
            setState(() {
              _selectedCalendarDay = fullDate;
            });
          }
        },
        child: Container(
          key: ValueKey(fullDate), // Added a ValueKey
          height: 80,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.primaryColor
                    : (isToday
                        ? AppColors.todayHighlightColor
                        : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                fullDate.day.toString(),
                style: TextStyle(
                  fontSize: isCurrentMonth ? 16 : 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected
                          ? Colors.white
                          : (isCurrentMonth
                              ? AppColors.textColor
                              : AppColors.disabledTextColor),
                ),
              ),
              const SizedBox(height: 4),
              if (dayEvents.isNotEmpty) ...[
                Expanded(
                  child: Column(
                    children:
                        dayEvents.take(3).map((event) {
                          return Container(
                            width: double.infinity,
                            height: 12,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: _getEventColor(event),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Text(
                                _getTaskAbbreviation(event['taskName']),
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getEventColor(Map<String, dynamic> event) {
    switch (event['status'].toLowerCase()) {
      case 'completed':
        return AppColors.completedTaskColor;
      case 'pending':
        return AppColors.pendingTaskColor;
      case 'confirmed': // Added confirmed status color for tasks
        return AppColors.primaryColor;
      default:
        return Colors.grey;
    }
  }

  String _getTaskAbbreviation(String taskName) {
    List<String> words = taskName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0]
          .substring(0, min(2, words[0].length))
          .toUpperCase(); // Handle shorter words
    }
    return 'T';
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  // Task Card Widget for List View
  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: _spacing),
      padding: const EdgeInsets.all(_spacing),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['taskName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task['time'],
                      style: const TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: task['statusColor'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task['status'],
                  style: TextStyle(
                    color: task['statusColor'],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _spacing),
          Row(
            children: [
              Expanded(
                child: _buildActionButtonCard(
                  'Mark Completed',
                  task['status'] == 'Completed'
                      ? AppColors.disabledButtonColor
                      : AppColors.primaryColor,
                  Colors.white,
                  task['status'] == 'Completed'
                      ? null
                      : () => _markTaskCompleted(task),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButtonCard(
                  'Reschedule',
                  AppColors.tertiaryButtonColor,
                  Colors.white,
                  () => _rescheduleTask(task),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButtonCard(
                  'Cancel',
                  AppColors.cancelButtonColor,
                  Colors.white,
                  () => _cancelTask(task),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonCard(
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback? onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTaskTableRow(Map<String, dynamic> task) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              task['taskName'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              task['time'],
              style: const TextStyle(fontSize: 14, color: AppColors.textColor),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
              onPressed: () => _showTaskActionMenu(task),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // Action menu for task
  void _showTaskActionMenu(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(_spacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Mark Completed'),
                onTap: () {
                  Navigator.pop(context);
                  _markTaskCompleted(task);
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Reschedule'),
                onTap: () {
                  Navigator.pop(context);
                  _rescheduleTask(task);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                  _cancelTask(task);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Task',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textColor),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(_spacing),
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(context),
            const SizedBox(height: _spacing),

            // Filter Buttons
            _buildFilterButtons(),
            const SizedBox(height: _spacing),

            // Tab Bar and View Toggle
            Row(children: [_buildToggleButtons()]),
            const SizedBox(height: _spacing),

            // Content
            Expanded(child: SingleChildScrollView(child: _buildContentList())),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
