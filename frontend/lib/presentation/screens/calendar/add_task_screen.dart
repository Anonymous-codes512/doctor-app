// lib/presentation/screens/add_task_screen.dart
import 'package:doctor_app/presentation/widgets/date_selector_widget.dart';
import 'package:doctor_app/presentation/widgets/labeled_dropdown.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/outlined_custom_button.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/time_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/core/assets/colors/app_colors.dart'; // Ensure this path is correct

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String? _selectedPriority;
  final List<String> _priorityOptions = ['High', 'Medium', 'Low'];

  String? _selectedCategory;
  final List<String> _categoryOptions = [
    'Patient care',
    'Admin',
    'Regular',
    'Follow up',
  ];

  DateTime get initialDate => _selectedDate;
  TimeOfDay get initialTime => _selectedTime;

  void onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _selectedTime = newTime;
    });
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _dueDateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Task',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledTextField(
                label: 'Task title',
                hintText: 'Enter title here',
                controller: _taskNameController,
              ),
              const SizedBox(height: 16),
              LabeledDropdown(
                label: 'Priority',
                items: _priorityOptions,
                selectedValue: _selectedPriority, // Set this to null initially
                onChanged: (value) {
                  setState(() {
                    _selectedPriority =
                        value; // No need to check for 'Select Priority'
                  });
                },
              ),

              const SizedBox(height: 16),
              LabeledDropdown(
                label: 'Task Category',
                items: _categoryOptions,
                selectedValue: _selectedCategory, // Set this to null initially
                onChanged: (value) {
                  setState(() {
                    _selectedCategory =
                        value; // No need to check for 'Select Category'
                  });
                },
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Patient Name',
                hintText: 'Patient name here',
                controller: _patientNameController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Description',
                hintText:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                controller: _descriptionController,
                maxline: 4,
              ),
              const SizedBox(height: 16),

              DateSelectorWidget(
                initialDate: initialDate,
                onDateChanged: onDateChanged,
                label: 'Due Date',
              ),
              const SizedBox(height: 16),

              TimeSelectorWidget(
                initialTime: initialTime,
                onTimeChanged: onTimeChanged,
              ),

              const SizedBox(height: 16),

              OutlinedCustomButton(
                text: 'Reminders',
                onPressed: () {},
                trailingIcon: const Icon(Icons.notifications),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedCustomButton(
                      text: 'Cancel',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryCustomButton(text: 'Save', onPressed: () {}),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
