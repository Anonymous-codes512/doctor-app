import 'dart:math';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppointmentFilterPopup extends StatefulWidget {
  const AppointmentFilterPopup({Key? key}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<AppointmentFilterPopup> {
  // Controllers and state variables
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 1));
  TextEditingController patientNameController = TextEditingController();
  TextEditingController patientIDController = TextEditingController();
  String? selectedAppointmentStatus;
  String selectedDateFilter = 'Today';

  // Sample data for dropdowns
  final List<String> appointmentStatusOptions = [
    'Confirmed',
    'Pending',
    'Cancelled',
  ];

  // Define common spacing and padding constants for consistency
  static const double _spacing = 16.0;
  static const double _smallSpacing = 8.0;
  static const double _inputVerticalPadding = 14.0;
  static const double _inputHorizontalPadding = 12.0;
  static const double _borderRadius = 8.0;
  static const double _buttonHeight = 48.0;

  // --- Reset Methods ---
  void _resetDateRange() {
    setState(() {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(days: 1));
      selectedDateFilter = 'Today';
    });
  }

  void _resetPatientName() {
    setState(() {
      patientNameController.clear();
    });
  }

  void _resetPatientID() {
    setState(() {
      patientIDController.clear();
    });
  }

  void _resetPaymentStatus() {
    setState(() {
      selectedAppointmentStatus = null;
    });
  }

  void _resetAll() {
    _resetDateRange();
    _resetPatientName();
    _resetPatientID();
    _resetPaymentStatus();
  }

  // --- Apply Filters Method ---
  void _applyFilters() {
    // Handle filter application logic here
    Navigator.of(context).pop({
      'fromDate': fromDate,
      'toDate': toDate,
      'patientName': patientNameController.text,
      'patientID': patientIDController.text, // Added patientID to return
      'paymentStatus': selectedAppointmentStatus,
    });
  }

  // --- Date Range Selection Logic ---
  void _selectDateRange(String range) {
    setState(() {
      selectedDateFilter = range;
      DateTime now = DateTime.now();

      switch (range) {
        case 'Today':
          fromDate = DateTime(now.year, now.month, now.day);
          toDate = DateTime(
            now.year,
            now.month,
            now.day,
            23,
            59,
            59,
          ); // End of today
          break;
        case 'This Week':
          // Monday is weekday 1 in Dart's DateTime
          int weekday = now.weekday;
          fromDate = now.subtract(Duration(days: weekday - 1));
          toDate = now.add(Duration(days: 7 - weekday));
          toDate = DateTime(
            toDate.year,
            toDate.month,
            toDate.day,
            23,
            59,
            59,
          ); // End of Sunday
          break;
        case 'This Month':
          fromDate = DateTime(now.year, now.month, 1);
          toDate = DateTime(
            now.year,
            now.month + 1,
            0,
            23,
            59,
            59,
          ); // Last day of month, end of day
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(_spacing),
        height: min(
          MediaQuery.of(context).size.height * 0.9,
          700,
        ), // Max 80% screen height or 600px
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keep column compact vertically
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter by:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor, // Using AppColors
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.iconColor,
                  ), // Using AppColors
                ),
              ],
            ),
            const SizedBox(height: _spacing), // Add spacing after header
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Range Section
                    _buildSectionHeader('Date Range', _resetDateRange),
                    const SizedBox(height: _smallSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'From',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      AppColors
                                          .secondaryTextColor, // Using AppColors
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildDateInput(fromDate, (date) {
                                setState(() {
                                  fromDate = date;
                                });
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(width: _smallSpacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'To',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      AppColors
                                          .secondaryTextColor, // Using AppColors
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildDateInput(toDate, (date) {
                                setState(() {
                                  toDate = date;
                                });
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _spacing),

                    // Date filter buttons
                    Row(
                      children: [
                        Expanded(child: _buildDateFilterButton('Today')),
                        const SizedBox(width: _smallSpacing),
                        Expanded(child: _buildDateFilterButton('This Week')),
                        const SizedBox(width: _smallSpacing),
                        Expanded(child: _buildDateFilterButton('This Month')),
                      ],
                    ),

                    // Patient Name Section
                    _buildSectionHeader('Patient name', _resetPatientName),
                    _buildTextInput(
                      patientNameController,
                      'Enter patient name here',
                    ),
                    // Patient ID Section
                    _buildSectionHeader('Patient ID', _resetPatientID),
                    _buildTextInput(patientIDController, 'Enter ID here'),
                    // Appointment Status Section
                    _buildDropdownSection(
                      'Appointment Status',
                      selectedAppointmentStatus,
                      appointmentStatusOptions,
                      'Select Appointment status',
                      (value) =>
                          setState(() => selectedAppointmentStatus = value),
                      _resetPaymentStatus,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: _spacing), // Spacing before action buttons
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetAll,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.borderColor,
                      ), // Using AppColors
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_borderRadius),
                      ),
                      minimumSize: const Size(double.infinity, _buttonHeight),
                    ),
                    child: const Text(
                      'Reset All',
                      style: TextStyle(
                        color: AppColors.secondaryTextColor, // Using AppColors
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: _smallSpacing),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryColor, // Using AppColors
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_borderRadius),
                      ),
                      minimumSize: const Size(double.infinity, _buttonHeight),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  // Section Header with Reset Button
  Widget _buildSectionHeader(String title, VoidCallback onReset) {
    return Column(
      children: [
        const SizedBox(height: _spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor, // Using AppColors
              ),
            ),
            TextButton(
              onPressed: onReset,
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: AppColors.primaryColor, // Using AppColors
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Date Input Field
  Widget _buildDateInput(DateTime date, Function(DateTime) onChanged) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000), // Adjusted first date
          lastDate: DateTime(2050), // Adjusted last date
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColors.primaryColor, // DatePicker header color
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColor,
                ), // DatePicker selection color
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _inputHorizontalPadding,
          vertical: _inputVerticalPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor), // Using AppColors
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: Row(
          children: [
            Text(
              '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textColor,
              ), // Using AppColors
            ),
            const Spacer(),
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: AppColors.iconColor,
            ), // Using AppColors
          ],
        ),
      ),
    );
  }

  // Date Filter Button (Today, This Week, This Month)
  Widget _buildDateFilterButton(String text) {
    bool isSelected = selectedDateFilter == text;
    return GestureDetector(
      onTap: () => _selectDateRange(text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: _inputVerticalPadding),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryColor
                  : AppColors.buttonBgColor, // Using AppColors
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primaryColor
                    : AppColors.borderColor, // Using AppColors
          ),
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color:
                  isSelected
                      ? Colors.white
                      : AppColors.secondaryTextColor, // Using AppColors
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // Generic Text Input Field
  Widget _buildTextInput(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: AppColors.textColor,
      ), // Ensure text color is consistent
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.disabledTextColor,
        ), // Using AppColors
        contentPadding: const EdgeInsets.symmetric(
          horizontal: _inputHorizontalPadding,
          vertical: _inputVerticalPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(
            color: AppColors.borderColor,
          ), // Using AppColors
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(
            color: AppColors.borderColor,
          ), // Using AppColors
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ), // Highlight on focus
        ),
      ),
    );
  }

  // Generic Dropdown Section
  Widget _buildDropdownSection(
    String title,
    String? selectedValue,
    List<String> options,
    String hint,
    Function(String?) onChanged,
    VoidCallback onReset,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title, onReset), // Reusing section header
        const SizedBox(height: _smallSpacing),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.disabledTextColor),
          ), // Using AppColors
          items:
              options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: AppColors.textColor),
                  ), // Using AppColors
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: _inputHorizontalPadding,
              vertical: _inputVerticalPadding,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: const BorderSide(
                color: AppColors.borderColor,
              ), // Using AppColors
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: const BorderSide(
                color: AppColors.borderColor,
              ), // Using AppColors
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ), // Highlight on focus
            ),
          ),
        ),
      ],
    );
  }
}
