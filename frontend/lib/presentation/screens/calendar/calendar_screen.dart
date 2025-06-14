import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/screens/calendar/calendar_filter_popup.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

enum ViewType { grid, list }

enum CalendarFilter { day, month, year, addTask, addAppointment }

class _CalendarScreenState extends State<CalendarScreen> {
  ViewType currentView = ViewType.list;
  CalendarFilter selectedFilter = CalendarFilter.day;
  String selectedTab = 'Appointments';
  DateTime? _selectedCalendarDay; // To hold the dynamically selected day

  static const double _buttonHeight = 50;
  static const double _horizontalPadding = 16;
  static const double _spacing = 16;

  final List<Map<String, dynamic>> appointmentsData = [
    {
      'time': '09:00 am',
      'patientName': 'Lisa Smith',
      'status': 'Confirmed',
      'statusColor': Colors.green,
      'imageUrl': 'https://i.pravatar.cc/150?img=5',
      'consultationNotes': '',
      'day': 'Monday',
      'date': DateTime(2024, 2, 1),
    },
    {
      'time': '09:00 am',
      'patientName': 'Lisa Smith',
      'status': 'Cancelled',
      'statusColor': Colors.red,
      'imageUrl': 'https://i.pravatar.cc/150?img=5',
      'consultationNotes': '',
      'day': 'Monday',
      'date': DateTime(2024, 2, 5),
    },
    {
      'time': '09:00 am',
      'patientName': 'John Doe',
      'status': 'Confirmed',
      'statusColor': Colors.green,
      'imageUrl': 'https://i.pravatar.cc/150?img=3',
      'consultationNotes': '',
      'day': 'Monday',
      'date': DateTime(2024, 2, 8),
    },
    {
      'time': '09:00 am',
      'patientName': 'John Doe',
      'status': 'Confirmed',
      'statusColor': Colors.green,
      'imageUrl': 'https://i.pravatar.cc/150?img=3',
      'consultationNotes': '',
      'day': 'Monday',
      'date': DateTime(2024, 2, 16),
    },
    {
      'time': '09:00 am',
      'patientName': 'John Doe',
      'status': 'Cancelled',
      'statusColor': Colors.red,
      'imageUrl': 'https://i.pravatar.cc/150?img=3',
      'consultationNotes': '',
      'day': 'Monday',
      'date': DateTime(2024, 1, 8),
    },
    {
      'time': '09:00 am',
      'patientName': 'John Doe',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'imageUrl': 'https://i.pravatar.cc/150?img=3',
      'consultationNotes': '',
      'day': 'Tuesday',
      'date': DateTime(2024, 1, 16),
    },
  ];

  final List<Map<String, dynamic>> tasksData = [
    {
      'time': '09:00 am',
      'taskName': 'Morning Exercise',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Monday',
      'date': DateTime(2024, 2, 3),
    },
    {
      'time': '09:00 am',
      'taskName': 'Team Meeting',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Monday',
      'date': DateTime(2024, 2, 5),
    },
    {
      'time': '09:00 am',
      'taskName': 'Review Budget Proposal',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Monday',
      'date': DateTime(2024, 2, 16),
    },
    {
      'time': '08:00 am',
      'taskName': 'Reply to Emails',
      'status': 'Completed',
      'statusColor': Colors.green,
      'day': 'Monday',
      'date': DateTime(2024, 2, 29),
    },
    {
      'time': '10:00 am',
      'taskName': 'Prepare Presentation',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'day': 'Tuesday',
      'date': DateTime(2024, 1, 3),
    },
  ];

  List<Map<String, dynamic>> get mondayAppointments =>
      appointmentsData.where((app) => app['day'] == 'Monday').toList();

  List<Map<String, dynamic>> get tuesdayAppointments =>
      appointmentsData.where((app) => app['day'] == 'Tuesday').toList();

  List<Map<String, dynamic>> get mondayTasks =>
      tasksData.where((task) => task['day'] == 'Monday').toList();

  List<Map<String, dynamic>> get tuesdayTasks =>
      tasksData.where((task) => task['day'] == 'Tuesday').toList();

  void _onFilterChanged(CalendarFilter filter) {
    setState(() {
      selectedFilter = filter;
      // Reset view type if switching to month/year
      if (filter == CalendarFilter.month || filter == CalendarFilter.year) {
        currentView = ViewType.list;
      }
    });

    // Navigate to the new screens based on filter
    if (filter == CalendarFilter.addTask) {
      Navigator.pushNamed(context, Routes.addNewTaskScreen);
    } else if (filter == CalendarFilter.addAppointment) {
      Navigator.pushNamed(context, Routes.addNewAppointmentScreen);
    }
  }

