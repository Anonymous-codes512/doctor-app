import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:doctor_app/presentation/widgets/patient_list_item.dart';
import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> allPatients = [
    {
      'name': 'Alexender',
      'phoneNumber': '+917622365663',
      'category': 'former',
      'age': 45,
      'disease': 'Diabetes',
      'gender': 'Male',
      'lastVisitDate': '2024-05-10',
    },
    {
      'name': 'Alex',
      'phoneNumber': '+917622365663',
      'category': 'former',
      'age': 50,
      'disease': 'Hypertension',
      'gender': 'Male',
      'lastVisitDate': '2024-04-22',
    },
    {
      'name': 'Cathline',
      'phoneNumber': '+917622365663',
      'category': 'favorites',
      'age': 38,
      'disease': 'Asthma',
      'gender': 'Female',
      'lastVisitDate': '2024-03-18',
    },
    {
      'name': 'Ben xyz',
      'phoneNumber': '+917622365663',
      'category': 'alphabetical',
      'age': 28,
      'disease': 'Healthy',
      'gender': 'Male',
      'lastVisitDate': '2024-02-10',
    },
    {
      'name': 'David',
      'phoneNumber': '+919876543210',
      'category': 'alphabetical',
      'age': 34,
      'disease': 'Allergy',
      'gender': 'Male',
      'lastVisitDate': '2024-01-15',
    },
    {
      'name': 'Ella',
      'phoneNumber': '+911234567890',
      'category': 'alphabetical',
      'age': 29,
      'disease': 'Migraine',
      'gender': 'Female',
      'lastVisitDate': '2024-04-01',
    },
    {
      'group_name': 'Group A',
      'purpose': 'Follow Up',
      'category': 'groups',
      'members': [
        {
          'name': 'Ali Raza',
          'age': 32,
          'disease': 'Diabetes',
          'phone': '03001234567',
        },
        {
          'name': 'Sara Khan',
          'age': 29,
          'disease': 'Hypertension',
          'phone': '03007654321',
        },
      ],
    },
    {
      'group_name': 'Group B',
      'purpose': 'Consultant',
      'category': 'groups',
      'members': [
        {
          'name': 'John Doe',
          'age': 40,
          'disease': 'Heart Disease',
          'phone': '03007894567',
        },
        {
          'name': 'Jane Smith',
          'age': 35,
          'disease': 'Asthma',
          'phone': '03008943212',
        },
        {
          'name': 'Tom Hardy',
          'age': 37,
          'disease': 'Diabetes',
          'phone': '03001122334',
        },
      ],
    },
    {
      'name': 'Fiona',
      'phoneNumber': '+911122334455',
      'category': 'alphabetical',
      'age': 27,
      'disease': 'Healthy',
      'gender': 'Female',
      'lastVisitDate': '2024-03-05',
    },
    {
      'name': 'George',
      'phoneNumber': '+916677889900',
      'category': 'alphabetical',
      'age': 36,
      'disease': 'Back Pain',
      'gender': 'Male',
      'lastVisitDate': '2024-02-25',
    },
  ];

  List<Map<String, dynamic>> filteredPatients = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredPatients = List.from(allPatients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPatients(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredPatients = List.from(allPatients);
      } else {
        final lowerCaseQuery = query.toLowerCase();
        filteredPatients =
            allPatients.where((patient) {
              if (patient['category'] == 'groups') {
                final groupName = patient['group_name']?.toLowerCase() ?? '';
                return groupName.contains(lowerCaseQuery);
              } else {
                final name = patient['name']?.toLowerCase() ?? '';
                final phoneNumber = patient['phoneNumber']?.toLowerCase() ?? '';
                return name.contains(lowerCaseQuery) ||
                    phoneNumber.contains(lowerCaseQuery);
              }
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> groupedPatients = {};
    for (var patient in filteredPatients) {
      final category = patient['category'] as String;
      groupedPatients.putIfAbsent(category, () => []).add(patient);
    }

    if (groupedPatients.containsKey('alphabetical')) {
      groupedPatients['alphabetical']!.sort(
        (a, b) => (a['name'] as String).compareTo(b['name'] as String),
      );
    }

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
      body: Column(
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
          Expanded(
            child:
                filteredPatients.isEmpty && _isSearching
                    ? const Center(
                      child: Text(
                        'No patients found',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.iconColor,
                        ),
                      ),
                    )
                    : ListView(
                      children: [
                        if (groupedPatients.containsKey('former') &&
                            !_isSearching)
                          SectionHeader(
                            title: 'Former Patients',
                            backgroundColor: AppColors.gradientBottom
                                .withOpacity(0.1),
                            showAddButton: true,
                            onAddPressed: () {},
                          ),
                        if (groupedPatients.containsKey('former') &&
                            !_isSearching)
                          ...groupedPatients['former']!.map((patient) {
                            return _buildPatientListItem(patient);
                          }),

                        if (groupedPatients.containsKey('groups') &&
                            !_isSearching)
                          SectionHeader(
                            title: 'Groups',
                            showAddButton: true,
                            onAddPressed: () {
                              Navigator.pushNamed(
                                context,
                                Routes.patientSelectionScreen,
                              );
                            },
                          ),
                        if (groupedPatients.containsKey('groups') &&
                            !_isSearching)
                          ...groupedPatients['groups']!.map((patient) {
                            return _buildPatientListItem(patient);
                          }),

                        ..._buildDynamicPatientList(
                          filteredPatients,
                          _isSearching,
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientListItem(Map<String, dynamic> patient) {
    return PatientListItem(
      name:
          patient['category'] == 'groups'
              ? patient['group_name'] as String
              : patient['name'] as String,
      phoneNumber:
          patient['category'] == 'groups'
              ? ''
              : (patient['phoneNumber']?.toString() ?? ''),
      onTap: () {
        if (patient['category'] == 'groups') {
          Navigator.pushNamed(
            context,
            Routes.groupProfileScreen,
            arguments: patient,
          );
        } else {
          Navigator.pushNamed(
            context,
            Routes.patientProfileScreen,
            arguments: patient,
          );
        }
      },
    );
  }

  List<Widget> _buildDynamicPatientList(
    List<Map<String, dynamic>> patients,
    bool isSearching,
  ) {
    if (patients.isEmpty) return [];

    if (isSearching) {
      return patients.map((patient) {
        return _buildPatientListItem(patient);
      }).toList();
    } else {
      final Map<String, List<Map<String, dynamic>>> alphabeticalSections = {};
      for (var patient in patients.where(
        (p) => p['category'] == 'alphabetical',
      )) {
        final firstLetter = (patient['name'] as String)[0].toUpperCase();
        alphabeticalSections.putIfAbsent(firstLetter, () => []).add(patient);
      }

      final sortedKeys = alphabeticalSections.keys.toList()..sort();

      List<Widget> sectionWidgets = [];
      for (var key in sortedKeys) {
        sectionWidgets.add(SectionHeader(title: key));
        for (var patient in alphabeticalSections[key]!) {
          sectionWidgets.add(_buildPatientListItem(patient));
        }
        sectionWidgets.add(const SizedBox(height: 20));
      }
      return sectionWidgets;
    }
  }
}
