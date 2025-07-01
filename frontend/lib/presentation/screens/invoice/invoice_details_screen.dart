import 'package:doctor_app/core/utils/toast_helper.dart';
import 'package:doctor_app/data/models/invoice_model.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final InvoiceModel invoice;
  const InvoiceDetailsScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  late String invoiceNo;
  late String patientName;
  late String patientEmail;
  late String patientPhoneNumber;
  late double amountDue;
  late DateTime? dueDate;
  late String status;
  late DateTime? issuedDate;

  late DoctorProvider doctorProvider;

  @override
  void initState() {
    super.initState();

    // --- Start of Corrected Logic ---

    doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    final invoice = widget.invoice;

    // Initialize data from the invoice widget
    invoiceNo = invoice.invoiceNumber ?? 'N/A';
    patientName = invoice.patientName ?? 'N/A';
    amountDue = (invoice.amountDue as num?)?.toDouble() ?? 0.0;
    dueDate = invoice.dueDate;
    status = invoice.paymentStatus ?? 'N/A';
    issuedDate = widget.invoice.dueDate;

    try {
      final patient = patientProvider.patients.firstWhere(
        (p) => p.id == invoice.patientId,
      );
      patientEmail = patient.email ?? 'N/A';
      patientPhoneNumber = patient.contact ?? 'N/A';
    } catch (e) {
      print('Could not find patient details for $patientName. Error: $e');
      patientEmail = 'N/A';
      patientPhoneNumber = 'N/A';
    }
    // --- End of Corrected Logic ---
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> invoiceItems = [
      {'description': 'Lab test', 'quantity': 1, 'rate': 50.0, 'total': 50.0},
      {
        'description': 'Consultation',
        'quantity': 1,
        'rate': 20.0,
        'total': 20.0,
      },
    ];

    // Placeholder for summary calculations
    final double subTotal = invoiceItems.fold(
      0.0,
      (sum, item) => sum + item['total'],
    );
    final double tax = subTotal * 0.10; // Example 10% tax
    final double discount = subTotal * 0.05; // Example 5% discount
    final double grandTotal = subTotal + tax - discount;
    final double amountPaid =
        grandTotal - amountDue; // Assuming amountDue is remaining

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Invoice Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Handle notifications icon press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invoice No: $invoiceNo',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        status == 'Paid'
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color:
                          status == 'Paid'
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Issued: ${issuedDate != null ? DateFormat('dd MMM yy').format(issuedDate!) : 'N/A'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Due: ${dueDate != null ? DateFormat('dd MMM yy').format(dueDate!) : 'N/A'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Download',
                    const Color(0xFFEEE6F4),
                    () =>
                        doctorProvider.downloadInvoice(context, widget.invoice),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Print',
                    const Color(0xFFEEE6F4),
                    () => doctorProvider.printInvoice(context, widget.invoice),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Share',
                    const Color(0xFFEEE6F4),
                    () => doctorProvider.shareInvoice(context, widget.invoice),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Delete',
                    const Color(0xFFEEE6F4),
                    () => doctorProvider.deleteInvoice(
                      context,
                      widget.invoice.invoiceNumber,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Patient info
            const Text(
              'Patient info:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade50),
                    children: const [
                      _TableCell(
                        'Name',
                        isHeader: true,
                        textAlign: TextAlign.left,
                      ),
                      _TableCell(
                        'Contact',
                        isHeader: true,
                        textAlign: TextAlign.left,
                      ),
                      _TableCell(
                        'Email',
                        isHeader: true,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      _TableCell(patientName, textAlign: TextAlign.left),
                      _TableCell(patientPhoneNumber, textAlign: TextAlign.left),
                      _TableCell(patientEmail, textAlign: TextAlign.left),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Invoice breakdown
            const Text(
              'Invoice breakdown:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade50),
                    children: const [
                      _TableCell(
                        'Description',
                        isHeader: true,
                        textAlign: TextAlign.left,
                      ),
                      _TableCell(
                        'Quantity',
                        isHeader: true,
                        textAlign: TextAlign.left,
                      ),
                      _TableCell(
                        'Rate',
                        isHeader: true,
                        textAlign: TextAlign.left,
                      ),
                      _TableCell(
                        'Total',
                        isHeader: true,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  // Dynamically build invoice item rows
                  ...invoiceItems.map(
                    (item) => TableRow(
                      children: [
                        _TableCell(
                          item['description'].toString(),
                          textAlign: TextAlign.left,
                        ),
                        _TableCell(
                          item['quantity'].toString(),
                          textAlign: TextAlign.left,
                        ),
                        _TableCell(
                          '\$${item['rate'].toStringAsFixed(2)}',
                          textAlign: TextAlign.left,
                        ),
                        _TableCell(
                          '\$${item['total'].toStringAsFixed(2)}',
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bank Details and Summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bank Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bank Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bank name:',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const Text(
                        'UBL',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Account No. :',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const Text(
                        '7584 8747 8485',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                // Summary
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSummaryRow(
                        'SUB TOTAL',
                        '\$${subTotal.toStringAsFixed(2)}',
                      ),
                      _buildSummaryRow('TAX', '\$${tax.toStringAsFixed(2)}'),
                      _buildSummaryRow(
                        'DISCOUNT',
                        '-\$${discount.toStringAsFixed(2)}',
                      ),
                      const Divider(color: Colors.grey),
                      _buildSummaryRow(
                        'GRAND TOTAL',
                        '\$${grandTotal.toStringAsFixed(2)}',
                        isBold: true,
                        fontSize: 14,
                      ),
                      _buildSummaryRow(
                        'AMOUNT PAID',
                        '\$${amountPaid.toStringAsFixed(2)}',
                      ),
                      _buildSummaryRow(
                        'REMAINING AMOUNT',
                        '\$${amountDue.toStringAsFixed(2)}',
                        isBold: true,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Bottom buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedCustomButton(
                    text: 'Mark as paid',
                    onPressed: () {
                      if (status.toLowerCase() != "paid") {
                        doctorProvider.markAsPaid(context, invoiceNo);
                      } else {
                        ToastHelper.showInfo(context, 'Already Paid');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Initiate Payment',
                      style: TextStyle(color: Colors.white),
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

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String amount, {
    bool isBold = false,
    double fontSize = 12,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final TextAlign textAlign;

  const _TableCell(
    this.text, {
    this.isHeader = false,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: isHeader ? Alignment.center : null,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
          color: isHeader ? Colors.black : Colors.black87,
        ),
      ),
    );
  }
}
