import 'dart:math';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/presentation/screens/appointment/appointment_filter_popup.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
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

class _AppointmentScreenState extends State<AppointmentScreen> {
  ViewType currentView = ViewType.list;
  CalendarFilter selectedFilter = CalendarFilter.day;
  DateTime? _selectedCalendarDay;

  late DoctorProvider _doctorProvider;
  bool _isLoading = false;

  static const double _buttonHeight = 50;
  static const double _horizontalPadding = 16;
  static const double _spacing = 16;

  @override
  void initState() {
    super.initState();
    _doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    _selectedCalendarDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      await _doctorProvider.loadAppointments();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onFilterChanged(CalendarFilter filter) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      selectedFilter = filter;
      // Reset view type to list for day and week views, if not already.
      // For month/year, it will always be the calendar grid, so currentView is irrelevant.
      if (filter == CalendarFilter.month || filter == CalendarFilter.year) {
        currentView = ViewType.list;
      } else {
        currentView = ViewType.grid;
      }
      _isLoading = false;
    });

    if (filter == CalendarFilter.addAppointment) {
      Navigator.pushNamed(context, Routes.addNewAppointmentScreen);
    }
  }

  // Helper method to get appointments for a specific day
  List<AppointmentModel> _getAppointmentsForDay(
    DateTime day,
    List<AppointmentModel> appointments,
  ) {
    return appointments.where((app) {
      return DateUtils.isSameDay(app.appointmentDate, day);
    }).toList();
  }

  void _onViewToggle(ViewType view) {
    setState(() {
      currentView = view;
    });
  }

  void _showAppointmentDetails(AppointmentModel appointment) {
    // Add logic to navigate or show a detailed view
  }

  void _rescheduleAppointment(AppointmentModel appointment) {
    // Add logic for rescheduling appointment
  }

  void _cancelAppointment(AppointmentModel appointment) {
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
        Expanded(child: _buildFilterButton('Week', CalendarFilter.week)),
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

  Widget _buildContentList(List<AppointmentModel> allAppointments) {
    if (selectedFilter == CalendarFilter.day) {
      DateTime today = DateTime.now();
      List<AppointmentModel> todayAppointments = _getAppointmentsForDay(
        today,
        allAppointments,
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
      return _buildWeekViewContent(allAppointments);
    } else if (selectedFilter == CalendarFilter.month) {
      return _buildMonthView(allAppointments);
    } else if (selectedFilter == CalendarFilter.year) {
      return _buildYearView(allAppointments);
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

  Widget _buildDayViewContent({
    required List<AppointmentModel> appointments,
    required String dayHeader,
    required Widget Function(AppointmentModel) cardBuilder,
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
  Widget _buildWeekViewContent(List<AppointmentModel> allAppointments) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(
      Duration(days: now.weekday - 1),
    ); // Monday

    List<Widget> weekDayWidgets = [];
    bool hasAppointmentsInWeek = false;

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      List<AppointmentModel> dayAppointments = _getAppointmentsForDay(
        day,
        allAppointments,
      );

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
  Widget _buildMonthView(List<AppointmentModel> allAppointments) {
    DateTime now = DateTime.now();
    String monthName = _getMonthName(now.month);
    int currentYear = now.year;

    // Filter appointments for the current month
    List<AppointmentModel> monthAppointments =
        allAppointments.where((app) {
          return app.appointmentDate.year == currentYear &&
              app.appointmentDate.month == now.month;
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
  Widget _buildYearView(List<AppointmentModel> allAppointments) {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    List<Widget> yearMonthsWidgets = [];
    bool hasAppointmentInYear = false;

    for (int month = 1; month <= 12; month++) {
      DateTime monthDateTime = DateTime(currentYear, month, 1);
      List<AppointmentModel> yearAppointments =
          allAppointments.where((app) {
            return app.appointmentDate.year == now.year &&
                app.appointmentDate.month == month;
          }).toList();
      if (yearAppointments.isNotEmpty) {
        hasAppointmentInYear = true;
      }

      yearMonthsWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getMonthName(month)} $currentYear Appointments',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: _spacing),
            _buildCalendarGrid(monthDateTime, yearAppointments),
            const SizedBox(height: _spacing * 2), // Spacing between months
          ],
        ),
      );
    }
    if (!hasAppointmentInYear) {
      return _buildNoAppointmentsMessage('No Appointments for this year.');
    }
    return Column(children: yearMonthsWidgets);
  }

  // Calendar Grid Widget - now accepts appointments list
  Widget _buildCalendarGrid(
    DateTime currentMonth,
    List<AppointmentModel> filteredAppointments,
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

  Widget _buildCalendarDays(
    DateTime currentMonth,
    List<AppointmentModel> filteredAppointments,
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
    List<AppointmentModel> filteredAppointments,
  ) {
    bool isToday = DateUtils.isSameDay(fullDate, DateTime.now());
    bool isSelected = DateUtils.isSameDay(fullDate, _selectedCalendarDay);

    List<AppointmentModel> dayEvents = [];

    if (isCurrentMonth) {
      dayEvents =
          filteredAppointments.where((apt) {
            return DateUtils.isSameDay(apt.appointmentDate, fullDate);
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
          key: ValueKey(fullDate),
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
                                event.patientName,
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

  Color _getEventColor(AppointmentModel event) {
    switch (event.patientName.toLowerCase()) {
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.confirmedEventColor;
      case 'cancelled':
        return AppColors.cancelButtonColor;
      case 'pending':
        return AppColors.pendingEventColor;
      case 'completed':
        return AppColors.completedTaskColor;
      default:
        return Colors.grey;
    }
  }

  // Appointments Card Widget for List View
  Widget _buildAppointmentCard(AppointmentModel appointment) {
    int rand = Random().nextInt(1000);
    final String imageUrl = 'https://i.pravatar.cc/$rand';
    final String status = 'Confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: _spacing),
      padding: const EdgeInsets.all(_spacing),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 25, backgroundImage: NetworkImage(imageUrl)),
              const SizedBox(width: _spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${appointment.appointmentTime.hour.toString().padLeft(2, '0')}:${appointment.appointmentTime.minute.toString().padLeft(2, '0')}',

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
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: _getStatusColor(status),
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
                  status == 'Cancelled'
                      ? AppColors.disabledButtonColor
                      : AppColors.tertiaryButtonColor,
                  Colors.white,
                  status == 'Cancelled'
                      ? null
                      : () => _rescheduleAppointment(appointment),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButtonCard(
                  'Cancel',
                  status == 'Cancelled'
                      ? AppColors.disabledButtonColor
                      : AppColors.cancelButtonColor,
                  Colors.white,
                  status == 'Cancelled'
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
              appointment.description.isEmpty
                  ? 'Add notes for this appointment here...'
                  : appointment.description,
              style: TextStyle(
                color:
                    appointment.description.isEmpty
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

  Widget _buildAppointmentTableRow(AppointmentModel appointment) {
    final String status = 'Confirmed';
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
              '${appointment.appointmentTime.hour.toString().padLeft(2, '0')}:${appointment.appointmentTime.minute.toString().padLeft(2, '0')}',

              style: const TextStyle(fontSize: 14, color: AppColors.textColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              appointment.patientName,
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
                color: _getStatusColor(status),
                shape: BoxShape.circle,
              ),
              child: _getStatusIcon(status),
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
  void _showActionMenu(AppointmentModel appointment) {
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
            Expanded(
              child: SingleChildScrollView(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Consumer<DoctorProvider>(
                          builder: (context, doctorProvider, child) {
                            List<AppointmentModel> filteredAppointments = [];
                            if (selectedFilter == CalendarFilter.day) {
                              filteredAppointments =
                                  doctorProvider.appointments.where((appt) {
                                    return DateUtils.isSameDay(
                                      appt.appointmentDate,
                                      _selectedCalendarDay ?? DateTime.now(),
                                    );
                                  }).toList();
                            } else if (selectedFilter == CalendarFilter.week) {
                              filteredAppointments =
                                  doctorProvider.getAppointmentsForWeek();
                            } else if (selectedFilter == CalendarFilter.month) {
                              filteredAppointments =
                                  doctorProvider.getAppointmentsForMonth();
                            } else if (selectedFilter == CalendarFilter.year) {
                              filteredAppointments =
                                  doctorProvider.getAppointmentsForYear();
                            }

                            if (filteredAppointments.isEmpty &&
                                selectedFilter != CalendarFilter.year) {
                              String message = '';
                              if (selectedFilter == CalendarFilter.day) {
                                message = 'No appointment for today.';
                              } else if (selectedFilter ==
                                  CalendarFilter.week) {
                                message = 'No appointment for this week.';
                              } else if (selectedFilter ==
                                  CalendarFilter.month) {
                                message = 'No appointment for this month.';
                              } else if (selectedFilter ==
                                  CalendarFilter.year) {
                                // Message for year view is handled within _buildYearView
                                message = 'No appointment for this year.';
                              }
                              return _buildNoAppointmentsMessage(message);
                            } else if (filteredAppointments.isEmpty &&
                                selectedFilter == CalendarFilter.year) {
                              // For year view, we still want to show all 12 months even if no tasks
                              return SingleChildScrollView(
                                child: _buildYearView(filteredAppointments),
                              );
                            }

                            return SingleChildScrollView(
                              child: _buildContentList(filteredAppointments),
                            );
                          },
                        ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
