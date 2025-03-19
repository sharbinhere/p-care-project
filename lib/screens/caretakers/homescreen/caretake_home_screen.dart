import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/about_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/feedback_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/profile_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/feedback_view_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/patiant_needs_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/patient_view_for_report.dart';
import 'package:p_care/screens/caretakers/homescreen/patient_view_screen.dart';
import 'package:p_care/services/caretakers/c_auth_controller.dart';
import 'package:p_care/services/caretakers/profileimage_controller.dart';
import 'patient_report_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CareTakerHomeScreen extends StatefulWidget {
  const CareTakerHomeScreen({super.key});

  @override
  _CareTakerHomeScreenState createState() => _CareTakerHomeScreenState();
}

class _CareTakerHomeScreenState extends State<CareTakerHomeScreen> {
  final _ctrl = Get.put(CaretakerAuthController());
  final ProfileController profileController = Get.put(ProfileController());
  int newNeedsCount = 0;

  // List of dashboard items
  final List dashboardData = const [
    {
      "id": 1,
      "title": "Patients",
      "icon": Icons.person,
      "background_color": Colors.deepOrange,
    },
    {
      "id": 2,
      "title": "Patients Report",
      "icon": Icons.book,
      "background_color": Colors.pink,
    },
    {
      "id": 3,
      "title": "Patients Needs",
      "icon": Icons.chat,
      "background_color": Colors.purple,
    },
    {
      "id": 4,
      "title": "Feedback view",
      "icon": Icons.book,
      "background_color": Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    Get.put(CareTakerProfileScreen());
    _listenForNewNeeds();
  }

  void _listenForNewNeeds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int lastSeenNeeds = prefs.getInt('lastSeenNeedsCount') ?? 0;

  FirebaseFirestore.instance.collection('Needs').snapshots().listen((snapshot) {
    int currentCount = snapshot.docs.length;

    setState(() {
      // Show red dot only if there are new needs beyond the last seen count
      newNeedsCount = (currentCount > lastSeenNeeds) ? currentCount : -1;
    });
  });
}


  // Method to handle tap on dashboard items
  void handleTap(int id, BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  if (id == 3) {
    // Store the current needs count as the last seen count
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastSeenNeedsCount', newNeedsCount);

    // ✅ Hide the red dot after opening "Patients Needs"
    setState(() {
      newNeedsCount = -1;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CaretakerNeedsScreen()),
    );
  } else if (id == 1) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PatientsScreen()));
  } else if (id == 2) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PatientsViewScreen()));
  } else if (id == 4) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => CareTakerFeedbackViewScreen(caretakerId: user.uid),
    ));
  }
}


  // Method to fetch the current user's name and email
  Future<Map<String, String?>> getCurrentUserDetails() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'name': null, 'email': null};

    // Fetch the user's data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('CareTakers') // Replace with your collection name
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
                    Get.to(CareTakerProfileScreen()); // Close the drawer
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
                  leading: const Icon(Icons.notification_add,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('Notification',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Get.to(AboutUsScreen()); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help,
                      color: Color.fromARGB(255, 37, 100, 228)),
                  title: const Text('About us',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 100, 228))),
                  onTap: () {
                    Get.to(AboutUsScreen()); // Close the drawer
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
                      'Manage your patients efficiently',
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
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Stack(
        children: [
          InkWell(
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
          // ✅ Show the red notification badge only for "Patients Needs"
          if (data['id'] == 3 && newNeedsCount > 0)
            Positioned(
              right: 15,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  '$newNeedsCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  },
)
,
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
}
