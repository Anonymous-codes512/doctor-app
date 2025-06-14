import 'package:flutter/material.dart';

class BPResultCard extends StatelessWidget {
  final String status;
  final String date;
  final String time;
  final String systolic;
  final String diastolic;
  final Color statusColor;

  const BPResultCard({
    Key? key,
    required this.status,
    required this.date,
    required this.time,
    required this.systolic,
    required this.diastolic,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Top row: status & date/time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: TextStyle(color: Colors.blue, fontSize: 11),
                  ),
                  Text(
                    time,
                    style: TextStyle(color: Colors.blue, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Divider line
          Divider(color: Colors.grey.shade400, thickness: 1),
          const SizedBox(height: 6),
          // Bottom row: Systolic & Diastolic values
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Systolic(mmHg)',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      systolic,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 40, width: 1, color: Colors.grey.shade400),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Diastolic(mmHg)',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      diastolic,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
