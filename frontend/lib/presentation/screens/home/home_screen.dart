import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:doctor_app/data/models/task_model.dart';
import 'package:doctor_app/presentation/widgets/app_drawer.dart';
import 'package:doctor_app/presentation/widgets/calendar_task_card.dart';
import 'package:doctor_app/presentation/widgets/icon_item.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum ViewType { grid, list }

class _HomeScreenState extends State<HomeScreen> {
  ViewType calendarView = ViewType.list;
  ViewType taskBarView = ViewType.list;

  late DoctorProvider doctorProvider;

  @override
  void initState() {
    super.initState();

    // Defer the async work
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final doctorProvider = Provider.of<DoctorProvider>(
        context,
        listen: false,
      );
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );

      await doctorProvider.getHomeData();
      await patientProvider.fetchPatients();
    });
  }

  Widget buildToggleButtons(
    ViewType currentView,
    void Function(ViewType) onToggle,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.grid_view),
          color:
              currentView == ViewType.grid
                  ? AppColors.primaryColor
                  : Colors.grey,
          onPressed: () => onToggle(ViewType.grid),
        ),
        IconButton(
          icon: Icon(Icons.list),
          color:
              currentView == ViewType.list
                  ? AppColors.primaryColor
                  : Colors.grey,
          onPressed: () => onToggle(ViewType.list),
        ),
      ],
    );
  }

  Widget buildCalendarSection(List appointments) {
    final today = DateTime.now();
    final todayAppointments =
        appointments.where((appt) {
          return appt.appointmentDate.year == today.year &&
              appt.appointmentDate.month == today.month &&
              appt.appointmentDate.day == today.day;
        }).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  "Today's Calendar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                buildToggleButtons(calendarView, (val) {
                  setState(() {
                    calendarView = val;
                  });
                }),
              ],
            ),
          ),
          SizedBox(height: 8),
          todayAppointments.isEmpty
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No appointments for today'),
              )
              : calendarView == ViewType.list
              ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: todayAppointments.length,
                itemBuilder: (context, index) {
                  final appt = todayAppointments[index];
                  return CalendarTaskCard(
                    name: appt.patientName,
                    phone: '',
                    date: DateFormat(
                      'dd MMM yyyy',
                    ).format(appt.appointmentDate),
                    time:
                        '${appt.appointmentTime.hour.toString().padLeft(2, '0')}:${appt.appointmentTime.minute.toString().padLeft(2, '0')}',
                    imageUrl: 'https://i.pravatar.cc/150?img=${index + 5}',
                    isGrid: false,
                  );
                },
              )
              : SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: todayAppointments.length,
                  itemBuilder: (context, index) {
                    final appt = todayAppointments[index];
                    return CalendarTaskCard(
                      name: appt.patientName,
                      phone: '',
                      date: DateFormat(
                        'dd MMM yyyy',
                      ).format(appt.appointmentDate),
                      time:
                          '${appt.appointmentTime.hour.toString().padLeft(2, '0')}:${appt.appointmentTime.minute.toString().padLeft(2, '0')}',
                      imageUrl: 'https://i.pravatar.cc/150?img=${index + 5}',
                      isGrid: true,
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }

  Widget buildTaskBarSection(List<TaskModel> tasks) {
    final today = DateTime.now();
    final todayTasks =
        tasks.where((task) {
          final dueDate = task.taskDueDate;
          if (dueDate == null) return false;
          return dueDate.year == today.year &&
              dueDate.month == today.month &&
              dueDate.day == today.day;
        }).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  "Today's Tasks",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                buildToggleButtons(taskBarView, (val) {
                  setState(() {
                    taskBarView = val;
                  });
                }),
              ],
            ),
          ),
          SizedBox(height: 8),
          todayTasks.isEmpty
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No tasks for today'),
              )
              : taskBarView == ViewType.list
              ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: todayTasks.length,
                itemBuilder: (context, index) {
                  final task = todayTasks[index];
                  return CalendarTaskCard(
                    name: task.taskTitle,
                    phone: '',
                    date: DateFormat('dd MMM yyyy').format(task.taskDueDate),
                    time:
                        task.taskDueTime != null
                            ? '${task.taskDueTime.hour.toString().padLeft(2, '0')}:${task.taskDueTime.minute.toString().padLeft(2, '0')}'
                            : '',
                    imageUrl: 'https://i.pravatar.cc/150?img=${index + 10}',
                    isGrid: false,
                  );
                },
              )
              : SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: todayTasks.length,
                  itemBuilder: (context, index) {
                    final task = todayTasks[index];
                    return CalendarTaskCard(
                      name: task.taskTitle,
                      phone: '',
                      date: DateFormat('dd MMM yyyy').format(task.taskDueDate),
                      time:
                          task.taskDueTime != null
                              ? '${task.taskDueTime.hour.toString().padLeft(2, '0')}:${task.taskDueTime.minute.toString().padLeft(2, '0')}'
                              : '',
                      imageUrl: 'https://i.pravatar.cc/150?img=${index + 10}',
                      isGrid: true,
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }

  Widget buildBottomIconsGrid() {
    final items = [
      {
        'icon': Icons.person_add,
        'label': 'My Patient',
        'route': '/my_patients_screen',
      },
      {
        'icon': Icons.calendar_today,
        'label': 'Calendar',
        'route': '/calendar_screen',
      },
      {'icon': Icons.task, 'label': 'Tasks', 'route': '/my_task_screen'},
      {
        'icon': Icons.receipt_long,
        'label': 'Invoices',
        'route': '/my_invoices_screen',
      },
      {
        'icon': Icons.medical_services_outlined,
        'label': 'Appointments',
        'route': '/my_appointment_screen',
      },
      {
        'icon': Icons.assignment,
        'label': 'Reports',
        'route': '/all_patients_reports_screen',
      },
      {
        'icon': Icons.mail_outline,
        'label': 'Messages',
        'route': '/all_message_screen',
      },
      {
        'icon': Icons.phone_in_talk,
        'label': 'Voice Call Consultation',
        'route': '/all_voice_screen',
      },
      {
        'icon': Icons.video_call,
        'label': 'Video Call Consultation',
        'route': '/all_video_screen',
      },
      {'icon': Icons.payment, 'label': 'Payments', 'route': '/payments_screen'},
      {
        'icon': Icons.health_and_safety,
        'label': 'Health Tracker',
        'route': '/health_tracker_start_screen',
      },
      {'icon': Icons.add, 'label': 'Add New', 'route': '/add_patient_screen'},
    ];

    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return IconItems(
            onTap: () {
              final route = item['route'] as String?;
              if (route != null) {
                Navigator.pushNamed(context, route);
              }
            },
            icon: item['icon'] as IconData,
            label: item['label'] as String,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage(ImagePath.profileAvatar),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<DoctorProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.greeting,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          provider.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 16),
            Consumer<DoctorProvider>(
              builder: (context, provider, _) {
                return buildCalendarSection(provider.appointments);
              },
            ),
            Consumer<DoctorProvider>(
              builder: (context, provider, _) {
                return buildTaskBarSection(provider.tasks);
              },
            ),
            SizedBox(height: 8),
            buildBottomIconsGrid(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
