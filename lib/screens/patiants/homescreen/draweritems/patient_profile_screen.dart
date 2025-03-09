import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_care/services/caretakers/c_auth_controller.dart';
import 'dart:convert'; // Import for Base64 conversion
import 'package:flutter/services.dart';
import 'package:p_care/services/caretakers/profileimage_controller.dart';

class PatientProfileScreen extends StatefulWidget {
  @override
  PatientProfileScreenState createState() => PatientProfileScreenState();
}

class PatientProfileScreenState extends State<PatientProfileScreen> {
  final _ctrl = Get.put(CaretakerAuthController());
  final ProfileController _profileController = Get.put(ProfileController());
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Editable fields
  String _name = 'Loading...';
  String _email = 'Loading...';
  String _address = 'Loading...';
  String _age = 'Loading...';
  String _phone = 'Loading...';
  String _about = 'Type something about you...';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  String? _imageBase64; // Store Base64 string
  // Fetch current user's details from Firestore

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
        _about = userDoc['about'] ?? 'Not provided';
        _imageBase64 = userDoc['profileImage'] ?? null; //Fetch Base64 image
      });
      if (userDoc['profileImage'] != null) {
        _profileController.updateProfileImage(userDoc['profileImage']);
      }
    }
  }

  // Pick image from gallery

  Future<void> _pickImage() async {
  final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);

    // Compress image before uploading (optional)
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

        // ✅ Notify HomeScreen to update instantly
        Get.find<ProfileController>().updateProfileImage(base64String);
      }
    }
  }
}


  // Edit a field and update Firestore
  void _editField(String fieldName, String currentValue) async {
    String? newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController controller =
            TextEditingController(text: currentValue);
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter $fieldName'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('Save'),
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
            case 'About':
              _about = newValue;
              break;
          }
        });
      }
    }
  }

  // Build an editable field widget
  Widget _buildEditableField(String label, String value, String fieldName) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      trailing: Icon(Icons.edit, color: Colors.blue),
      onTap: () => _editField(fieldName, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : _profileController.profileImage.value.isNotEmpty
                                ? MemoryImage(base64Decode(
                                    _profileController.profileImage.value))
                                : AssetImage('assets/default-avatar.png')
                                    as ImageProvider,
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                _name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                _email,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Divider(),
              _buildEditableField('Name', _name, 'Name'),
              _buildEditableField('Email', _email, 'Email'),
              _buildEditableField('Address', _address, 'Address'),
              _buildEditableField('Age', _age, 'Age'),
              _buildEditableField('Phone', _phone, 'Phone'),
              _buildEditableField('About', _about, 'About'),
            ],
          ),
        ),
      ),
    );
  }
} 