  // Task action methods
  void _markTaskCompleted(Map<String, dynamic> task) {
    setState(() {
      task['status'] = 'Completed';
      task['statusColor'] = Colors.green;
    });
    // print('Task marked as completed: ${task['taskName']}'); // Removed debug print
  }

  void _onViewToggle(ViewType view) {
    setState(() {
      currentView = view;
    });
  }

  void _onTabChanged(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  void _rescheduleTask(Map<String, dynamic> task) {
    // print('Reschedule task: ${task['taskName']}'); // Removed debug print
    // Add logic for rescheduling task
  }

  void _cancelTask(Map<String, dynamic> task) {
    // print('Cancel task: ${task['taskName']}'); // Removed debug print
    // Add logic for canceling task
  }

  // Appointment action methods
  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    // print('View details for ${appointment['patientName']}'); // Removed debug print
    // Add logic to navigate or show a detailed view
  }

  void _rescheduleAppointment(Map<String, dynamic> appointment) {
    // print('Reschedule appointment for ${appointment['patientName']}'); // Removed debug print
    // Add logic for rescheduling appointment
  }

  void _cancelAppointment(Map<String, dynamic> appointment) {
    // print('Cancel appointment for ${appointment['patientName']}'); // Removed debug print
    // Add logic for canceling appointment
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
              border: Border.all(
                color: AppColors.borderColor,
              ), // Centralized color
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.iconColor,
                ), // Centralized color
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
            icon: Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CalendarFilterPopup(),
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
        Expanded(child: _buildFilterButton('Day', CalendarFilter.day)),
        const SizedBox(width: 2),
        Expanded(child: _buildFilterButton('Month', CalendarFilter.month)),
        const SizedBox(width: 2),
        Expanded(child: _buildFilterButton('Year', CalendarFilter.year)),
        const SizedBox(width: 2),
        Expanded(
          child: _buildActionButton('Add\nTask', CalendarFilter.addTask),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: _buildActionButton(
            'Add\nAppointment',
            CalendarFilter.addAppointment,
          ),
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
          color:
              isSelected
                  ? AppColors.primaryColor
                  : AppColors.buttonBgColor, // Centralized color
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                isSelected
                    ? Colors.white
                    : AppColors.textColor, // Centralized color
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
        decoration: BoxDecoration(
          color: AppColors.buttonBgColor, // Centralized color
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textColor, // Centralized color
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Tab Bar Widget
  Widget _buildTabBar() {
    return Row(
      children: [
        _buildTab(
          'Appointments',
          selectedTab == 'Appointments',
          () => _onTabChanged('Appointments'),
        ),
        SizedBox(width: _spacing / 1.5),
        _buildTab(
          'Tasks',
          selectedTab == 'Tasks',
          () => _onTabChanged('Tasks'),
        ),
      ],
    );
  }

  Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  isSelected
                      ? AppColors.primaryColor
                      : AppColors.secondaryTextColor, // Centralized color
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 2,
            width: text.length * 8.0,
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // Toggle Buttons for Grid/List View
  Widget _buildToggleButtons() {
    // Hide toggle buttons for month and year views
    if (selectedFilter == CalendarFilter.month ||
        selectedFilter == CalendarFilter.year) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.grid_view),
          color:
              currentView == ViewType.grid
                  ? AppColors.primaryColor
                  : AppColors.iconColor, // Centralized color
          onPressed: () => _onViewToggle(ViewType.grid),
        ),
        IconButton(
          icon: Icon(Icons.list),
          color:
              currentView == ViewType.list
                  ? AppColors.primaryColor
                  : AppColors.iconColor, // Centralized color
          onPressed: () => _onViewToggle(ViewType.list),
        ),
      ],
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Icon(Icons.check, color: Colors.white, size: 16);
      case 'cancelled':
        return const Icon(Icons.close, color: Colors.white, size: 16);
      case 'pending':
        return const Icon(Icons.schedule, color: Colors.white, size: 16);
      case 'completed':
        return const Icon(Icons.check, color: Colors.white, size: 16);
      default:
        return const Icon(Icons.help, color: Colors.white, size: 16);
    }
  }

  // Filtered Content Widget for the main calendar view
  Widget _buildContentList() {
    if (selectedFilter == CalendarFilter.day) {
      return Column(
        children: [
          if (selectedTab == 'Appointments')
            _buildDayViewContent(
              mondayAppointments,
              tuesdayAppointments,
              _buildAppointmentCard,
            ),
          if (selectedTab == 'Tasks')
            _buildDayViewContent(mondayTasks, tuesdayTasks, _buildTaskCard),
        ],
      );
    }
    if (selectedFilter == CalendarFilter.month) {
      return _buildMonthView();
    } else if (selectedFilter == CalendarFilter.year) {
      return _buildYearView();
    }
    return const SizedBox.shrink();
  }

  Widget _buildDayViewContent(
    List<Map<String, dynamic>> mondayData,
    List<Map<String, dynamic>> tuesdayData,
    Widget Function(Map<String, dynamic>) cardBuilder,
  ) {
    if (currentView == ViewType.list) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mondayData.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.infoColor),
              ),
              child: Column(
                children: [
                  _buildDayHeader('Monday'),
                  ...mondayData.map(cardBuilder),
                ],
              ),
            ),
            const SizedBox(height: _spacing),
          ],
          if (tuesdayData.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.infoColor),
              ),
              child: Column(
                children: [
                  _buildDayHeader('Tuesday'),
                  ...tuesdayData.map(cardBuilder),
                ],
              ),
            ),
          ],
        ],
      );
    } else {
      // Grid view
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mondayData.isNotEmpty) ...[
            _buildDayHeader('Monday'),
            selectedTab == 'Appointments'
                ? _buildAppointmentTableHeader()
                : _buildTaskTableHeader(),
            ...mondayData.map(
              (data) =>
                  selectedTab == 'Appointments'
                      ? _buildAppointmentTableRow(data)
                      : _buildTaskTableRow(data),
            ),
            const SizedBox(height: 24),
          ],
          if (tuesdayData.isNotEmpty) ...[
            _buildDayHeader('Tuesday'),
            selectedTab == 'Appointments'
                ? _buildAppointmentTableHeader()
                : _buildTaskTableHeader(),
            ...tuesdayData.map(
              (data) =>
                  selectedTab == 'Appointments'
                      ? _buildAppointmentTableRow(data)
                      : _buildTaskTableRow(data),
            ),
          ],
        ],
      );
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

  Widget _buildAppointmentTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor),
        ), // Centralized color
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Patient',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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

  Widget _buildTaskTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor),
        ), // Centralized color
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedTab == 'Appointments'
              ? '$monthName appointments'
              : '$monthName Tasks',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        _buildCalendarGrid(now),
      ],
    );
  }

  // Year View Widget
  Widget _buildYearView() {
    DateTime now = DateTime.now();
    String currentYear = now.year.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedTab == 'Appointments'
              ? '$currentYear appointments' // Dynamically show current year
              : '$currentYear Tasks', // Dynamically show current year
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        _buildCalendarGrid(
          DateTime(now.year, 1, 1),
        ), // Start from Jan 1st of current year
      ],
    );
  }

  // Calendar Grid Widget
  Widget _buildCalendarGrid(DateTime currentMonth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [_buildWeekDaysHeader(), _buildCalendarDays(currentMonth)],
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              AppColors.secondaryTextColor, // Centralized color
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  // Calendar Days Grid
  Widget _buildCalendarDays(DateTime currentMonth) {
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
        ),
      );
    }

    // Add days of current month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      dayWidgets.add(_buildCalendarDay(date, true));
    }

    // Add empty cells to complete the grid
    while (dayWidgets.length % 7 != 0) {
      DateTime lastDayInGrid =
          dayWidgets.last.key != null
              ? (dayWidgets.last.key as ValueKey<DateTime>).value
              : DateTime(
                currentMonth.year,
                currentMonth.month + 1,
                0,
              ); // Fallback

      dayWidgets.add(
        _buildCalendarDay(lastDayInGrid.add(const Duration(days: 1)), false),
      );
    }

    // Group days into weeks
    List<Widget> weeks = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      weeks.add(Row(children: dayWidgets.sublist(i, i + 7)));
    }

    return Column(children: weeks);
  }

  // Individual Calendar Day Widget
  Widget _buildCalendarDay(DateTime fullDate, bool isCurrentMonth) {
    bool isToday = DateUtils.isSameDay(fullDate, DateTime.now());
    bool isSelected = DateUtils.isSameDay(fullDate, _selectedCalendarDay);

    List<Map<String, dynamic>> dayEvents = [];

    if (isCurrentMonth) {
      // Get events for this day
      if (selectedTab == 'Appointments') {
        dayEvents =
            appointmentsData.where((apt) {
              DateTime aptDate = apt['date'];
              return DateUtils.isSameDay(aptDate, fullDate);
            }).toList();
      } else {
        dayEvents =
            tasksData.where((task) {
              DateTime taskDate = task['date'];
              return DateUtils.isSameDay(taskDate, fullDate);
            }).toList();
      }
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
          height: 80,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.primaryColor
                    : (isToday
                        ? AppColors.todayHighlightColor
                        : Colors.transparent), // Centralized color
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
                              : AppColors
                                  .disabledTextColor), // Centralized color
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
                                selectedTab == 'Appointments'
                                    ? _getStatusAbbreviation(event['status'])
                                    : _getTaskAbbreviation(event['taskName']),
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
    if (selectedTab == 'Appointments') {
      switch (event['status'].toLowerCase()) {
        case 'confirmed':
          return AppColors.confirmedEventColor;
        case 'cancelled':
          return AppColors.cancelledEventColor;
        case 'pending':
          return AppColors.pendingEventColor;
        default:
          return Colors.grey;
      }
    } else {
      switch (event['status'].toLowerCase()) {
        case 'completed':
          return AppColors.completedTaskColor;
        case 'pending':
          return AppColors.pendingTaskColor;
        default:
          return Colors.grey;
      }
    }
  }

  String _getStatusAbbreviation(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'C';
      case 'cancelled':
        return 'X';
      case 'pending':
        return 'P';
      default:
        return '?';
    }
  }

  String _getTaskAbbreviation(String taskName) {
    List<String> words = taskName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].substring(0, 2).toUpperCase();
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

  // Appointments Card Widget for List View
  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: _spacing),
      padding: const EdgeInsets.all(_spacing),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(appointment['imageUrl']),
              ),
              const SizedBox(width: _spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment['patientName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment['time'],
                      style: TextStyle(
                        color:
                            AppColors.secondaryTextColor, // Centralized color
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.message_outlined),
                    onPressed: () {
                      // Handle message action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.email_outlined),
                    onPressed: () {
                      // Handle email action
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: appointment['statusColor'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              appointment['status'],
              style: TextStyle(
                color: appointment['statusColor'],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: _spacing),
          Row(
            children: [
              Expanded(
                child: _buildActionButtonCard(
                  'View Details',
                  AppColors.buttonBgColor, // Centralized color
                  AppColors.textColor, // Centralized color
                  () => _showAppointmentDetails(appointment),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButtonCard(
                  'Reschedule',
                  appointment['status'] == 'Cancelled'
                      ? AppColors.disabledButtonColor
                      : AppColors.tertiaryButtonColor, // Centralized color
                  Colors.white,
                  appointment['status'] == 'Cancelled'
                      ? null
                      : () => _rescheduleAppointment(appointment),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButtonCard(
                  'Cancel',
                  appointment['status'] == 'Cancelled'
                      ? AppColors.disabledButtonColor
                      : AppColors.cancelButtonColor, // Centralized color
                  Colors.white,
                  appointment['status'] == 'Cancelled'
                      ? null
                      : () => _cancelAppointment(appointment),
                ),
              ),
            ],
          ),
          const SizedBox(height: _spacing),
          const Text(
            'Consultation Notes:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.borderColor,
              ), // Centralized color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Add notes for this appointment here...',
              style: TextStyle(
                color: AppColors.disabledTextColor,
                fontSize: 14,
              ), // Centralized color
            ),
          ),
        ],
      ),
    );
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
                      style: TextStyle(
                        color:
                            AppColors.secondaryTextColor, // Centralized color
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
                  AppColors.tertiaryButtonColor, // Centralized color
                  Colors.white,
                  () => _rescheduleTask(task),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButtonCard(
                  'Cancel',
                  AppColors.cancelButtonColor, // Centralized color
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

  Widget _buildAppointmentTableRow(Map<String, dynamic> appointment) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.dividerColor),
        ), // Centralized color
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              appointment['time'],
              style: const TextStyle(fontSize: 14, color: AppColors.textColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              appointment['patientName'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: appointment['statusColor'],
                shape: BoxShape.circle,
              ),
              child: _getStatusIcon(appointment['status']),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: AppColors.iconColor,
              ), // Centralized color
              onPressed: () => _showActionMenu(appointment),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
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
        border: Border(
          bottom: BorderSide(color: AppColors.dividerColor),
        ), // Centralized color
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
              icon: Icon(
                Icons.more_vert,
                color: AppColors.iconColor,
              ), // Centralized color
              onPressed: () => _showTaskActionMenu(task),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // Action menu for appointment
  void _showActionMenu(Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(_spacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showAppointmentDetails(appointment);
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Reschedule'),
                onTap: () {
                  Navigator.pop(context);
                  _rescheduleAppointment(appointment);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                  _cancelAppointment(appointment);
                },
              ),
            ],
          ),
        );
      },
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
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textColor,
          ), // Centralized color
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Calendar',
          style: TextStyle(
            color: AppColors.textColor, // Centralized color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: AppColors.textColor,
            ), // Centralized color
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
            Row(
              children: [
                Expanded(child: _buildTabBar()),
                _buildToggleButtons(),
              ],
            ),
            const SizedBox(height: _spacing),

            // Content
            Expanded(child: SingleChildScrollView(child: _buildContentList())),
            const SizedBox(height: 25), // Consider making this a constant
          ],
        ),
      ),
    );
  }
}
