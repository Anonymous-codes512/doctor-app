import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/widgets/custom_step_popup.dart';
import 'package:flutter/material.dart';

class StepsCaloriesCounterScreen extends StatefulWidget {
  const StepsCaloriesCounterScreen({super.key});

  @override
  State<StepsCaloriesCounterScreen> createState() =>
      _StepsCaloriesCounterScreenState();
}

class _StepsCaloriesCounterScreenState
    extends State<StepsCaloriesCounterScreen> {
  double stepsProgress = 0.21; // Initial progress value for steps
  double caloriesProgress = 0.29; // Initial progress value for calories
  bool isWeekly = false;
  bool isTableView = false;
  bool isPaused = false; // Track if the progress is paused
  final _stepController = TextEditingController();

  // Key to track position of menu button
  final GlobalKey _menuButtonKey = GlobalKey();

  // Function to pause
  void _pause() {
    setState(() {
      isPaused = true;
    });
  }

  // Function to resume
  void _resume() {
    setState(() {
      isPaused = false;
    });
  }

  // Dummy daily data (7 days)
  final List<Map<String, dynamic>> dailyData = [
    {
      'day': 'Mon',
      'Steps': 2000,
      'Calories': 24.2,
      'Distance': 2.5,
      'Duration': 15,
    },
    {
      'day': 'Tue',
      'Steps': 1000,
      'Calories': 16.1,
      'Distance': 1,
      'Duration': 7.5,
    },
    {
      'day': 'Wed',
      'Steps': 1500,
      'Calories': 20.0,
      'Distance': 1.5,
      'Duration': 10,
    },
    {
      'day': 'Thu',
      'Steps': 2500,
      'Calories': 30.9,
      'Distance': 3,
      'Duration': 20.8,
    },
    {
      'day': 'Fri',
      'Steps': 2000,
      'Calories': 24.2,
      'Distance': 2.5,
      'Duration': 15,
    },
    {
      'day': 'Sat',
      'Steps': 3000,
      'Calories': 35.6,
      'Distance': 3.5,
      'Duration': 30,
    },
    {
      'day': 'Sun',
      'Steps': 1400,
      'Calories': 18.5,
      'Distance': 1.35,
      'Duration': 9.4,
    },
  ];

  // Dummy weekly data (4 weeks)
  final List<Map<String, dynamic>> weeklyData = [
    {
      'week': 'week 1',
      'Steps': 12000,
      'Calories': 24.2,
      'Distance': 120,
      'Duration': 75,
    },
    {
      'week': 'week 2',
      'Steps': 15000,
      'Calories': 24.1,
      'Distance': 110,
      'Duration': 74,
    },
    {
      'week': 'week 3',
      'Steps': 17000,
      'Calories': 24.0,
      'Distance': 120,
      'Duration': 73,
    },
    {
      'week': 'week 4',
      'Steps': 23000,
      'Calories': 1500,
      'Distance': 120,
      'Duration': 75,
    },
  ];

  final List<Map<String, dynamic>> stepsData = [
    {'date': '26/01/25', 'target': '250 steps', 'status': 'Accomplished'},
    {'date': '20/01/25', 'target': '300 steps', 'status': 'Unfinished'},
    {'date': '10/01/25', 'target': '300 steps', 'status': 'Exceeded'},
  ];
  // Colors used in legend and bars, matched as per images
  final Color green = const Color(0xff43ce2c);
  final Color purple = const Color(0xff9b59b6);
  final Color darkBlue = const Color(0xff273cdb);
  final Color lightPurple = const Color(0xffbfb6ff);
  final Color lightBlue = const Color(0xff92a5ff);

  // Getter for current active data set
  List<Map<String, dynamic>> get currentData =>
      isWeekly ? weeklyData : dailyData;

  // Function to reset steps
  void _resetSteps() {
    setState(() {
      stepsProgress = 0.0; // Reset progress to 0
    });
  }

  // Function to show menu
  void _showMenu(BuildContext context) {
    final RenderBox? renderBox =
        _menuButtonKey.currentContext!.findRenderObject() as RenderBox?;

    // Make sure renderBox is not null
    if (renderBox == null) {
      print("RenderBox not found for menu button.");
      return;
    }

    final position = renderBox.localToGlobal(Offset.zero); // Get position

    showMenu(
      context: context,
      color: AppColors.backgroundColor,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + renderBox.size.height, // Below the button
        position.dx + renderBox.size.width,
        0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            title: const Text('Reset steps'),
            onTap: () {
              Navigator.pop(context); // Close the menu
              _resetSteps(); // Reset the steps
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Edit steps'),
            onTap: () {
              Navigator.pop(context); // Close the menu
              print("Opening Edit Steps dialog"); // Debug line
              showDialog(
                context: context,
                builder:
                    (context) => CustomStepPopup(
                      controller: _stepController,
                      onSave: () {
                        setState(() {}); // Optionally, update state
                        Navigator.of(context).pop();
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    ),
              );
            },
          ),
        ),
        PopupMenuItem(
          child: const ListTile(title: Text('Set steps target')),
          onTap: () {
            Navigator.pop(context); // Close the menu
            showDialog(
              context: context,
              builder:
                  (context) => CustomStepPopup(
                    controller: _stepController,
                    isSteptarget: true,
                    onSave: () {
                      setState(() {}); // Optionally, update state
                      Navigator.of(context).pop();
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                  ),
            );
          },
        ),
        PopupMenuItem(
          child: ListTile(title: Text('View steps target')),
          onTap: () {
            Navigator.pop(context); // Close the menu
            showDialog(
              context: context,
              builder:
                  (context) => ViewTargetStepsDialog(
                    stepsData: stepsData,
                    onDelete: () {
                      Navigator.of(context).pop();
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                  ),
            );
          },
        ),
        const PopupMenuItem(child: ListTile(title: Text('Turn off'))),
      ],
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Steps & Calories Counter',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step count and controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '0',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Text(
                        'Steps',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Pause/Resume button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            isPaused ? Icons.play_arrow : Icons.pause,
                            color: Colors.black54,
                            size: 24,
                          ),
                          onPressed: () => isPaused ? _resume() : _pause(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // More options menu button
                      Container(
                        key: _menuButtonKey, // Attach the key here
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          onPressed: () => _showMenu(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                'Steps Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Slider(
                value: stepsProgress,
                min: 0,
                max: 1,
                onChanged: (newValue) {
                  setState(() {
                    stepsProgress = newValue;
                  });
                },
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.grey,
              ),

              const SizedBox(height: 20),

              // Circular progress chart
              Center(
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle (Steps)
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: stepsProgress,
                          strokeWidth: 20,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      ),
                      // Inner circle (Calories)
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: caloriesProgress,
                          strokeWidth: 15,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                        ),
                      ),
                      // Center time display
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '12:24 pm',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Stats row with Vertical Divider
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Steps Count', '430', 'kcal'),
                    const VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                      width: 20,
                    ),
                    _buildStatItem('Calories Burn', '3000', 'steps'),
                    const VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                      width: 20,
                    ),
                    _buildStatItem('Distance', '4.70', 'km'),
                    const VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                      width: 20,
                    ),
                    _buildStatItem('Duration', '1.50', 'hr'),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Reports section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reports',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isWeekly = false;
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isWeekly ? Colors.transparent : darkBlue,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: darkBlue),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Daily',
                            style: TextStyle(
                              color: isWeekly ? darkBlue : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isWeekly = true;
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isWeekly ? darkBlue : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: darkBlue),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Weekly',
                            style: TextStyle(
                              color: isWeekly ? Colors.white : darkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Add a SizedBox with a fixed height to avoid unbounded height issue
              const SizedBox(height: 20),

              // Remove Expanded and directly add the table without taking flexible space
              _buildTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, String unit) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(unit, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildTable() {
    final data = currentData;
    final firstColumnTitle = isWeekly ? 'Weeks' : 'Days';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey.shade400),
            outside: BorderSide(color: Colors.grey.shade400),
          ),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FixedColumnWidth(80),
            1: FixedColumnWidth(70),
            2: FixedColumnWidth(70),
            3: FixedColumnWidth(90),
            4: FixedColumnWidth(70),
          },
          children: [
            // Header Row
            TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              children: [
                _tableCell(
                  firstColumnTitle,
                  color: green,
                  isHeader: true,
                  textColor: Colors.black,
                ),
                _tableCell(
                  'Steps',
                  color: purple,
                  isHeader: true,
                  textColor: Colors.white,
                ),
                _tableCell(
                  'Calories',
                  color: darkBlue,
                  isHeader: true,
                  textColor: Colors.white,
                ),
                _tableCell(
                  'Distance',
                  color: lightPurple,
                  isHeader: true,
                  textColor: Colors.black,
                ),
                _tableCell(
                  'Duration',
                  color: lightBlue,
                  isHeader: true,
                  textColor: Colors.black,
                ),
              ],
            ),
            // Data Rows
            for (var item in data)
              TableRow(
                children: [
                  _tableCell(
                    isWeekly ? item['week'] : item['day'],
                    color: green.withOpacity(0.3),
                    isHeader: false,
                  ),
                  _tableCell(item['Steps'].toString(), isHeader: false),
                  _tableCell(item['Calories'].toString(), isHeader: false),
                  _tableCell(item['Distance'].toString(), isHeader: false),
                  _tableCell(item['Duration'].toString(), isHeader: false),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each table cell with colors, text, padding
  Widget _tableCell(
    String text, {
    Color? color,
    bool isHeader = false,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      color: color ?? Colors.transparent,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: textColor ?? (isHeader ? Colors.black : Colors.black87),
        ),
      ),
    );
  }
}
