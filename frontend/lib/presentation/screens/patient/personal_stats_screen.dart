import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';

enum TimePeriod { daily, weekly, monthly }

class PersonalStatsScreen extends StatefulWidget {
  final Patient patientData;
  const PersonalStatsScreen({required this.patientData, super.key});

  @override
  State<PersonalStatsScreen> createState() => _PersonalStatsScreenState();
}

class _PersonalStatsScreenState extends State<PersonalStatsScreen> {
  late final TextEditingController heightController;
  late final TextEditingController weightController;
  late final TextEditingController bmiController;
  late final TextEditingController bpController;
  late final TextEditingController pulseController;
  late final TextEditingController ageController;

  // Calculated age value, used to set ageController text
  late num
  _patientAge; // Renamed 'age' to '_patientAge' for clarity and consistency

  num _calculateAge(dynamic dob) {
    if (dob is String) {
      final DateTime? parsedDob = DateTime.tryParse(dob);
      if (parsedDob == null) return 0; // Handle invalid date string
      dob = parsedDob;
    }
    if (dob is! DateTime) return 0; // Ensure dob is DateTime

    final today = DateTime.now();
    num age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  double _convertHeightToMeters(String heightStr) {
    // Convert from format like 5'4" to 5.4
    final regex = RegExp(r"(\d+)'(\d+)");
    final match = regex.firstMatch(heightStr);
    if (match != null) {
      final feet = int.parse(match.group(1)!);
      final inches = int.parse(match.group(2)!);
      final totalInches = (feet * 12) + inches;
      return totalInches * 0.0254;
    }

    // fallback to dot format like 5.4
    if (heightStr.contains('.')) {
      final parts = heightStr.split('.');
      final feet = int.tryParse(parts[0]) ?? 0;
      final inches = int.tryParse(parts[1]) ?? 0;
      final totalInches = (feet * 12) + inches;
      return totalInches * 0.0254;
    } else {
      final feet = int.tryParse(heightStr) ?? 0;
      return feet * 0.3048;
    }
  }

  @override
  void initState() {
    super.initState();
    _patientAge = _calculateAge(
      widget.patientData.dateOfBirth,
    ); // Use _patientAge here

    heightController = TextEditingController(
      text: widget.patientData.height ?? 'Not set yet',
    );
    weightController = TextEditingController(
      text: widget.patientData.weight ?? 'Not set yet',
    );
    ageController = TextEditingController(
      text:
          widget.patientData.dateOfBirth != null &&
                  widget.patientData.dateOfBirth!.isNotEmpty
              ? '$_patientAge Years'
              : 'Not set yet',
    );
    bmiController = TextEditingController(
      text:
          _calculateBMI(
            widget.patientData.weight,
            widget.patientData.height,
            _patientAge, // Pass the calculated age to BMI function
          ) ??
          'Not set yet',
    );
    bpController = TextEditingController(
      text: widget.patientData.bloodPressure ?? 'Not set yet',
    );
    pulseController = TextEditingController(
      text: widget.patientData.pulse ?? 'Not set yet',
    );
  }

  // Modified _calculateBMI to accept 'age' parameter
  String? _calculateBMI(String? weightStr, String? heightStr, num age) {
    if (weightStr == null ||
        heightStr == null ||
        weightStr.isEmpty ||
        heightStr.isEmpty) {
      return null;
    }

    try {
      double weightKg = double.parse(
        weightStr.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
      double heightMeters = _convertHeightToMeters(heightStr);

      if (heightMeters > 0) {
        double bmi = weightKg / (heightMeters * heightMeters);
        return bmi.toStringAsFixed(1);
      }
    } catch (e) {
      print(
        'Error calculating BMI for weight: $weightStr, height: $heightStr, age: $age. Error: $e',
      );
    }
    return null;
  }

  // View mode toggle
  bool isTableView = true;

  // Time period selection
  TimePeriod selectedTimePeriod = TimePeriod.daily;

  // Colors matching AnalysisScreen
  final Color green = const Color(0xff43ce2c);
  final Color purple = const Color(0xff9b59b6);
  final Color darkBlue = const Color(0xff273cdb);
  final Color lightPurple = const Color(0xffbfb6ff);
  final Color lightBlue = const Color(0xff92a5ff);

  // Sample data for daily view (7 days)
  final List<Map<String, dynamic>> dailyData = [
    {'period': 'Mon', 'weight': 70.0, 'bmi': 24.2, 'bp': '80/120', 'pulse': 75},
    {'period': 'Tue', 'weight': 69.8, 'bmi': 24.1, 'bp': '70/110', 'pulse': 74},
    {'period': 'Wed', 'weight': 69.5, 'bmi': 24.0, 'bp': '80/120', 'pulse': 73},
    {'period': 'Thu', 'weight': 69.3, 'bmi': 23.9, 'bp': '80/120', 'pulse': 75},
    {'period': 'Fri', 'weight': 69.0, 'bmi': 23.8, 'bp': '80/120', 'pulse': 74},
    {'period': 'Sat', 'weight': 68.7, 'bmi': 23.6, 'bp': '80/120', 'pulse': 75},
    {'period': 'Sun', 'weight': 68.5, 'bmi': 23.5, 'bp': '80/120', 'pulse': 74},
  ];

  // Sample data for weekly view (4 weeks)
  final List<Map<String, dynamic>> weeklyData = [
    {
      'period': 'Week 1',
      'weight': 70.0,
      'bmi': 24.2,
      'bp': '80/120',
      'pulse': 75,
    },
    {
      'period': 'Week 2',
      'weight': 69.8,
      'bmi': 24.1,
      'bp': '70/110',
      'pulse': 74,
    },
    {
      'period': 'Week 3',
      'weight': 69.5,
      'bmi': 24.0,
      'bp': '80/120',
      'pulse': 73,
    },
    {
      'period': 'Week 4',
      'weight': 69.3,
      'bmi': 23.9,
      'bp': '80/120',
      'pulse': 75,
    },
  ];

  // Sample data for monthly view (3 months)
  final List<Map<String, dynamic>> monthlyData = [
    {'period': 'Jan', 'weight': 71.0, 'bmi': 24.5, 'bp': '85/125', 'pulse': 78},
    {'period': 'Feb', 'weight': 70.5, 'bmi': 24.3, 'bp': '82/122', 'pulse': 76},
    {'period': 'Mar', 'weight': 70.0, 'bmi': 24.2, 'bp': '80/120', 'pulse': 75},
    {'period': 'Apr', 'weight': 69.5, 'bmi': 24.0, 'bp': '78/118', 'pulse': 74},
    {'period': 'May', 'weight': 69.0, 'bmi': 23.8, 'bp': '80/120', 'pulse': 73},
    {'period': 'Jun', 'weight': 68.5, 'bmi': 23.6, 'bp': '80/120', 'pulse': 72},
    {'period': 'Jul', 'weight': 68.0, 'bmi': 23.5, 'bp': '80/120', 'pulse': 71},
    {'period': 'Aug', 'weight': 67.5, 'bmi': 23.3, 'bp': '80/120', 'pulse': 70},
    {'period': 'Sep', 'weight': 67.0, 'bmi': 23.2, 'bp': '80/120', 'pulse': 69},
    {'period': 'Oct', 'weight': 66.5, 'bmi': 23.0, 'bp': '80/120', 'pulse': 68},
    {'period': 'Nov', 'weight': 66.0, 'bmi': 22.8, 'bp': '80/120', 'pulse': 67},
    {'period': 'Dec', 'weight': 65.5, 'bmi': 22.7, 'bp': '80/120', 'pulse': 66},
  ];

  // Getter for current active data set
  List<Map<String, dynamic>> get currentData {
    switch (selectedTimePeriod) {
      case TimePeriod.daily:
        return dailyData;
      case TimePeriod.weekly:
        return weeklyData;
      case TimePeriod.monthly:
        return monthlyData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        centerTitle: true,
        title: const Text(
          'Personal Stats',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Input Fields Section (Now including Age)
              LabeledTextField(
                label: 'Age',
                hintText: 'Age here...',
                controller: ageController,
                readOnly: true, // Age is typically read-only
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Height',
                hintText: 'Height here...',
                controller: heightController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Weight',
                hintText: 'Weight here...',
                controller: weightController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'BMI',
                hintText: 'BMI here...',
                controller: bmiController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'BP',
                hintText: 'BP here...',
                controller: bpController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Pulse',
                hintText: 'Pulse here...',
                controller: pulseController,
              ),

              const SizedBox(height: 32),

              // Categories and View Toggle Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: green),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'All Categories',
                          style: TextStyle(
                            color: green,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // View Toggle Icons
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isTableView = false;
                          });
                        },
                        icon: Icon(
                          Icons.bar_chart,
                          color:
                              !isTableView
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isTableView = true;
                          });
                        },
                        icon: Icon(
                          Icons.grid_view,
                          color:
                              isTableView
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Statistics Overview with updated colors and layout
              _buildStatsOverview(),

              const SizedBox(height: 24),

              // Updated Time Period Toggle (Daily/Weekly/Monthly)
              _buildTimePeriodToggle(),

              const SizedBox(height: 24),

              // Table or Chart View
              if (isTableView) _buildTableView() else _buildChartView(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        _buildStatItem('Weight', '37%', purple),
        _buildStatItem('BMI', '23%', darkBlue),
        _buildStatItem('BP', '29%', lightPurple),
        _buildStatItem('Pulse', '21%', lightBlue),
      ],
    );
  }

