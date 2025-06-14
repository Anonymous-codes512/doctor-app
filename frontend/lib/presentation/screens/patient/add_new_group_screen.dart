import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/screens/patient/add_new_patient_screen.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/patient_list_item.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNewGroupScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedPatients;

  const AddNewGroupScreen({Key? key, required this.selectedPatients})
    : super(key: key);

  @override
  _AddNewGroupScreenState createState() => _AddNewGroupScreenState();
}

class _AddNewGroupScreenState extends State<AddNewGroupScreen> {
  final _groupNameController = TextEditingController();

  String? groupValue;
  final List<String> options = ['follow up', 'check up', 'consultation'];

  bool _showSuccessDialog = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPatientAddedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.green, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'New Group Added Successfully',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: PrimaryCustomButton(
                        text: 'Back to my patients',
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, Routes.myPatientsScreen);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Add New Group',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.black),
            onPressed: _showPatientAddedDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        shape: BoxShape.circle,
                      ),
                      child:
                          _selectedImage != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.file(
                                  _selectedImage!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.purple.shade300,
                              ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Group name field
            LabeledTextField(
              label: 'Group name',
              hintText: 'Enter group name here...',
              controller: _groupNameController,
            ),
            const SizedBox(height: 16),

            // Purpose selection
            // This will now align to the start due to parent Column's crossAxisAlignment
            GenderRadioGroup(
              label: 'Purpose',
              groupValue: groupValue,
              options: options,
              onChanged: (value) {
                setState(() {
                  groupValue = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Members text - now left-aligned
            Text(
              'Members: ${widget.selectedPatients.length}',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            // Patient list (fixed height inside scrollable column)
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: widget.selectedPatients.length,
                itemBuilder: (context, index) {
                  final patient = widget.selectedPatients[index];
                  return PatientListItem(
                    name: patient['name'],
                    phoneNumber: patient['phoneNumber'],
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }
}
