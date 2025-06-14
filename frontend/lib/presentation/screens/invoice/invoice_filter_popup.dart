import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class InvoiceFilterPopup extends StatefulWidget {
  const InvoiceFilterPopup({Key? key}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<InvoiceFilterPopup> {
  // Controllers and state variables
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(Duration(days: 1));

  TextEditingController patientNameController = TextEditingController();
  String selectedDateFilter = 'Today';

  String? selectedPaymentStatus;
  final List<String> paymentStatusOptions = ['Paid', 'Unpaid', 'Pending'];

  String? selectedAmountRange;
  final List<String> amountRangeOptions = [
    '0 - 100',
    '100 - 500',
    '500 - 1000',
    '1000+',
  ];

  String? selectedInvoiceType;
  final List<String> invoiceTypeOptions = [
    'Consultation',
    'Follow up',
    'Reports',
  ];

  void _resetDateRange() {
    setState(() {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(days: 1));
      selectedDateFilter = 'Today';
    });
  }

  void _resetPatientName() {
    setState(() {
      patientNameController.clear();
    });
  }

  void _resetPaymentStatus() {
    setState(() {
      selectedPaymentStatus = null;
    });
  }

  void _resetAmountRange() {
    setState(() {
      selectedAmountRange = null;
    });
  }

  void _resetInvoiceType() {
    setState(() {
      selectedInvoiceType = null;
    });
  }

  void _resetAll() {
    _resetDateRange();
    _resetPatientName();
    _resetPaymentStatus();
    _resetAmountRange();
    _resetInvoiceType();
  }

  void _applyFilters() {
    // Handle filter application logic here
    Navigator.of(context).pop({
      'fromDate': fromDate,
      'toDate': toDate,
      'patientName': patientNameController.text,
      'paymentStatus': selectedPaymentStatus,
      'amountRange': selectedAmountRange,
      'invoiceType': selectedInvoiceType,
    });
  }

  void _selectDateRange(String range) {
    setState(() {
      selectedDateFilter = range;
      DateTime now = DateTime.now();

      switch (range) {
        case 'Today':
          fromDate = DateTime(now.year, now.month, now.day);
          toDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case 'This Week':
          int weekday = now.weekday;
          fromDate = now.subtract(Duration(days: weekday - 1));
          toDate = now.add(Duration(days: 7 - weekday));
          break;
        case 'This Month':
          fromDate = DateTime(now.year, now.month, 1);
          toDate = DateTime(now.year, now.month + 1, 0);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Range Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date Range',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: _resetDateRange,
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Date inputs
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
                                  color: Colors.grey,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'To',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
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
                    const SizedBox(height: 16),

                    // Date filter buttons
                    Row(
                      children: [
                        Expanded(child: _buildDateFilterButton('Today')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildDateFilterButton('This Week')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildDateFilterButton('This Month')),
                      ],
                    ),

                    // Patient Name Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Patient name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: _resetPatientName,
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildTextInput(patientNameController, 'enter here'),

                    // Payment Status Section
                    _buildDropdownSection(
                      'Payment Status',
                      selectedPaymentStatus,
                      paymentStatusOptions,
                      'Select payment status',
                      (value) => setState(() => selectedPaymentStatus = value),
                      _resetPaymentStatus,
                    ),

                    // Amount Range Section
                    _buildDropdownSection(
                      'Amount range',
                      selectedAmountRange,
                      amountRangeOptions,
                      'Select amount range',
                      (value) => setState(() => selectedAmountRange = value),
                      _resetAmountRange,
                    ),
                    // Invoice Type Section
                    _buildDropdownSection(
                      'Invoice type',
                      selectedInvoiceType,
                      invoiceTypeOptions,
                      'Select invoice type',
                      (value) => setState(() => selectedInvoiceType = value),
                      _resetInvoiceType,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetAll,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Reset All',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Apply Filters(3)',
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

  Widget _buildDateInput(DateTime date, Function(DateTime) onChanged) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const Spacer(),
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilterButton(String text) {
    bool isSelected = selectedDateFilter == text;
    return GestureDetector(
      onTap: () => _selectDateRange(text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: onReset,
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400)),
          items:
              options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