  Widget _buildStatItem(String label, String percentage, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        Text(
          '- $percentage',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildTimePeriodToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildPeriodButton('Daily'),
          _buildPeriodButton('Weekly'),
          _buildPeriodButton('Monthly'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    TimePeriod periodEnum;
    switch (period) {
      case 'Daily':
        periodEnum = TimePeriod.daily;
        break;
      case 'Weekly':
        periodEnum = TimePeriod.weekly;
        break;
      case 'Monthly':
        periodEnum = TimePeriod.monthly;
        break;
      default:
        periodEnum = TimePeriod.daily;
    }
    final bool isSelected = selectedTimePeriod == periodEnum;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTimePeriod = periodEnum;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableView() {
    final data = currentData;
    String firstColumnTitle;
    switch (selectedTimePeriod) {
      case TimePeriod.daily:
        firstColumnTitle = 'Days';
        break;
      case TimePeriod.weekly:
        firstColumnTitle = 'Weeks';
        break;
      case TimePeriod.monthly:
        firstColumnTitle = 'Months';
        break;
    }

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
              decoration: const BoxDecoration(
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
                  'Weight',
                  color: purple,
                  isHeader: true,
                  textColor: Colors.white,
                ),
                _tableCell(
                  'BMI',
                  color: darkBlue,
                  isHeader: true,
                  textColor: Colors.white,
                ),
                _tableCell(
                  'BP',
                  color: lightPurple,
                  isHeader: true,
                  textColor: Colors.black,
                ),
                _tableCell(
                  'Pulse',
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
                    item['period'],
                    color: green.withOpacity(0.3),
                    isHeader: false,
                  ),
                  _tableCell(item['weight'].toString(), isHeader: false),
                  _tableCell(item['bmi'].toString(), isHeader: false),
                  _tableCell(item['bp'], isHeader: false),
                  _tableCell(item['pulse'].toString(), isHeader: false),
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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

  Widget _buildChartView() {
    final data = currentData;
    final double chartHeight = 280;
    final double maxBarHeight = 200; // Adjusted for padding and labels

    // Determine max values for normalization to make the chart dynamic
    double maxWeight = dailyData
        .map((e) => e['weight'] as double)
        .reduce((a, b) => a > b ? a : b);
    double maxBmi = dailyData
        .map((e) => e['bmi'] as double)
        .reduce((a, b) => a > b ? a : b);
    // For BP and Pulse, let's assume a reasonable max if not explicitly in data
    double maxBpSystolic = 140; // Example max systolic BP
    double maxPulse = 100; // Example max pulse

    if (weeklyData.isNotEmpty) {
      maxWeight = weeklyData
          .map((e) => e['weight'] as double)
          .fold(maxWeight, (prev, e) => e > prev ? e : prev);
      maxBmi = weeklyData
          .map((e) => e['bmi'] as double)
          .fold(maxBmi, (prev, e) => e > prev ? e : prev);
    }
    if (monthlyData.isNotEmpty) {
      maxWeight = monthlyData
          .map((e) => e['weight'] as double)
          .fold(maxWeight, (prev, e) => e > prev ? e : prev);
      maxBmi = monthlyData
          .map((e) => e['bmi'] as double)
          .fold(maxBmi, (prev, e) => e > prev ? e : prev);
    }

    // Normalize data for chart visualization
    List<double> weightVals =
        data.map((e) => (e['weight'] as double) / maxWeight).toList();
    List<double> bmiVals =
        data.map((e) => (e['bmi'] as double) / maxBmi).toList();
    List<double> bpVals =
        data.map((e) {
          // Assuming BP is in "systolic/diastolic" format, use systolic for chart
          final bpParts = (e['bp'] as String).split('/');
          return (double.tryParse(bpParts[0]) ?? 0.0) / maxBpSystolic;
        }).toList();
    List<double> pulseVals =
        data.map((e) => (e['pulse'] as int) / maxPulse).toList();

    // Adjusted Y-axis labels for 0-100% or based on max values
    final List<int> yLabels = [
      0,
      20,
      40,
      60,
      80,
      100,
    ]; // Representing percentage of max

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Chart Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Weight', purple),
              const SizedBox(width: 20),
              _buildLegendItem('BMI', darkBlue),
              const SizedBox(width: 20),
              _buildLegendItem('BP', lightPurple),
              const SizedBox(width: 20),
              _buildLegendItem('Pulse', lightBlue),
            ],
          ),
          const SizedBox(height: 16),

          // Bar Chart
          SizedBox(
            height: chartHeight, // Use the full chartHeight
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y Axis
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      yLabels.map((val) {
                        return Expanded(
                          // Use Expanded to distribute vertical space
                          child: Align(
                            alignment:
                                Alignment
                                    .centerRight, // Align text to the right
                            child: Text(
                              '$val%', // Display as percentage for generic representation
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(width: 8),

                // Bars
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(data.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBar(
                                    weightVals[index] * maxBarHeight,
                                    purple,
                                  ),
                                  const SizedBox(width: 2),
                                  _buildBar(
                                    bmiVals[index] * maxBarHeight,
                                    darkBlue,
                                  ),
                                  const SizedBox(width: 2),
                                  _buildBar(
                                    bpVals[index] * maxBarHeight,
                                    lightPurple,
                                  ),
                                  const SizedBox(width: 2),
                                  _buildBar(
                                    pulseVals[index] * maxBarHeight,
                                    lightBlue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data[index]['period'],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 12,
      height: height.clamp(
        0,
        200,
      ), // Clamp height to prevent negative values or excessive height
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    bmiController.dispose();
    bpController.dispose();
    pulseController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
