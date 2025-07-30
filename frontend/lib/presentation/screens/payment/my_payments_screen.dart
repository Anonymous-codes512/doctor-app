import 'package:flutter/material.dart';

enum SortOption {
  alphabetically,
  dateNewest,
  dateOldest,
  amountHighToLow,
  amountLowToHigh,
}

class MyPaymentsScreen extends StatefulWidget {
  const MyPaymentsScreen({super.key});

  @override
  _MyPaymentsScreenState createState() => _MyPaymentsScreenState();
}

class _MyPaymentsScreenState extends State<MyPaymentsScreen> {
  bool isSearchMode = false;
  String searchQuery = '';
  SortOption currentSort = SortOption.dateNewest;
  List<String> searchHistory = ['something', 'something something'];

  // Temporary list of all payments
  final List<Map<String, dynamic>> allPayments = [
    {
      "patient": 'Alice Smith',
      "paymentId": '#PAY-2840',
      "caseItem": 'Anxiety',
      "date": '05/20/25', // Newer date
      "amount": 400.00,
    },
    {
      "patient": 'James Chen',
      "paymentId": '#PAY-2844',
      "caseItem": 'Bipolar',
      "date": '05/18/25',
      "amount": 350.00,
    },
    {
      "patient": 'Emily White',
      "paymentId": '#PAY-2838',
      "caseItem": 'OCD',
      "date": '05/15/25', // Older date
      "amount": 500.00,
    },
    {
      "patient": 'David Green',
      "paymentId": '#PAY-2842',
      "caseItem": 'PTSD',
      "date": '05/19/25',
      "amount": 280.00,
    },
    {
      "patient": 'James Chen',
      "paymentId": '#PAY-2845',
      "caseItem": 'Depression',
      "date": '05/18/25',
      "amount": 320.00,
    },
    {
      "patient": 'Frank Black',
      "paymentId": '#PAY-2839',
      "caseItem": 'Anxiety',
      "date": '05/16/25',
      "amount": 450.00,
    },
  ];

  // Getter to filter and sort payments based on current search query and sort option
  List<Map<String, dynamic>> get filteredPayments {
    List<Map<String, dynamic>> filtered =
        allPayments.where((payment) {
          if (searchQuery.isEmpty) return true;
          return payment['patient'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              payment['caseItem'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              payment['paymentId'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
        }).toList();

    // Apply sorting
    switch (currentSort) {
      case SortOption.alphabetically:
        filtered.sort((a, b) => a['patient'].compareTo(b['patient']));
        break;
      case SortOption.dateNewest:
        filtered.sort((a, b) {
          final dateA = _parseDate(a['date']);
          final dateB = _parseDate(b['date']);
          return dateB.compareTo(dateA);
        });
        break;
      case SortOption.dateOldest:
        filtered.sort((a, b) {
          final dateA = _parseDate(a['date']);
          final dateB = _parseDate(b['date']);
          return dateA.compareTo(dateB);
        });
        break;
      case SortOption.amountHighToLow:
        filtered.sort((a, b) => b['amount'].compareTo(a['amount']));
        break;
      case SortOption.amountLowToHigh:
        filtered.sort((a, b) => a['amount'].compareTo(b['amount']));
        break;
    }

    return filtered;
  }

  // Helper to parse date strings (MM/DD/YY) into DateTime objects for sorting
  DateTime _parseDate(String dateString) {
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse('20${parts[2]}'); // Assuming YY means 20YY
      return DateTime(year, month, day);
    }
    return DateTime.now(); // Fallback in case of invalid date format
  }

  // Returns a color based on the case string
  Color getCaseColor(String caseItem) {
    switch (caseItem.toLowerCase()) {
      case 'anxiety':
        return Colors.purple;
      case 'bipolar':
        return Colors.orange;
      case 'ocd':
        return Colors.pink;
      case 'ptsd':
        return Colors.teal;
      case 'depression':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  int get totalPayments => filteredPayments.length;
  double get totalAmount =>
      filteredPayments.fold(0.0, (sum, payment) => sum + payment['amount']);
  double get outstandingAmount => 750.00; // Fixed value as shown in design

  // Show bottom sheet for filter options
  // void _showFilterBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   'Sort By',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 IconButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   icon: const Icon(Icons.close),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 16),
  //             _buildFilterOption('Alphabetically', SortOption.alphabetically),
  //             _buildFilterOption('Date (newest)', SortOption.dateNewest),
  //             _buildFilterOption('Date (oldest)', SortOption.dateOldest),
  //             _buildFilterOption(
  //               'Amount (high to low)',
  //               SortOption.amountHighToLow,
  //             ),
  //             _buildFilterOption(
  //               'Amount (low to high)',
  //               SortOption.amountLowToHigh,
  //             ),
  //             const SizedBox(height: 20),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildFilterOption(String title, SortOption option) {
  //   return ListTile(
  //     title: Text(title),
  //     trailing:
  //         currentSort == option
  //             ? const Icon(Icons.check, color: Colors.blue)
  //             : null,
  //     onTap: () {
  //       setState(() {
  //         currentSort = option;
  //       });
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Payments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Table Header
          Container(
            color: const Color(0xFFF8F9FA),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Patient',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Case',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Date',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Payment List
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: filteredPayments.length,
                itemBuilder: (context, index) {
                  return _buildPaymentItem(filteredPayments[index]);
                },
              ),
            ),
          ),

          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'May 2025 Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Payments',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '$totalPayments',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Outstanding',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '\$${outstandingAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle export functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Export Payment Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildPaymentItem(Map<String, dynamic> payment) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['patient'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payment['paymentId'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    payment['caseItem'],
                    style: TextStyle(
                      color: getCaseColor(payment['caseItem']),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        payment['date'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${payment['amount'].toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }
}
