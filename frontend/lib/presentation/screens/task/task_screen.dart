import 'dart:math';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/task_model.dart';
import 'package:doctor_app/presentation/screens/task/task_filter_popup.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _CalendarScreenState();
}

enum ViewType { grid, list }

enum CalendarFilter { day, week, month, year, addTask, addAppointment }

class _CalendarScreenState extends State<TaskScreen> {
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
      await _doctorProvider.loadTasks();
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
      if (filter == CalendarFilter.month || filter == CalendarFilter.year) {
        currentView = ViewType.grid;
      } else {
        currentView = ViewType.list;
      }
      _isLoading = false;
    });

    if (filter == CalendarFilter.addTask) {
      Navigator.pushNamed(context, Routes.addNewTaskScreen);
    } else if (filter == CalendarFilter.addAppointment) {
      Navigator.pushNamed(context, Routes.addNewAppointmentScreen);
    }
  }

  List<TaskModel> _getTasksForDay(DateTime day, List<TaskModel> tasks) {
    return tasks.where((task) {
      return DateUtils.isSameDay(task.taskDueDate, day);
    }).toList();
  }

  void _markTaskCompleted(TaskModel task) {
    setState(() {
      print('Task ${task.taskTitle} marked as Completed');
    });
  }

  void _onViewToggle(ViewType view) {
    setState(() {
      currentView = view;
    });
  }

  void _rescheduleTask(TaskModel task) {
    print('Reschedule Task: ${task.taskTitle}');
  }

  void _cancelTask(TaskModel task) {
    print('Cancel Task: ${task.taskTitle}');
  }

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
                builder: (context) => const TaskFilterPopup(),
              );
            },
          ),
        ),
      ],
    );
  }

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

  Widget _buildToggleButtons() {
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

  Widget _buildContentList(List<TaskModel> allTasks) {
    if (selectedFilter == CalendarFilter.day) {
      DateTime today = DateTime.now();
      List<TaskModel> todayTasks = _getTasksForDay(today, allTasks);
      if (todayTasks.isEmpty) {
        return _buildNoTasksMessage('No tasks for today.');
      }
      return _buildDayViewContent(
        tasks: todayTasks,
        dayHeader: _formatDayHeader(today),
        cardBuilder: _buildTaskCard,
      );
    } else if (selectedFilter == CalendarFilter.week) {
      return _buildWeekViewContent(allTasks);
    } else if (selectedFilter == CalendarFilter.month) {
      return _buildMonthView(allTasks);
    } else if (selectedFilter == CalendarFilter.year) {
      return _buildYearView(allTasks);
    }
    return const SizedBox.shrink();
  }

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

  Widget _buildDayViewContent({
    required List<TaskModel> tasks,
    required String dayHeader,
    required Widget Function(TaskModel) cardBuilder,
  }) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
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

  Widget _buildWeekViewContent(List<TaskModel> allTasks) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    List<Widget> weekDayWidgets = [];
    bool hasTasksInWeek = false;

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      List<TaskModel> dayTasks = _getTasksForDay(day, allTasks);

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
          weekDayWidgets.add(const SizedBox(height: _spacing));
        }
      }
    }

    if (!hasTasksInWeek) {
      return _buildNoTasksMessage('No tasks for this week.');
    }

    return Column(children: weekDayWidgets);
  }

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

  Widget _buildMonthView(List<TaskModel> allTasks) {
    DateTime now = DateTime.now();
    String monthName = _getMonthName(now.month);
    int currentYear = now.year;

    List<TaskModel> monthTasks =
        allTasks.where((task) {
          return task.taskDueDate.year == currentYear &&
              task.taskDueDate.month == now.month;
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$monthName $currentYear Tasks',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: _spacing),
        _buildCalendarGrid(now, monthTasks),
      ],
    );
  }

  Widget _buildYearView(List<TaskModel> allTasks) {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    List<Widget> yearMonthsWidgets = [];
    bool hasTasksInYear = false;

    for (int month = 1; month <= 12; month++) {
      DateTime monthDateTime = DateTime(currentYear, month, 1);
      List<TaskModel> monthTasks =
          allTasks.where((task) {
            return task.taskDueDate.year == currentYear &&
                task.taskDueDate.month == month;
          }).toList();

      if (monthTasks.isNotEmpty) {
        hasTasksInYear = true;
      }

      yearMonthsWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getMonthName(month)} $currentYear Tasks',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: _spacing),
            _buildCalendarGrid(monthDateTime, monthTasks),
            const SizedBox(height: _spacing * 2), // Spacing between months
          ],
        ),
      );
    }

    if (!hasTasksInYear) {
      return _buildNoTasksMessage('No tasks for this year.');
    }

    return Column(children: yearMonthsWidgets);
  }

  Widget _buildCalendarGrid(
    DateTime currentMonth,
    List<TaskModel> filteredTasks,
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
    List<TaskModel> filteredTasks,
  ) {
    List<Widget> dayWidgets = [];

    DateTime firstDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );
    int startingWeekday = (firstDayOfMonth.weekday - 1 + 7) % 7;

    int daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(
        _buildCalendarDay(
          firstDayOfMonth.subtract(Duration(days: startingWeekday - i)),
          false,
          filteredTasks,
        ),
      );
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      dayWidgets.add(_buildCalendarDay(date, true, filteredTasks));
    }

    while (dayWidgets.length % 7 != 0) {
      DateTime lastDayInGrid =
          dayWidgets.isNotEmpty && dayWidgets.last.key is ValueKey<DateTime>
              ? (dayWidgets.last.key as ValueKey<DateTime>).value
              : DateTime(currentMonth.year, currentMonth.month + 1, 0);

      dayWidgets.add(
        _buildCalendarDay(
          lastDayInGrid.add(const Duration(days: 1)),
          false,
          filteredTasks,
        ),
      );
    }

    List<Widget> weeks = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      weeks.add(Row(children: dayWidgets.sublist(i, i + 7)));
    }

    return Column(children: weeks);
  }

  Widget _buildCalendarDay(
    DateTime fullDate,
    bool isCurrentMonth,
    List<TaskModel> filteredTasks,
  ) {
    bool isToday = DateUtils.isSameDay(fullDate, DateTime.now());
    bool isSelected = DateUtils.isSameDay(fullDate, _selectedCalendarDay);

    List<TaskModel> dayEvents = [];

    if (isCurrentMonth) {
      dayEvents =
          filteredTasks.where((task) {
            return DateUtils.isSameDay(task.taskDueDate, fullDate);
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
                                _getTaskAbbreviation(event.taskTitle),
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

  Color _getEventColor(TaskModel task) {
    switch (task.taskPriority.toLowerCase()) {
      case 'completed':
        return AppColors.completedTaskColor;
      case 'high':
        return AppColors.pendingTaskColor;
      case 'medium':
        return AppColors.primaryColor;
      case 'low':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getTaskAbbreviation(String taskName) {
    List<String> words = taskName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].substring(0, min(2, words[0].length)).toUpperCase();
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

  Widget _buildTaskCard(TaskModel task) {
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
                      '${task.taskDueTime.hour.toString().padLeft(2, '0')}:${task.taskDueTime.minute.toString().padLeft(2, '0')}',
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
                  color: _getEventColor(task).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.taskPriority,
                  style: TextStyle(
                    color: _getEventColor(task),
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
                  task.taskPriority.toLowerCase() == 'completed'
                      ? AppColors.disabledButtonColor
                      : AppColors.primaryColor,
                  Colors.white,
                  task.taskPriority.toLowerCase() == 'completed'
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

  Widget _buildTaskTableRow(TaskModel task) {
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
              '${task.taskDueTime.hour.toString().padLeft(2, '0')}:${task.taskDueTime.minute.toString().padLeft(2, '0')}',
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
            _buildSearchBar(context),
            const SizedBox(height: _spacing),
            _buildFilterButtons(),
            const SizedBox(height: _spacing),
            Row(children: [_buildToggleButtons()]),
            const SizedBox(height: _spacing),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Consumer<DoctorProvider>(
                        builder: (context, doctorProvider, child) {
                          List<TaskModel> filteredTasks = [];
                          if (selectedFilter == CalendarFilter.day) {
                            filteredTasks =
                                doctorProvider.tasks.where((task) {
                                  return DateUtils.isSameDay(
                                    task.taskDueDate,
                                    _selectedCalendarDay ?? DateTime.now(),
                                  );
                                }).toList();
                          } else if (selectedFilter == CalendarFilter.week) {
                            filteredTasks = doctorProvider.getTasksForWeek();
                          } else if (selectedFilter == CalendarFilter.month) {
                            filteredTasks = doctorProvider.getTasksForMonth();
                          } else if (selectedFilter == CalendarFilter.year) {
                            filteredTasks = doctorProvider.getTasksForYear();
                          }

                          if (filteredTasks.isEmpty &&
                              selectedFilter != CalendarFilter.year) {
                            String message = '';
                            if (selectedFilter == CalendarFilter.day) {
                              message = 'No tasks for today.';
                            } else if (selectedFilter == CalendarFilter.week) {
                              message = 'No tasks for this week.';
                            } else if (selectedFilter == CalendarFilter.month) {
                              message = 'No tasks for this month.';
                            } else if (selectedFilter == CalendarFilter.year) {
                              // Message for year view is handled within _buildYearView
                              message = 'No tasks for this year.';
                            }
                            return _buildNoTasksMessage(message);
                          } else if (filteredTasks.isEmpty &&
                              selectedFilter == CalendarFilter.year) {
                            // For year view, we still want to show all 12 months even if no tasks
                            return SingleChildScrollView(
                              child: _buildYearView(filteredTasks),
                            );
                          }

                          return SingleChildScrollView(
                            child: _buildContentList(filteredTasks),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
