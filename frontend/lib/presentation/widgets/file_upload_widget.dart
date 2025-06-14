import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class FileUploadWidget extends StatelessWidget {
  const FileUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomPaint(
        foregroundPainter: DottedBorderPainter(
          borderColor: AppColors.primaryColor,
        ),
        painter: DottedBorderPainter(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Upload icon
              SizedBox(
                width: 60,
                height: 60,

                child: const Icon(
                  Icons.cloud_upload_outlined, // Or Icons.upload_outlined
                  color: AppColors.primaryColor, // A deep purple for the icon
                  size: 60,
                ),
              ),
              const SizedBox(height: 16),
              // "Drag and drop files here" text
              const Text(
                'Drag and drop files here',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // "or" text
              const Text(
                'or',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // "Browse Files" button
              OutlinedButton(
                onPressed: () {
                  print('Browse Files button pressed!');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor, // Text color
                  side: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ), // Border color and thickness
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Browse Files',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),
              // "Supported formats" text
              const Text(
                'Supported formats: PDF, Word, Images',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPainter to draw the dashed border
class DottedBorderPainter extends CustomPainter {
  final Color borderColor;

  DottedBorderPainter({this.borderColor = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color =
              borderColor // Color of the dots
          ..strokeWidth =
              1.0 // Thickness of the dots
          ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;
    double currentX = 0;
    double currentY = 0;

    // Draw top border
    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, 0),
        Offset(currentX + dashWidth, 0),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }

    currentX = 0;
    currentY = size.height;
    // Draw bottom border
    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, size.height),
        Offset(currentX + dashWidth, size.height),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }

    currentX = 0;
    currentY = 0;
    // Draw left border
    while (currentY < size.height) {
      canvas.drawLine(
        Offset(0, currentY),
        Offset(0, currentY + dashWidth),
        paint,
      );
      currentY += dashWidth + dashSpace;
    }

    currentX = size.width;
    currentY = 0;
    // Draw right border
    while (currentY < size.height) {
      canvas.drawLine(
        Offset(size.width, currentY),
        Offset(size.width, currentY + dashWidth),
        paint,
      );
      currentY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Example of how to use this widget in a main.dart file
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:
            Colors.grey[100], // A light grey background for the Scaffold
        appBar: AppBar(
          title: const Text('File Upload UI'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: FileUploadWidget(),
          ),
        ),
      ),
    );
  }
}
