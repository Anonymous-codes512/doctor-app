import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/models/invoice_model.dart';
import 'package:doctor_app/presentation/screens/invoice/invoice_filter_popup.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyInvoicesScreen extends StatefulWidget {
  const MyInvoicesScreen({Key? key}) : super(key: key);

  @override
  State<MyInvoicesScreen> createState() => _MyInvoicesScreenState();
}

class _MyInvoicesScreenState extends State<MyInvoicesScreen> {
  String _selectedSort = 'Date';
  late List<InvoiceModel> _invoices;
  @override
  void initState() {
    super.initState();
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    doctorProvider.loadInvoices();
    _invoices = doctorProvider.invoices;
    _sortInvoices(_selectedSort);
  }

  void _sortInvoices(String sortBy) {
    setState(() {
      _selectedSort = sortBy;

      switch (sortBy) {
        case 'Date':
          _invoices.sort((a, b) => b.dueDate!.compareTo(a.dueDate!));
          break;
        case 'Amount':
          _invoices.sort((a, b) => b.amountDue!.compareTo(a.amountDue!));
          break;
        case 'Status':
          _invoices.sort(
            (a, b) => a.paymentStatus!.compareTo(b.paymentStatus!),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'My Invoices',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderColor),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.iconColor,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => InvoiceFilterPopup(),
                      );
                    },
                    icon: const Icon(Icons.filter_alt, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Invoices:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                PopupMenuButton<String>(
                  initialValue: _selectedSort,
                  onSelected: (String result) {
                    _sortInvoices(result);
                  },
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Date',
                          child: Text('Date'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Amount',
                          child: Text('Amount'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Status',
                          child: Text('Status'),
                        ),
                      ],
                  child: Row(
                    children: [
                      const Text(
                        'Sort',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _invoices.length,
                itemBuilder: (context, index) {
                  return _buildInvoiceCard(_invoices[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(InvoiceModel invoice) {
    Color statusColor = AppColors.successColor;
    if (invoice.paymentStatus == 'Pending') {
      statusColor = AppColors.warningColor;
    } else if (invoice.paymentStatus == 'Overdue') {
      statusColor = AppColors.errorColor;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.invoiceDetailScreen,
          arguments: invoice,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildInvoiceRow('Invoice no.', invoice.invoiceNumber ?? ''),
            const SizedBox(height: 8),
            _buildInvoiceRow('Patient name', invoice.patientName ?? ''),
            const SizedBox(height: 8),
            _buildInvoiceRow('Amount due', 'Rs. ${invoice.amountDue}'),
            const SizedBox(height: 8),
            _buildInvoiceRow(
              'Due date',
              '${invoice.dueDate?.day.toString().padLeft(2, '0')}/${invoice.dueDate?.month.toString().padLeft(2, '0')}/${invoice.dueDate?.year}',
            ),
            const SizedBox(height: 8),
            _buildInvoiceRow(
              'Status',
              invoice.paymentStatus ?? '',
              statusColor: statusColor,
            ),
            const SizedBox(height: 8),
            _buildInvoiceRow(
              'Issued date',
              '${invoice.dueDate?.day.toString().padLeft(2, '0')}/${invoice.dueDate?.month.toString().padLeft(2, '0')}/${invoice.dueDate?.year}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(String label, String value, {Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: statusColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
