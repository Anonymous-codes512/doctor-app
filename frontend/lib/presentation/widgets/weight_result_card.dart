import 'package:flutter/material.dart';

class WeightResultCard extends StatelessWidget {
  final String status;
  final String date;
  final String time;
  final String weight;
  final Color statusColor;

  const WeightResultCard({
    Key? key,
    required this.status,
    required this.date,
    required this.time,
    required this.weight,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          // Bottom section: label + weight value
          Column(
            children: [
              Text(
                'Weight (Kg)',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                weight,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
