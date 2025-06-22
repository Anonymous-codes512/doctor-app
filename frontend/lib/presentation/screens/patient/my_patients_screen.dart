import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart'; // Assuming this is SearchBarWithAddButton
import 'package:doctor_app/presentation/widgets/patient_list_item.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:doctor_app/data/models/patient_model.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAddPressed;
  final bool showAddButton;
  final Color? backgroundColor;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onAddPressed,
    this.showAddButton = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          if (showAddButton)
            InkWell(
              onTap: onAddPressed,
              child: const Icon(Icons.add, color: Colors.black, size: 20),
            ),
        ],
      ),
    );
  }
}

class MyPatientsScreen extends StatefulWidget {
  const MyPatientsScreen({Key? key}) : super(key: key);

  @override
  State<MyPatientsScreen> createState() => _MyPatientsScreenState();
}

class _MyPatientsScreenState extends State<MyPatientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Patient> filteredPatients = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    // Fetch patients on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );
      patientProvider.fetchPatients().then((_) {
        // Initialize filteredPatients with all patients after fetching
        setState(() {
          filteredPatients = patientProvider.patients;
        });
      });
    });

    _searchController.addListener(() {
      _filterPatients(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPatients(String query) {
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    final allPatients = patientProvider.patients;

    setState(() {
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        filteredPatients = allPatients;
      } else {
        final lowerQuery = query.toLowerCase();
        filteredPatients =
            allPatients.where((patient) {
              final name = patient.fullName.toLowerCase();
              final contact = patient.contact.toLowerCase();
              return name.contains(lowerQuery) || contact.contains(lowerQuery);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'My Patients',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, _) {
          // Always show the search bar and add button at the top of the body
          return Column(
            children: [
              SearchBarWithAddButton(
                controller: _searchController,
                onChanged: _filterPatients,
                onAddPressed: () {
                  Navigator.pushNamed(context, Routes.addNewPatientScreen);
                },
                onTap: () {},
              ),
              const SizedBox(height: 10),
              if (patientProvider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (patientProvider.patients.isEmpty &&
                  !_isSearching) // Show message only if no patients and not actively searching
                const Expanded(
                  child: Center(
                    child: Text(
                      'No patients found. Add a new patient to get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.iconColor,
                      ),
                    ),
                  ),
                )
              else if (filteredPatients.isEmpty &&
                  _isSearching) // Message for no search results
                const Expanded(
                  child: Center(
                    child: Text(
                      'No matching patients found for your search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.iconColor,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        filteredPatients.length, // Use filteredPatients here
                    itemBuilder: (context, index) {
                      final patient =
                          filteredPatients[index]; // Use filteredPatients here
                      return PatientListItem(
                        name: patient.fullName,
                        phoneNumber: patient.contact,
                        imagePath: patient.imagePath,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.patientProfileScreen,
                            arguments: patient,
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
