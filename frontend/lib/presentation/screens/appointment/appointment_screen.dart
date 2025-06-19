import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/screens/appointment/appointment_filter_popup.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _CalendarScreenState();
}

enum ViewType { grid, list }

enum CalendarFilter {
  day,
  week,
  month,
  year,
  addTask,
  addAppointment,
} // Changed 'month' to 'week' for filter

class _CalendarScreenState extends State<AppointmentScreen> {
  ViewType currentView = ViewType.list;
  CalendarFilter selectedFilter = CalendarFilter.day;
  DateTime?
  _selectedCalendarDay; // Used for single day selection in calendar grid

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
      'date': DateTime(2025, 6, 5), // Updated to current week
    },
    {
      'time': '10:30 am',
      'patientName': 'David Lee',
      'status': 'Cancelled',
      'statusColor': Colors.red,
      'imageUrl': 'https://i.pravatar.cc/150?img=6',
      'consultationNotes': '',
      'day': 'Monday',
      'date': DateTime(2025, 6, 8), // Updated to current week
    },
    {
      'time': '11:00 am',
      'patientName': 'Emily White',
      'status': 'Confirmed',
      'statusColor': Colors.green,
      'imageUrl': 'https://i.pravatar.cc/150?img=7',
      'consultationNotes': '',
      'day': 'Tuesday',
      'date': DateTime(2025, 5, 4), // Updated to current week
    },
    {
      'time': '02:00 pm',
      'patientName': 'Michael Brown',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'imageUrl': 'https://i.pravatar.cc/150?img=8',
      'consultationNotes': '',
      'day': 'Wednesday',
      'date': DateTime(2025, 6, 5), // Updated to current week
    },
    {
      'time': '03:30 pm',
      'patientName': 'Sophia Green',
      'status': 'Confirmed',
      'statusColor': Colors.green,
      'imageUrl': 'https://i.pravatar.cc/150?img=9',
      'consultationNotes': '',
      'day': 'Thursday',
      'date': DateTime(2024, 6, 6), // Updated to current week
    },
    {
      'time': '09:00 am',
      'patientName': 'John Doe',
      'status': 'Confirmed',
      'statusColor': Colors.green,
      'imageUrl': 'https://i.pravatar.cc/150?img=3',
      'consultationNotes': '',
      'day': 'Friday',
      'date': DateTime(2024, 6, 7), // Example appointment for a future date
    },
    {
      'time': '09:00 am',
      'patientName': 'John Doe',
      'status': 'Cancelled',
      'statusColor': Colors.red,
      'imageUrl': 'https://i.pravatar.cc/150?img=3',
      'consultationNotes': '',
      'day': 'Saturday',
      'date': DateTime(2024, 6, 8), // Example appointment for a future date
    },
    {
      'time': '09:00 am',
      'patientName': 'John Doe',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'imageUrl': 'https://i.pravatar.cc/150?img=3',
      'consultationNotes': '',
      'day': 'Sunday',
      'date': DateTime(2024, 6, 9), // Example appointment for a future date
    },
    {
      'time': '09:00 am',
      'patientName': 'Another Patient',
      'status': 'Confirmed',
      'statusColor': Colors.green,
      'imageUrl': 'https://i.pravatar.cc/150?img=10',
      'consultationNotes': '',
      'day': 'Monday',
      'date': DateTime(2024, 7, 15), // Appointment for next month
    },
    {
      'time': '10:00 am',
      'patientName': 'Future Patient',
      'status': 'Confirmed',
      'statusColor': Colors.green,
      'imageUrl': 'https://i.pravatar.cc/150?img=11',
      'consultationNotes': '',
      'day': 'Wednesday',
      'date': DateTime(2025, 1, 10), // Appointment for next year
    },
  ];

  void _onFilterChanged(CalendarFilter filter) {
    setState(() {
      selectedFilter = filter;
      // Reset view type to list for day and week views, if not already.
      // For month/year, it will always be the calendar grid, so currentView is irrelevant.
      if (filter == CalendarFilter.day || filter == CalendarFilter.week) {
        currentView =
            ViewType.list; // Default to list for day/week, user can toggle
      } else {
        currentView = ViewType.grid; // Force grid view for month/year calendar
      }
    });

    // Navigate to the new screens based on filter
    if (filter == CalendarFilter.addAppointment) {
      Navigator.pushNamed(context, Routes.addNewAppointmentScreen);
    }
  }

  // Helper method to get appointments for a specific day
  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    return appointmentsData.where((app) {
      DateTime appDate = app['date'];
      return DateUtils.isSameDay(appDate, day);
    }).toList();
  }

  void _onViewToggle(ViewType view) {
    setState(() {
      currentView = view;
    });
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    // Add logic to navigate or show a detailed view
  }

  void _rescheduleAppointment(Map<String, dynamic> appointment) {
    // Add logic for rescheduling appointment
  }

  void _cancelAppointment(Map<String, dynamic> appointment) {
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
                builder: (context) => AppointmentFilterPopup(),
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
        Expanded(child: _buildFilterButton('Month', CalendarFilter.month)),
        const SizedBox(width: 2),
        Expanded(child: _buildFilterButton('Year', CalendarFilter.year)),
        const SizedBox(width: 2),
        Expanded(
          child: _buildActionButton('Add\nAppointment', CalendarFilter.addTask),
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
      onTap: () {
        Navigator.pushNamed(context, Routes.addNewAppointmentScreen);
      },
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
      DateTime today = DateTime.now();
      List<Map<String, dynamic>> todayAppointments = _getAppointmentsForDay(
        today,
      );
      if (todayAppointments.isEmpty) {
        return _buildNoAppointmentsMessage('No appointments for today.');
      }
      return _buildDayViewContent(
        appointments: todayAppointments,
        dayHeader: _formatDayHeader(today), // Format today's date
        cardBuilder: _buildAppointmentCard,
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

  // New method for no appointments message
  Widget _buildNoAppointmentsMessage(String message) {
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

  // Refactored _buildDayViewContent to be generic
  Widget _buildDayViewContent({
    required List<Map<String, dynamic>> appointments,
    required String dayHeader,
    required Widget Function(Map<String, dynamic>) cardBuilder,
  }) {
    if (appointments.isEmpty) {
      return const SizedBox.shrink(); // Don't show header if no appointments
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
          children: [
            _buildDayHeader(dayHeader),
            ...appointments.map(cardBuilder),
          ],
        ),
      );
    } else {
      // Grid view
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayHeader(dayHeader),
          _buildAppointmentTableHeader(),
          ...appointments.map((data) => _buildAppointmentTableRow(data)),
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
    bool hasAppointmentsInWeek = false;

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      List<Map<String, dynamic>> dayAppointments = _getAppointmentsForDay(day);

      if (dayAppointments.isNotEmpty) {
        hasAppointmentsInWeek = true;
        weekDayWidgets.add(
          _buildDayViewContent(
            appointments: dayAppointments,
            dayHeader: _formatDayHeader(day),
            cardBuilder: _buildAppointmentCard,
          ),
        );
        if (i < 6) {
          // Add spacing between days, but not after the last day
          weekDayWidgets.add(const SizedBox(height: _spacing));
        }
      }
    }

    if (!hasAppointmentsInWeek) {
      return _buildNoAppointmentsMessage('No appointments for this week.');
    }

    return Column(children: weekDayWidgets);
  }

  // Helper to format day headers
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

  Widget _buildAppointmentTableHeader() {
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

  // Month View Calendar Widget
  Widget _buildMonthView() {
    DateTime now = DateTime.now();
    String monthName = _getMonthName(now.month);
    int currentYear = now.year;

    // Filter appointments for the current month
    List<Map<String, dynamic>> monthAppointments =
        appointmentsData.where((app) {
          DateTime appDate = app['date'];
          return appDate.year == currentYear && appDate.month == now.month;
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$monthName $currentYear appointments',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        _buildCalendarGrid(now, monthAppointments),
      ],
    );
  }

  // Year View Widget
  Widget _buildYearView() {
    DateTime now = DateTime.now();
    String currentYear = now.year.toString();

    // Filter appointments for the current year
    List<Map<String, dynamic>> yearAppointments =
        appointmentsData.where((app) {
          DateTime appDate = app['date'];
          return appDate.year == now.year;
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$currentYear appointments',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        _buildCalendarGrid(
          DateTime(now.year, 1, 1), // Start from Jan 1st of current year
          yearAppointments, // Pass filtered appointments for the year
        ),
      ],
    );
  }

  // Calendar Grid Widget - now accepts appointments list
  Widget _buildCalendarGrid(
    DateTime currentMonth,
    List<Map<String, dynamic>> filteredAppointments,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildWeekDaysHeader(),
          _buildCalendarDays(currentMonth, filteredAppointments),
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

  // Calendar Days Grid - now uses filteredAppointments
  Widget _buildCalendarDays(
    DateTime currentMonth,
    List<Map<String, dynamic>> filteredAppointments,
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
          filteredAppointments,
        ),
      );
    }

    // Add days of current month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      dayWidgets.add(_buildCalendarDay(date, true, filteredAppointments));
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
          filteredAppointments,
        ),
      );
    }

    // Group days into weeks
    List<Widget> weeks = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      weeks.add(Row(children: dayWidgets.sublist(i, i + 7)));
    }

    return Column(children: weeks);
  }

  // Individual Calendar Day Widget - now uses filteredAppointments
  Widget _buildCalendarDay(
    DateTime fullDate,
    bool isCurrentMonth,
    List<Map<String, dynamic>> filteredAppointments,
  ) {
    bool isToday = DateUtils.isSameDay(fullDate, DateTime.now());
    bool isSelected = DateUtils.isSameDay(fullDate, _selectedCalendarDay);

    List<Map<String, dynamic>> dayEvents = [];

    if (isCurrentMonth) {
      dayEvents =
          filteredAppointments.where((apt) {
            DateTime aptDate = apt['date'];
            return DateUtils.isSameDay(aptDate, fullDate);
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
          key: ValueKey(
            fullDate,
          ), // Added a ValueKey for better performance and uniqueness
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
                SizedBox(
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
                                _getStatusAbbreviation(event['status']),
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
      case 'confirmed':
        return AppColors.confirmedEventColor;
      case 'cancelled':
        return AppColors.cancelledEventColor;
      case 'pending':
        return AppColors.pendingEventColor;
      default:
        return Colors.grey;
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
                      style: const TextStyle(
                        color: AppColors.secondaryTextColor,
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
                  AppColors.buttonBgColor,
                  AppColors.textColor,
                  () => _showAppointmentDetails(appointment),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButtonCard(
                  'Reschedule',
                  appointment['status'] == 'Cancelled'
                      ? AppColors.disabledButtonColor
                      : AppColors.tertiaryButtonColor,
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
                      : AppColors.cancelButtonColor,
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
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              appointment['consultationNotes'].isEmpty
                  ? 'Add notes for this appointment here...'
                  : appointment['consultationNotes'],
              style: TextStyle(
                color:
                    appointment['consultationNotes'].isEmpty
                        ? AppColors.disabledTextColor
                        : AppColors.textColor,
                fontSize: 14,
              ),
            ),
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
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
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
              icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
              onPressed: () => _showActionMenu(appointment),
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
          'My Appointments',
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
