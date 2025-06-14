import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/patient_list_item.dart';
import 'package:flutter/material.dart';

class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PatientSelectionScreen> createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  // Sample patient data.
  // We'll filter this list to ensure we don't display 'groups' category patients for selection.
  final List<Map<String, dynamic>> allPatients = [
    {
      'name': 'Alexender',
      'phoneNumber': '+917622365663',
      'category': 'alphabetical',
    },
    {
      'name': 'Alex',
      'phoneNumber': '+917622365663',
      'category': 'alphabetical',
    },
    {
      'name': 'John',
      'phoneNumber': '+917622365663',
      'category': 'alphabetical',
    },
    {
      'name': 'Jane',
      'phoneNumber': '+917622365663',
      'category': 'alphabetical',
    },
    {
      'name': 'Cathline',
      'phoneNumber': '+917622365663',
      'category': 'favorites',
    },
    {
      'name': 'Ben xyz',
      'phoneNumber': '+917622365663',
      'category': 'alphabetical',
    },
    {
      'name': 'David',
      'phoneNumber': '+919876543210',
      'category': 'alphabetical',
    },
    {
      'name': 'Ella',
      'phoneNumber': '+911234567890',
      'category': 'alphabetical',
    },
    // Patients already in groups (or with null phone numbers) are typically not selectable for new groups
    // unless you have specific logic for that. I've added a category to help filter.
    {'name': 'Group A Patient 1', 'phoneNumber': null, 'category': 'groups'},
    {'name': 'Group A Patient 2', 'phoneNumber': null, 'category': 'groups'},
    {'name': 'Group B Patient 1', 'phoneNumber': null, 'category': 'groups'},
    {'name': 'Group B Patient 2', 'phoneNumber': null, 'category': 'groups'},
    {
      'name': 'Favorites Patient 1',
      'phoneNumber': '+919876543210',
      'category': 'favorites',
    },
    {
      'name': 'Favorites Patient 2',
      'phoneNumber': '+919876543210',
      'category': 'favorites',
    },
    {
      'name': 'Fiona',
      'phoneNumber': '+911122334455',
      'category': 'alphabetical',
    },
    {
      'name': 'George',
      'phoneNumber': '+916677889900',
      'category': 'alphabetical',
    },
  ];

  // This list will store the patients the user selects using the checkboxes.
  final List<Map<String, dynamic>> _selectedPatients = [];

  // This list will hold the patients that are actually available for selection (e.g., not already in groups).
  List<Map<String, dynamic>> _selectablePatients = [];

  @override
  void initState() {
    super.initState();
    // Initialize _selectablePatients by filtering out patients that don't have a phone number
    // or are already categorized as 'groups' (adjust this logic based on your exact requirements).
    _selectablePatients =
        allPatients
            .where(
              (patient) =>
                  patient['phoneNumber'] != null &&
                  patient['category'] != 'groups',
            )
            .toList();

    // Sort selectable patients alphabetically by name for a better user experience.
    _selectablePatients.sort(
      (a, b) => (a['name'] as String).compareTo(b['name'] as String),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ), // Changed to close icon
          onPressed: () => Navigator.pop(context), // Pop without returning data
        ),
        centerTitle: true,
        title: const Text(
          'Add Patients to Group', // More specific title
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.addNewGroupScreen,
                arguments: _selectedPatients,
              );
            },
          ),
        ],
      ),
      body:
          _selectablePatients.isEmpty
              ? const Center(
                child: Text(
                  'No patients available for selection.',
                  style: TextStyle(fontSize: 16, color: AppColors.iconColor),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _selectablePatients.length,
                      itemBuilder: (context, index) {
                        final patient = _selectablePatients[index];
                        // Check if the current patient is already in the selected list
                        final isSelected = _selectedPatients.contains(patient);

                        return PatientListItem(
                          name: patient['name'],
                          phoneNumber: patient['phoneNumber'],
                          // Add a trailing checkbox
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (bool? newValue) {
                              setState(() {
                                if (newValue == true) {
                                  _selectedPatients.add(patient);
                                } else {
                                  _selectedPatients.remove(patient);
                                }
                              });
                            },
                            activeColor:
                                AppColors
                                    .primaryColor, // Customize checkbox color
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
