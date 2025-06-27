import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/data/models/task_model.dart';
import 'package:doctor_app/presentation/screens/calendar/calendar_filter_popup.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  bool _isLoading = false; // Add this line

  static const double _buttonHeight = 50;
  static const double _horizontalPadding = 16;
  static const double _spacing = 16;

  @override
  void initState() {
    super.initState();
    // Load appointments and tasks from provider
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    doctorProvider.loadAppointments();
    doctorProvider.loadTasks();
    _selectedCalendarDay = DateTime.now(); // Initialize with today
  }

  // Get filtered appointments based on the selected filter
  List<AppointmentModel> getFilteredAppointments() {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    switch (selectedFilter) {
      case CalendarFilter.day:
        return doctorProvider.getAppointmentsForWeek();
      case CalendarFilter.month:
        return doctorProvider
            .getAppointmentsForMonth(); // Already filters for current month
      case CalendarFilter.year:
        return doctorProvider
            .getAppointmentsForYear(); // Already filters for current year
      default:
        return doctorProvider.appointments;
    }
  }

  // Get filtered tasks based on the selected filter
  List<TaskModel> getFilteredTasks() {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    switch (selectedFilter) {
      case CalendarFilter.day:
        return doctorProvider.getTasksForWeek();
      case CalendarFilter.month:
        return doctorProvider
            .getTasksForMonth(); // Already filters for current month
      case CalendarFilter.year:
        return doctorProvider
            .getTasksForYear(); // Already filters for current year
      default:
        return doctorProvider.tasks;
    }
  }

  // Get the current week range
  List<DateTime> getWeekDays() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) {
      return startOfWeek.add(Duration(days: index));
    });
  }

  // Group appointments and tasks by the days of the current week
  Map<String, List<dynamic>> getWeekAppointmentsAndTasks() {
    final appointments = getFilteredAppointments();
    final tasks = getFilteredTasks();
    final weekDays = getWeekDays();
    Map<String, List<dynamic>> weekData = {};

    // Initialize the map for each day of the week
    for (var day in weekDays) {
      String dayName = DateFormat(
        'EEEE',
      ).format(day); // Get the full day name (e.g., Monday)
      weekData[dayName] = [];
    }

    // Group appointments by day
    for (var appointment in appointments) {
      String dayName = DateFormat(
        'EEEE',
      ).format(appointment.appointmentDate); // Get the day name
      weekData[dayName]?.add(appointment);
    }

    // Group tasks by day
    for (var task in tasks) {
      String dayName = DateFormat(
        'EEEE',
      ).format(task.taskDueDate); // Get the day name
      weekData[dayName]?.add(task);
    }

    return weekData;
  }

  void _onFilterChanged(CalendarFilter filter) async {
    setState(() {
      _isLoading = true; // Show loader
    });
    // Simulate a delay for data loading or complex UI updates
    await Future.delayed(
      const Duration(milliseconds: 2000),
    ); // Adjust as needed

    setState(() {
      selectedFilter = filter;
      // Reset view type if switching to month/year
      if (filter == CalendarFilter.month || filter == CalendarFilter.year) {
        currentView = ViewType.list; // Default to list for month/year view
      }
      _selectedCalendarDay =
          DateTime.now(); // Reset selected day to today when changing filter
      _isLoading = false; // Hide loader
    });

    // Navigate to the new screens based on filter
    if (filter == CalendarFilter.addTask) {
      Navigator.pushNamed(context, Routes.addNewTaskScreen);
    } else if (filter == CalendarFilter.addAppointment) {
      Navigator.pushNamed(context, Routes.addNewAppointmentScreen);
    }
  }

  // Task action methods
  void _markTaskCompleted(TaskModel task) {
    // In a real app, you would update the task status in your data source (e.g., provider, backend)
    setState(() {
      // For demonstration, we'll just print
      print('Task marked as completed: ${task.taskTitle}');
    });
  }

  void _onViewToggle(ViewType view) {
    setState(() {
      currentView = view;
    });
  }

  void _onTabChanged(String tab) async {
    // Make it async
    setState(() {
      _isLoading = true; // Show loader
    });

    // Simulate a delay
    await Future.delayed(const Duration(milliseconds: 2000));

    setState(() {
      selectedTab = tab;
      _isLoading = false; // Hide loader
    });
  }

  void _rescheduleTask(TaskModel task) {
    print('Reschedule task: ${task.taskTitle}');
    // Add logic for rescheduling task
  }

  void _cancelTask(TaskModel task) {
    print('Cancel task: ${task.taskTitle}');
    // Add logic for canceling task
  }

  // Appointment action methods
  void _showAppointmentDetails(AppointmentModel appointment) {
    print('View details for ${appointment.patientName}');
    // Add logic to navigate or show a detailed view
  }

  void _rescheduleAppointment(AppointmentModel appointment) {
    print('Reschedule appointment for ${appointment.patientName}');
    // Add logic for rescheduling appointment
  }

  void _cancelAppointment(AppointmentModel appointment) {
    print('Cancel appointment for ${appointment.patientName}');
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
    final weekData =
        getWeekAppointmentsAndTasks(); // Get grouped data for the week

    if (selectedFilter == CalendarFilter.day) {
      return _buildDayViewContent(weekData);
    }
    if (selectedFilter == CalendarFilter.month) {
      return _buildMonthView();
    } else if (selectedFilter == CalendarFilter.year) {
      return _buildYearView();
    }
    return const SizedBox.shrink();
  }

  Widget _buildDayViewContent(Map<String, List<dynamic>> weekData) {
    List<Widget> dayWidgets = [];

    // Sort days of the week to ensure consistent order
    List<String> sortedDayNames =
        getWeekDays().map((day) => DateFormat('EEEE').format(day)).toList();

    for (String dayName in sortedDayNames) {
      List<dynamic> eventsForDay = weekData[dayName] ?? [];

      List<AppointmentModel> appointmentsForDay = [];
      List<TaskModel> tasksForDay = [];

      for (var event in eventsForDay) {
        if (event is AppointmentModel) {
          appointmentsForDay.add(event);
        } else if (event is TaskModel) {
          tasksForDay.add(event);
        }
      }

      // Filter based on selected tab
      List<dynamic> displayList = [];
      if (selectedTab == 'Appointments') {
        displayList = appointmentsForDay;
      } else {
        displayList = tasksForDay;
      }

      if (displayList.isNotEmpty) {
        if (currentView == ViewType.list) {
          dayWidgets.add(
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.infoColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDayHeader(dayName),
                  ...displayList.map((data) {
                    if (data is AppointmentModel) {
                      return _buildAppointmentCard(data);
                    } else if (data is TaskModel) {
                      return _buildTaskCard(data);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          );
          dayWidgets.add(const SizedBox(height: _spacing));
        } else {
          // Grid view
          dayWidgets.add(_buildDayHeader(dayName));
          if (selectedTab == 'Appointments') {
            dayWidgets.add(_buildAppointmentTableHeader());
            dayWidgets.addAll(
              appointmentsForDay.map((data) => _buildAppointmentTableRow(data)),
            );
          } else {
            dayWidgets.add(_buildTaskTableHeader());
            dayWidgets.addAll(
              tasksForDay.map((data) => _buildTaskTableRow(data)),
            );
          }
          dayWidgets.add(const SizedBox(height: 24));
        }
      }
    }
    if (dayWidgets.isEmpty) {
      return Center(
        child: Text(
          'No ${selectedTab.toLowerCase()} for this week.',
          style: TextStyle(fontSize: 16, color: AppColors.secondaryTextColor),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dayWidgets,
    );
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
    // Use _selectedCalendarDay to determine which month to display
    DateTime displayMonth = _selectedCalendarDay ?? DateTime.now();
    String monthName = _getMonthName(displayMonth.month);
    String year = displayMonth.year.toString();

    final appointments =
        Provider.of<DoctorProvider>(
          context,
        ).getAppointmentsForMonth(); // These are month-filtered
    final tasks =
        Provider.of<DoctorProvider>(
          context,
        ).getTasksForMonth(); // These are month-filtered

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedTab == 'Appointments'
              ? '$monthName $year Appointments'
              : '$monthName $year Tasks',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        _buildCalendarGrid(displayMonth, appointments, tasks),
      ],
    );
  }

  // Year View Widget
  Widget _buildYearView() {
    DateTime displayYear = _selectedCalendarDay ?? DateTime.now();
    String currentYear = displayYear.year.toString();

    final appointments =
        Provider.of<DoctorProvider>(context).getAppointmentsForYear();
    final tasks = Provider.of<DoctorProvider>(context).getTasksForYear();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedTab == 'Appointments'
              ? '$currentYear Appointments'
              : '$currentYear Tasks',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        SingleChildScrollView(
          child: Column(
            children: List.generate(12, (index) {
              // index is 0-11, so month is index + 1
              DateTime monthDate = DateTime(displayYear.year, index + 1, 1);
              String monthName = _getMonthName(monthDate.month);

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: _spacing,
                ), // Add spacing between months
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      monthName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: _spacing / 2),
                    _buildCalendarGrid(
                      monthDate,
                      appointments,
                      tasks,
                    ), // Pass year-filtered appointments/tasks
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Calendar Grid Widget
  Widget _buildCalendarGrid(
    DateTime currentMonth,
    List<AppointmentModel> appointments,
    List<TaskModel> tasks,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildWeekDaysHeader(),
          _buildCalendarDays(
            currentMonth,
            appointments,
            tasks,
          ), // Pass appointments and tasks here
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
  Widget _buildCalendarDays(
    DateTime currentMonth,
    List<AppointmentModel> allAppointments,
    List<TaskModel> allTasks,
  ) {
    List<Widget> dayWidgets = [];
    // final doctorProvider = Provider.of<DoctorProvider>(context); // No longer needed directly here

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
          [], // Pass empty list for appointments
          [], // Pass empty list for tasks
        ),
      );
    }

    // Add days of current month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      List<AppointmentModel> dayAppointments =
          allAppointments // Use passed allAppointments
              .where((apt) => DateUtils.isSameDay(apt.appointmentDate, date))
              .toList();
      List<TaskModel> dayTasks =
          allTasks // Use passed allTasks
              .where((task) => DateUtils.isSameDay(task.taskDueDate, date))
              .toList();
      dayWidgets.add(_buildCalendarDay(date, true, dayAppointments, dayTasks));
    }

    // Add empty cells to complete the grid
    while (dayWidgets.length % 7 != 0) {
      // Get the last day added, which might be from the previous month's filler or current month
      DateTime lastDayInGrid =
          dayWidgets.isNotEmpty
              ? (dayWidgets.last is Expanded &&
                      (dayWidgets.last as Expanded).child is GestureDetector &&
                      ((dayWidgets.last as Expanded).child as GestureDetector)
                              .child
                          is Container &&
                      (((dayWidgets.last as Expanded).child as GestureDetector)
                                      .child
                                  as Container)
                              .child
                          is Column)
                  ? DateTime(
                    currentMonth.year,
                    currentMonth.month,
                    daysInMonth,
                  ) // Approximation if key is not easily accessible
                  : DateTime(
                    currentMonth.year,
                    currentMonth.month + 1,
                    0,
                  ) // Fallback for last day of current month
              : DateTime(
                currentMonth.year,
                currentMonth.month + 1,
                0,
              ); // Default if no days yet

      dayWidgets.add(
        _buildCalendarDay(
          lastDayInGrid.add(const Duration(days: 1)),
          false,
          [],
          [],
        ), // Pass empty lists for appointments and tasks
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
  Widget _buildCalendarDay(
    DateTime fullDate,
    bool isCurrentMonth,
    List<AppointmentModel> dayAppointments,
    List<TaskModel> dayTasks,
  ) {
    bool isToday = DateUtils.isSameDay(fullDate, DateTime.now());
    bool isSelected =
        _selectedCalendarDay != null &&
        DateUtils.isSameDay(fullDate, _selectedCalendarDay!);

    List<dynamic> dayEvents = [];

    if (isCurrentMonth) {
      // Only fetch events if it's a day of the current displayed month
      if (selectedTab == 'Appointments') {
        dayEvents = dayAppointments;
      } else {
        dayEvents = dayTasks;
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
                if (selectedTab == 'Appointments')
                  // Display a single indicator for total appointments
                  Container(
                    width: double.infinity,
                    height: 12,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColors
                              .primaryColor, // A general color for appointments
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        '${dayEvents.length} Appointments',
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else if (selectedTab == 'Tasks')
                  // Display up to 3 task titles
                  ...dayEvents.take(3).map((event) {
                    if (event is TaskModel) {
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
                            event.taskTitle,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                if (selectedTab == 'Tasks' &&
                    dayEvents.length > 3) // Add more indicator for tasks
                  Container(
                    width: double.infinity,
                    height: 12,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Center(
                      child: Text(
                        '...',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getEventColor(dynamic event) {
    if (selectedTab == 'Appointments' && event is AppointmentModel) {
      // Assuming AppointmentModel has a 'status' property, adjust if needed
      // For now, using a placeholder logic.
      String status =
          'confirmed'; // Replace with actual status from AppointmentModel
      return _getStatusColor(status);
    } else if (selectedTab == 'Tasks' && event is TaskModel) {
      // Assuming TaskModel has a 'status' property, adjust if needed
      // For now, using a placeholder logic.
      String status = 'pending'; // Replace with actual status from TaskModel
      return _getStatusColor(status);
    }
    return Colors.grey;
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
  Widget _buildAppointmentCard(AppointmentModel appointment) {
    // You'll need to define how you get imageUrl and status from AppointmentModel
    // For demonstration, using dummy values
    final String imageUrl =
        'https://via.placeholder.com/150'; // Replace with actual image URL
    final String status =
        'Confirmed'; // Replace with actual status from AppointmentModel

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
                      DateFormat('hh:mm a').format(
                        DateTime(
                          appointment.appointmentDate.year,
                          appointment.appointmentDate.month,
                          appointment.appointmentDate.day,
                          appointment.appointmentTime.hour,
                          appointment.appointmentTime.minute,
                        ),
                      ),
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
                  AppColors.buttonBgColor, // Centralized color
                  AppColors.textColor, // Centralized color
                  () => _showAppointmentDetails(appointment),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButtonCard(
                  'Reschedule',
                  status == 'Cancelled'
                      ? AppColors.disabledButtonColor
                      : AppColors.tertiaryButtonColor, // Centralized color
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
                      : AppColors.cancelButtonColor, // Centralized color
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
              border: Border.all(
                color: AppColors.borderColor,
              ), // Centralized color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              appointment.description, // Display description from model
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
  Widget _buildTaskCard(TaskModel task) {
    final String status =
        'Pending'; // Placeholder status for tasks, adjust as needed

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
                      task.taskTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a').format(
                        DateTime(
                          task.taskDueDate.year,
                          task.taskDueDate.month,
                          task.taskDueDate.day,
                          task.taskDueTime.hour,
                          task.taskDueTime.minute,
                        ),
                      ),
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
            ],
          ),
          const SizedBox(height: _spacing),
          Row(
            children: [
              Expanded(
                child: _buildActionButtonCard(
                  'Mark Completed',
                  status == 'Completed'
                      ? AppColors.disabledButtonColor
                      : AppColors.primaryColor,
                  Colors.white,
                  status == 'Completed' ? null : () => _markTaskCompleted(task),
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

  Widget _buildAppointmentTableRow(AppointmentModel appointment) {
    final String status =
        'Confirmed'; // Placeholder status for appointments, adjust as needed

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
              DateFormat('hh:mm a').format(
                DateTime(
                  appointment.appointmentDate.year,
                  appointment.appointmentDate.month,
                  appointment.appointmentDate.day,
                  appointment.appointmentTime.hour,
                  appointment.appointmentTime.minute,
                ),
              ),
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

  Widget _buildTaskTableRow(TaskModel task) {
    // Placeholder status for tasks, adjust as needed
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
              task.taskTitle,
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
              DateFormat('hh:mm a').format(
                DateTime(
                  task.taskDueDate.year,
                  task.taskDueDate.month,
                  task.taskDueDate.day,
                  task.taskDueTime.hour,
                  task.taskDueTime.minute,
                ),
              ),
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

  // Action menu for task
  void _showTaskActionMenu(TaskModel task) {
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
            Expanded(
              child:
                  _isLoading // Check the loading state
                      ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Show loader
                      : SingleChildScrollView(
                        child: _buildContentList(),
                      ), // Show content
            ),
            const SizedBox(height: 25), // Consider making this a constant
          ],
        ),
      ),
    );
  }
}
