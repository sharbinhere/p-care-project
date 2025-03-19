import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:p_care/services/patients/p_profileimage_controller.dart';

class PatientProfileScreen extends StatefulWidget {
  @override
  PatientProfileScreenState createState() => PatientProfileScreenState();
}

class PatientProfileScreenState extends State<PatientProfileScreen> {
  final PatienceProfileController _profileController =
      Get.put(PatienceProfileController());
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final Color _primaryColor = Color.fromARGB(255, 37, 100, 228);

  // Editable fields
  String _name = 'Loading...';
  String _email = 'Loading...';
  String _address = 'Loading...';
  String _age = 'Loading...';
  String _phone = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchUserDetails();
    });
  }

  String? _imageBase64;

  Future<void> _fetchUserDetails() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("No user is signed in");
    return;
  }

  DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('Patients')
      .doc(user.uid)
      .get();

  if (userDoc.exists) {
    setState(() {
      _name = userDoc['name'] ?? 'Not provided';
      _email = user.email ?? 'Not provided';
      _address = userDoc['address'] ?? 'Not provided';
      _age = userDoc['age'] ?? 'Not provided';
      _phone = userDoc['phone'] ?? 'Not provided';
      _imageBase64 = userDoc['profileImage'] ?? null;
      _isLoading = false;
    });

    // ✅ Fetch profile image when loading user details
    _profileController.fetchProfileImage();
  }
}


  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Compress image
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        minWidth: 500,
        minHeight: 500,
        quality: 50,
      );

      if (compressedBytes != null) {
        String base64String = base64Encode(compressedBytes);

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('Patients')
              .doc(user.uid)
              .update({'profileImage': base64String});

          Get.find<PatienceProfileController>()
              .updateProfileImage(base64String);
        }
      }
    }
  }

  void _editField(String fieldName, String currentValue) async {
    String? newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController controller =
            TextEditingController(text: currentValue);
        return AlertDialog(
          title: Text('Edit $fieldName'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $fieldName',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('Save'),
              style: TextButton.styleFrom(
                foregroundColor: _primaryColor,
                backgroundColor: _primaryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        );
      },
    );

    if (newValue != null && newValue.isNotEmpty) {
      // Update Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Patients')
            .doc(user.uid)
            .update({fieldName.toLowerCase(): newValue});

        // Update local state
        setState(() {
          switch (fieldName) {
            case 'Name':
              _name = newValue;
              break;
            case 'Email':
              _email = newValue;
              break;
            case 'Address':
              _address = newValue;
              break;
            case 'Age':
              _age = newValue;
              break;
            case 'Phone':
              _phone = newValue;
              break;
          }
        });
      }
    }
  }

  // Build an editable field widget
  Widget _buildEditableField(String label, String value, String fieldName, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _primaryColor),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: _primaryColor),
          onPressed: () => _editField(fieldName, value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: _primaryColor,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 8),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Obx(() {
                                String currentUserId =
                                    FirebaseAuth.instance.currentUser?.uid ?? "";
                                String base64Image =
                                    _profileController.getProfileImage(currentUserId);

                                return CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: base64Image.isNotEmpty
                                      ? MemoryImage(base64Decode(base64Image))
                                      : AssetImage('assets/default-avatar.png')
                                          as ImageProvider,
                                );
                              }),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: _primaryColor,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          _name,
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _email,
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        _buildEditableField('Name', _name, 'Name', Icons.person),
                        _buildEditableField('Email', _email, 'Email', Icons.email),
                        _buildEditableField('Phone', _phone, 'Phone', Icons.phone),
                        _buildEditableField('Age', _age, 'Age', Icons.calendar_today),
                        _buildEditableField('Address', _address, 'Address', Icons.location_on),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}