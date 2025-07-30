import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/appapis/api_constants.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientHeaderCard extends StatelessWidget {
  final String name;
  final String age;
  final int? patientId;
  final String condition;
  final String? phone;
  final String? imagePath;
  final bool? isFavourite;
  const PatientHeaderCard({
    Key? key,
    required this.name,
    required this.age,
    this.patientId,
    required this.condition,
    this.phone,
    this.imagePath,
    this.isFavourite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A6CF7).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Patient Avatar
          Builder(
            builder: (context) {
              String? fixedImagePath;
              if (imagePath != null && imagePath!.isNotEmpty) {
                fixedImagePath = imagePath!.replaceAll(r'\', '/');
              }

              ImageProvider? avatarImage;
              if (fixedImagePath != null && fixedImagePath.isNotEmpty) {
                final fullUrl =
                    ApiConstants.imageBaseUrl.endsWith('/')
                        ? ApiConstants.imageBaseUrl.substring(
                          0,
                          ApiConstants.imageBaseUrl.length - 1,
                        )
                        : ApiConstants.imageBaseUrl;

                final cleanedPath =
                    fixedImagePath.startsWith('/')
                        ? fixedImagePath.substring(1)
                        : fixedImagePath;

                final imageUrl = '$fullUrl/$cleanedPath';
                avatarImage = NetworkImage(imageUrl);
              }

              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  image:
                      avatarImage != null
                          ? DecorationImage(
                            image: avatarImage,
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    avatarImage == null
                        ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        )
                        : null,
              );
            },
          ),

          const SizedBox(width: 16),
          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  age,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                Text(
                  condition,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Star and Edit Icons
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final provider = Provider.of<PatientProvider>(
                    context,
                    listen: false,
                  );

                  // Toggle favourite status
                  final newStatus = !(isFavourite ?? false);

                  await provider.updateFavouriteStatus(
                    context,
                    patientId!,
                    newStatus,
                  );
                },
                icon: Icon(
                  Icons.star,
                  color:
                      (isFavourite ?? false)
                          ? AppColors.warningColor
                          : Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editPatientProfileScreen,
                    arguments: patientId,
                  );
                },
                icon: Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
