import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> invoice;
  const InvoiceDetailsScreen({Key? key, required this.invoice})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extracting data from the invoice map
    final String invoiceNo = invoice['invoiceNo'] ?? 'N/A';
    final String patientName = invoice['patientName'] ?? 'N/A';
    final double amountDue = (invoice['amountDue'] as num?)?.toDouble() ?? 0.0;
    final DateTime? dueDate = invoice['dueDate'];
    final String status = invoice['status'] ?? 'N/A';
    final DateTime? issuedDate = invoice['issuedDate'];

    // Placeholder for actual data from breakdown (assuming static for this example)
    // In a real app, this would also come from the 'invoice' map
    final List<Map<String, dynamic>> invoiceItems = [
      {'description': 'Lab test', 'quantity': 1, 'rate': 50.0, 'total': 50.0},
      {
        'description': 'Consultation',
        'quantity': 1,
        'rate': 20.0,
        'total': 20.0,
      },
    ];

    // Placeholder for summary calculations (these would be dynamic based on invoiceItems)
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
            // Invoice Header (showing dynamic invoice number and status)
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
              'Issued: ${issuedDate != null ? DateFormat('dd MMM yyyy').format(issuedDate) : 'N/A'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Due: ${dueDate != null ? DateFormat('dd MMM yyyy').format(dueDate) : 'N/A'}',
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
                    () => _downloadInvoice(context, invoice),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Print',
                    const Color(0xFFEEE6F4),
                    () => _printInvoice(context, invoice),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Share',
                    const Color(0xFFEEE6F4),
                    () => _shareInvoice(context, invoice),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Delete',
                    const Color(0xFFEEE6F4),
                    () => _deleteInvoice(context, invoice['invoiceNo']),
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
                      const _TableCell('+12345678', textAlign: TextAlign.left),
                      const _TableCell(
                        'john@gmail.com',
                        textAlign: TextAlign.left,
                      ),
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
                  child: OutlinedButton(
                    onPressed: () {
                      _markAsPaid(context, invoice['invoiceNo']);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    child: const Text(
                      'Mark as paid',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _initiatePayment(context, grandTotal);
                    },
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black87,
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

  Future<void> _downloadInvoice(
    BuildContext context,
    Map<String, dynamic> invoiceData,
  ) async {
    try {
      final pdf = pw.Document();

      // Simple PDF structure for testing
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(
                'Invoice No: ${invoiceData['invoiceNo']}',
                style: pw.TextStyle(fontSize: 24),
              ),
            );
          },
        ),
      );

      // Ask the user for the location where to save the file
      String? filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Invoice PDF',
        fileName: 'invoice_${invoiceData['invoiceNo']}.pdf',
        allowedExtensions: ['pdf'],
      );

      // Check if filePath is selected
      if (filePath != null) {
        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invoice downloaded to ${file.path}')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download cancelled.')));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to download invoice: $e')));
    }
  }

  Future<void> _printInvoice(
    BuildContext context,
    Map<String, dynamic> invoiceData,
  ) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Invoice Details',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Invoice No: ${invoiceData['invoiceNo']}'),
                pw.Text('Patient Name: ${invoiceData['patientName']}'),
                pw.Text(
                  'Issued Date: ${DateFormat('dd MMM yyyy').format(invoiceData['issuedDate'])}',
                ),
                pw.Text(
                  'Due Date: ${DateFormat('dd MMM yyyy').format(invoiceData['dueDate'])}',
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Items:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Table.fromTextArray(
                  headers: ['Description', 'Quantity', 'Rate', 'Total'],
                  data: [
                    for (var item
                        in (invoiceData['invoiceItems'] as List? ?? []))
                      [
                        item['description'],
                        item['quantity'].toString(),
                        '\$${item['rate'].toStringAsFixed(2)}',
                        '\$${item['total'].toStringAsFixed(2)}',
                      ],
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Align(
                  alignment: pw.Alignment.topRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Sub Total: \$${(invoiceData['subTotal'] as num).toStringAsFixed(2)}',
                      ),
                      pw.Text(
                        'Tax: \$${(invoiceData['tax'] as num).toStringAsFixed(2)}',
                      ),
                      pw.Text(
                        'Discount: -\$${(invoiceData['discount'] as num).toStringAsFixed(2)}',
                      ),
                      pw.Divider(),
                      pw.Text(
                        'Grand Total: \$${(invoiceData['grandTotal'] as num).toStringAsFixed(2)}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Amount Paid: \$${(invoiceData['amountPaid'] as num).toStringAsFixed(2)}',
                      ),
                      pw.Text(
                        'Remaining Amount: \$${(invoiceData['amountDue'] as num).toStringAsFixed(2)}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Print dialog opened.')));
    } catch (e) {
      print('🚨🚨🚨🚨🚨🚨 $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to print invoice: $e')));
    }
  }

  Future<void> _shareInvoice(
    BuildContext context,
    Map<String, dynamic> invoiceData,
  ) async {
    try {
      final String invoiceSummary = '''
Invoice Details:
Invoice No: ${invoiceData['invoiceNo']}
Patient Name: ${invoiceData['patientName']}
Status: ${invoiceData['status']}
Amount Due: \$${(invoiceData['amountDue'] as num).toStringAsFixed(2)}
Issued Date: ${DateFormat('dd MMM yyyy').format(invoiceData['issuedDate'])}
Due Date: ${DateFormat('dd MMM yyyy').format(invoiceData['dueDate'])}

Items:
${(invoiceData['invoiceItems'] as List? ?? []).map((item) => '- ${item['description']} (Qty: ${item['quantity']}, Rate: \$${item['rate'].toStringAsFixed(2)})').join('\n')}

Summary:
Sub Total: \$${(invoiceData['subTotal'] as num).toStringAsFixed(2)}
Tax: \$${(invoiceData['tax'] as num).toStringAsFixed(2)}
Discount: -\$${(invoiceData['discount'] as num).toStringAsFixed(2)}
Grand Total: \$${(invoiceData['grandTotal'] as num).toStringAsFixed(2)}
Amount Paid: \$${(invoiceData['amountPaid'] as num).toStringAsFixed(2)}
Remaining Amount: \$${(invoiceData['amountDue'] as num).toStringAsFixed(2)}
''';

      await Share.share(
        invoiceSummary,
        subject: 'Invoice ${invoiceData['invoiceNo']}',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Share sheet opened.')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to share invoice: $e')));
    }
  }

  void _deleteInvoice(BuildContext context, String? invoiceNo) {
    if (invoiceNo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice number is missing.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete invoice $invoiceNo?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // In a real application, you would perform the actual deletion here.
                // This might involve:
                // 1. Calling an API endpoint.
                // 2. Deleting from a local database.
                print(
                  'Deleting invoice $invoiceNo',
                ); // Placeholder for actual delete logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invoice $invoiceNo deleted successfully.'),
                  ),
                );
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void _markAsPaid(BuildContext context, String invoiceNo) {
    // In a real app, you would update the status in your backend or local storage.
    // For this example, we'll just show a confirmation.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invoice $invoiceNo marked as paid.')),
    );
    // You might want to update the 'status' in the invoice object and rebuild the widget
    // if this screen needs to reflect the change immediately without navigating back.
  }

  void _initiatePayment(BuildContext context, double amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Initiating payment for \$${amount.toStringAsFixed(2)}'),
      ),
    );
    // Here you would integrate with a payment gateway.
    // This could involve:
    // 1. Opening a web view for a payment portal.
    // 2. Using a native SDK for payment processing.
    // 3. Making an API call to your backend to start the payment flow.
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final TextAlign textAlign;

  const _TableCell(
    this.text, {
    this.isHeader = false,
    this.textAlign = TextAlign.left, // Set a default value for textAlign
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
