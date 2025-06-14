import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CalendarTaskCard extends StatelessWidget {
  final String name;
  final String phone;
  final String date;
  final String time;
  final String imageUrl;
  final bool isGrid;

  const CalendarTaskCard({
    super.key,
    required this.name,
    required this.phone,
    required this.date,
    required this.time,
    required this.imageUrl,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isGrid ? 250 : double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: isGrid ? 8 : 0),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 20, backgroundImage: NetworkImage(imageUrl)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // important for vertical flexibility
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (phone.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    phone,
                    style: TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Text(
            time,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
