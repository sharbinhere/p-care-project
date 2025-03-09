import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/about_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/feedback_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/profile_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/patiant_needs_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/patient_view_screen.dart';
import 'package:p_care/screens/patiants/homescreen/draweritems/patient_profile_screen.dart';
import 'package:p_care/screens/patiants/homescreen/feedback_screen.dart';
import 'package:p_care/screens/patiants/homescreen/need_screen.dart';
import 'package:p_care/screens/patiants/homescreen/report_view_screen.dart';
import 'package:p_care/services/caretakers/c_auth_controller.dart';
import 'package:p_care/services/caretakers/profileimage_controller.dart';
import 'package:p_care/services/patients/auth_controller.dart';
//import 'package:get/get.dart';
import 'dart:convert';

class PatientsHomeScreen extends StatefulWidget {
  const PatientsHomeScreen({super.key});

  @override
  _PatientsHomeScreenState createState() => _PatientsHomeScreenState();
}

class _PatientsHomeScreenState extends State<PatientsHomeScreen> {
  final _ctrl = Get.put(PatiantAuthController());
  final ProfileController profileController = Get.put(ProfileController());

  // List of dashboard items
  final List dashboardData = const [
    {
      "id": 1,
      "title": "Report View",
      "icon": Icons.report,
      "background_color": Colors.deepOrange,
    },
    {
      "id": 2,
      "title": "What you need",
      "icon": Icons.book,
      "background_color": Colors.pink,
    },
    {
      "id": 3,
      "title": "Give your feedback",
      "icon": Icons.health_and_safety,
      "background_color": Color.fromARGB(255, 13, 198, 10),
    },
  ];

  // Method to handle tap on dashboard items
  void handleTap(int id, BuildContext context) {
    switch (id) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportViewScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NeedScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatienceFeedbackScreen()),
        );
        break;
      default:
    }
  }

  // Method to fetch the current user's name and email
  Future<Map<String, String?>> getCurrentUserDetails() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'name': null, 'email': null};

    // Fetch the user's data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Patients') // Replace with your collection name
        .doc(user.uid) // Use the user's UID as the document ID
        .get();

    // Return the user's name and email
    return {
      'name': userDoc['name'], // Replace 'name' with the field name in Firestore
      'email': user.email, // Get email from Firebase Auth
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 37, 100, 228),
        centerTitle: true,
        title: const Text(
          'P-CARE',
          style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        elevation: 16,
        child: FutureBuilder<Map<String, String?>>(
          future: getCurrentUserDetails(),
          builder: (context, snapshot) {
            String name = 'Guest';
            String email = 'No email';

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                name = snapshot.data!['name'] ?? 'Guest';
                email = snapshot.data!['email'] ?? 'No email';
              }
            }

            return ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 37, 100, 228),
                  ),
                  accountName: Text(name),
                  accountEmail: Text(email),
                  currentAccountPicture: Obx(
                    ()=> CircleAvatar(
                    backgroundImage: profileController.profileImage.value.isNotEmpty
                        ? MemoryImage(base64Decode(profileController.profileImage.value))
                        : const AssetImage('assets/default-avatar.png') as ImageProvider,
                                    ),
                  )
                ),
                ListTile(
                  leading: const Icon(Icons.home,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Home',
                      style: TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Profile',
                      style: TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Get.to(PatientProfileScreen()); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Logout',
                      style: TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    _ctrl.signOut();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('About us',
                      style: TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Get.to(AboutUsScreen()); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Feedback',
                      style: TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Get.to(FeedbackScreen()); // Close the drawer
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 37, 100, 228),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    title: FutureBuilder<Map<String, String?>>(
                      future: getCurrentUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text(
                            'Welcome',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            'Welcome Guest',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Text(
                            'Welcome Guest',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return Text(
                            'Welcome ${snapshot.data!['name'] ?? 'Guest'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                    subtitle: const Text(
                      'Manage your patients efficiently',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Obx(
                      ()=> CircleAvatar(
                                        backgroundImage: profileController.profileImage.value.isNotEmpty
                        ? MemoryImage(base64Decode(profileController.profileImage.value))
                        : const AssetImage('assets/default-avatar.png') as ImageProvider,
                                      ),
                    ))
                ],
              ),
            ),
          ),
          const SizedBox(height: 35),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dashboardData.length,
            itemBuilder: (context, index) {
              final data = dashboardData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: InkWell(
                  onTap: () {
                    handleTap(data['id'], context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 5),
                          color: Theme.of(context).primaryColor.withOpacity(.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: data['background_color'],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            data['icon'],
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          data['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 