import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/about_screen.dart';
import 'package:p_care/screens/patiants/homescreen/caretaker_list.dart';
import 'package:p_care/screens/patiants/homescreen/caretakers_contact.dart';
import 'package:p_care/screens/patiants/homescreen/draweritems/patient_profile_screen.dart';
import 'package:p_care/screens/patiants/homescreen/need_screen.dart';
import 'package:p_care/screens/patiants/homescreen/report_view_screen.dart';
import 'package:p_care/services/patients/auth_controller.dart';
import 'dart:convert';
import 'package:p_care/services/patients/p_profileimage_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientsHomeScreen extends StatefulWidget {
  const PatientsHomeScreen({super.key});

  @override
  _PatientsHomeScreenState createState() => _PatientsHomeScreenState();
}

class _PatientsHomeScreenState extends State<PatientsHomeScreen> {
  final _ctrl = Get.put(PatiantAuthController());
  final PatienceProfileController profileController =
      Get.put(PatienceProfileController());

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
      "icon": Icons.feedback,
      "background_color": Color.fromARGB(255, 13, 198, 10),
    },
    {
      "id": 4,
      "title": "Contact caretakers",
      "icon": Icons.phone,
      "background_color": Colors.blue
    }
  ];

  // Method to handle tap on dashboard items
  void handleTap(int id, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar("Error", "User not logged in",
          backgroundColor: Color.fromARGB(255, 37, 100, 228),
          colorText: Colors.white);
      return;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Patients') // Replace with your collection name
        .doc(user.uid) // Use the user's UID as the document ID
        .get();

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
          MaterialPageRoute(
              builder: (context) => NeedsMentioningScreen(
                    patientId: user.uid,
                    patientName: userDoc['name'],
                  )),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CaretakerListScreen()),
        );
        break;

      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CareTakersContact()),
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
      'name':
          userDoc['name'], // Replace 'name' with the field name in Firestore
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  currentAccountPicture: Obx(() {
                    String currentUserId =
                        FirebaseAuth.instance.currentUser?.uid ?? "";
                    String base64Image =
                        profileController.getProfileImage(currentUserId);

                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: base64Image.isNotEmpty
                          ? MemoryImage(base64Decode(base64Image))
                          : AssetImage('assets/default-avatar.png')
                              as ImageProvider,
                    );
                  }),
                ),
                ListTile(
                  leading: const Icon(Icons.home,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Home',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Profile',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Get.to(PatientProfileScreen()); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Logout',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    showSignOutDialog();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('About us',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Get.to(AboutUsScreen()); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.call,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Contact us',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    showContactDialog(context); // Close the drawer
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                      'We are here to take care of you',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Obx(() {
                      String currentUserId =
                          FirebaseAuth.instance.currentUser?.uid ?? "";
                      String base64Image =
                          profileController.getProfileImage(currentUserId);

                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: base64Image.isNotEmpty
                            ? MemoryImage(base64Decode(base64Image))
                            : AssetImage('assets/default-avatar.png')
                                as ImageProvider,
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dashboardData.length,
            itemBuilder: (context, index) {
              final data = dashboardData[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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

  void showSignOutDialog() {
    Get.defaultDialog(
      title: "Confirm Sign Out",
      middleText: "Are you sure you want to sign out?",
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.white,
      buttonColor: Color.fromARGB(255, 37, 100, 228),
      onConfirm: () {
        Get.back(); // Close the dialog
        _ctrl.signOut(); // Call your sign-out function
      },
      onCancel: () {
        Get.back(); // Just close the dialog
      },
    );
  }

//Contact Us dialogbox
  void showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Contact Us"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("For any help, call us at:"),
              const SizedBox(height: 10),
              const Text(
                "+1 234 567 890", // Replace with your actual contact number
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  launchUrl(Uri.parse("tel:+1234567890")); // Dial the number
                },
                icon: const Icon(Icons.call),
                label: const Text("Call Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
