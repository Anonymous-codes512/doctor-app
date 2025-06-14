import 'package:doctor_app/core/assets/images/images_paths.dart';
import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool isWeekly = false;
  bool isTableView = false;

  // Dummy daily data (7 days)
  final List<Map<String, dynamic>> dailyData = [
    {'day': 'Mon', 'Weight': 70.0, 'BMI': 24.2, 'BP': '80/120', 'Pulse': 75},
    {'day': 'Tue', 'Weight': 69.8, 'BMI': 24.1, 'BP': '70/110', 'Pulse': 74},
    {'day': 'Wed', 'Weight': 69.5, 'BMI': 24.0, 'BP': '80/120', 'Pulse': 73},
    {'day': 'Thu', 'Weight': 69.3, 'BMI': 23.9, 'BP': '80/120', 'Pulse': 75},
    {'day': 'Fri', 'Weight': 69.0, 'BMI': 23.8, 'BP': '80/120', 'Pulse': 74},
    {'day': 'Sat', 'Weight': 68.7, 'BMI': 23.6, 'BP': '80/120', 'Pulse': 75},
    {'day': 'Sun', 'Weight': 68.5, 'BMI': 23.5, 'BP': '80/120', 'Pulse': 74},
  ];

  // Dummy weekly data (4 weeks)
  final List<Map<String, dynamic>> weeklyData = [
    {
      'week': 'week 1',
      'Weight': 70.0,
      'BMI': 24.2,
      'BP': '80/120',
      'Pulse': 75,
    },
    {
      'week': 'week 2',
      'Weight': 69.8,
      'BMI': 24.1,
      'BP': '70/110',
      'Pulse': 74,
    },
    {
      'week': 'week 3',
      'Weight': 69.5,
      'BMI': 24.0,
      'BP': '80/120',
      'Pulse': 73,
    },
    {
      'week': 'week 4',
      'Weight': 69.3,
      'BMI': 23.9,
      'BP': '80/120',
      'Pulse': 75,
    },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analysis',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {},
        ),
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () {})],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Analytics Icon Circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Image.asset(ImagePath.comboChart),
              ),

              const SizedBox(height: 16),

              // Legend & toggle icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Legend with "All Categories"
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(140, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    label: const Text(
                      'All Categories',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),

                  // Icons for chart & table toggle
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.bar_chart,
                          color: isTableView ? Colors.grey : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            isTableView = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.grid_view,
                          color: isTableView ? Colors.black : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isTableView = true;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Legend for categories with colored dots and percentages
              Wrap(
                spacing: 20,
                runSpacing: 6,
                children: [
                  _legendItem(purple, 'Weight', '37%'),
                  _legendItem(darkBlue, 'BMI', '23%'),
                  _legendItem(lightPurple, 'BP', '29%'),
                  _legendItem(lightBlue, 'Pulse', '21%'),
                ],
              ),

              const SizedBox(height: 20),

              // Daily / Weekly toggle buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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

              const SizedBox(height: 20),

              // Chart or Table or No Data view
              Expanded(
                child:
                    currentData.isEmpty
                        ? _buildNoDataView()
                        : (isTableView ? _buildTable() : _buildBarChart()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Legend item widget with colored dot, label, and percentage
  Widget _legendItem(Color color, String label, String percentage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 6),
        Text('- $percentage', style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  // No data view widget
  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Image.asset(ImagePath.comboChart, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Analytics Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Build bar chart using basic Flutter widgets (approximate style)
  Widget _buildBarChart() {
    final data = currentData;

    final labels =
        isWeekly
            ? data.map((e) => e['week'] as String).toList()
            : data.map((e) => e['day'] as String).toList();

    final double chartHeight = 280; // same as table height approx
    final maxBarHeight =
        chartHeight - 60; // padding for labels and y axis spacing

    List<double> weightVals =
        data.map((e) => (e['Weight'] as double) / 70).toList();
    List<double> bmiVals = data.map((e) => (e['BMI'] as double) / 25).toList();
    List<double> bpVals = List.generate(data.length, (i) => 0.9);
    List<double> pulseVals = data.map((e) => (e['Pulse'] as int) / 80).toList();

    final yLabels = [0, 20, 40, 60, 80, 100, 120].reversed.toList();

    return SizedBox(
      height: chartHeight - 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Y Axis
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                yLabels.map((val) {
                  return SizedBox(
                    height: maxBarHeight / (yLabels.length - 1),
                    child: Text(
                      val.toString(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(width: 8),

          // Bars + labels scrollable
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
                            _bar(weightVals[index] * maxBarHeight, purple),
                            const SizedBox(width: 4),
                            _bar(bmiVals[index] * maxBarHeight, darkBlue),
                            const SizedBox(width: 4),
                            _bar(bpVals[index] * maxBarHeight, lightPurple),
                            const SizedBox(width: 4),
                            _bar(pulseVals[index] * maxBarHeight, lightBlue),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _bar(double height, Color color) {
    return Container(
      width: 14,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
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
                    isWeekly ? item['week'] : item['day'],
                    color: green.withOpacity(0.3),
                    isHeader: false,
                  ),
                  _tableCell(item['Weight'].toString(), isHeader: false),
                  _tableCell(item['BMI'].toString(), isHeader: false),
                  _tableCell(item['BP'], isHeader: false),
                  _tableCell(item['Pulse'].toString(), isHeader: false),
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
}
