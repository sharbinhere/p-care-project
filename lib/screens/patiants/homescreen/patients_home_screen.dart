import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/about_screen.dart';
import 'package:p_care/screens/patiants/homescreen/caretaker_list.dart';
import 'package:p_care/screens/patiants/homescreen/caretakers_contact.dart';
import 'package:p_care/screens/patiants/homescreen/draweritems/patient_about_screen.dart';
import 'package:p_care/screens/patiants/homescreen/draweritems/patient_profile_screen.dart';
import 'package:p_care/screens/patiants/homescreen/need_screen.dart';
import 'package:p_care/screens/patiants/homescreen/report_view_screen.dart';
import 'package:p_care/services/patients/auth_controller.dart';
import 'dart:convert';
import 'package:p_care/services/patients/p_profileimage_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientsHomeScreen extends StatefulWidget {
  const PatientsHomeScreen({super.key});

  @override
  _PatientsHomeScreenState createState() => _PatientsHomeScreenState();
}

class _PatientsHomeScreenState extends State<PatientsHomeScreen> {
  final _ctrl = Get.put(PatiantAuthController());
  bool hasNewReport = false;
  final PatienceProfileController profileController = Get.put(PatienceProfileController());
  
  // App theme colors
  final Color primaryColor = Color(0xFF4A6FE3);
  final Color secondaryColor = Color(0xFF2E4DA7);
  final Color backgroundColor = Color(0xFFF5F7FF);
  final Color cardShadowColor = Color(0xFFD1DFFF);
  
  // List of dashboard items with updated colors
  final List dashboardData = const [
    {
      "id": 1,
      "title": "Report View",
      "icon": Icons.description,
      "background_color": Color(0xFF7C4DFF), // Purple
    },
    {
      "id": 2,
      "title": "What you need",
      "icon": Icons.favorite,
      "background_color": Color(0xFFFF5252), // Red
    },
    {
      "id": 3,
      "title": "Give your feedback",
      "icon": Icons.rate_review,
      "background_color": Color(0xFF66BB6A), // Green
    },
    {
      "id": 4,
      "title": "Contact caretakers",
      "icon": Icons.contact_phone,
      "background_color": Color(0xFF29B6F6) // Blue
    }
  ];

  @override
  void initState() {
    super.initState();
    Get.put(PatientProfileScreen());
    Get.put(PatienceProfileController());
    checkForNewReports();
  }

  //check for new report
  void checkForNewReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastSeenReports = prefs.getInt('lastSeenReportsCount') ?? 0;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('Reports')
        .where('patientId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      int currentCount = snapshot.docs.length;

      setState(() {
        // Show red dot if there are new reports
        hasNewReport = currentCount > lastSeenReports;
      });
    });
  }

  // Method to handle tap on dashboard items
  void handleTap(int id, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar(
        "Error", 
        "User not logged in",
        backgroundColor: primaryColor,
        colorText: Colors.white,
        borderRadius: 8,
      );
      return;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(user.uid)
        .get();

    switch (id) {
      case 1:
        // Reset new report count in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        FirebaseFirestore.instance
            .collection('Reports')
            .where('patientId', isEqualTo: user.uid)
            .get()
            .then((snapshot) {
          prefs.setInt('lastSeenReportsCount', snapshot.docs.length);
        });

        setState(() {
          hasNewReport = false;
        });

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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'name': null, 'email': null};

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(user.uid)
        .get();

    return {
      'name': userDoc['name'],
      'email': user.email,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'P-CARE',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
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
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  accountName: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  accountEmail: Text(
                    email,
                    style: TextStyle(fontSize: 14),
                  ),
                  currentAccountPicture: Obx(() {
                    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
                    String base64Image = profileController.getProfileImage(currentUserId);

                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: base64Image.isNotEmpty
                            ? MemoryImage(base64Decode(base64Image))
                            : AssetImage('assets/default-avatar.png') as ImageProvider,
                      ),
                    );
                  }),
                ),
                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.account_circle,
                  title: 'Profile',
                  onTap: () => Get.to(PatientProfileScreen()),
                ),
                _buildDrawerItem(
                  icon: Icons.info,
                  title: 'About us',
                  onTap: () => Get.to(PatientAboutScreen()),
                ),
                _buildDrawerItem(
                  icon: Icons.call,
                  title: 'Contact us',
                  onTap: () => showContactDialog(context),
                ),
                Divider(color: primaryColor.withOpacity(0.3)),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => showSignOutDialog(),
                ),
              ],
            );
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: FutureBuilder<Map<String, String?>>(
                      future: getCurrentUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const _WelcomeText(name: 'there');
                        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                          return const _WelcomeText(name: 'Guest');
                        } else {
                          return _WelcomeText(name: snapshot.data!['name'] ?? 'Guest');
                        }
                      },
                    ),
                  ),
                  Obx(() {
                    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
                    String base64Image = profileController.getProfileImage(currentUserId);

                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: base64Image.isNotEmpty
                            ? MemoryImage(base64Decode(base64Image))
                            : AssetImage('assets/default-avatar.png') as ImageProvider,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "How can we help you today?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dashboardData.length,
            itemBuilder: (context, index) {
              final data = dashboardData[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _buildDashboardCard(data, context),
              );
            },
          ),
        ],
      ),
    );
  }

  // Build dashboard card
  Widget _buildDashboardCard(Map<String, dynamic> data, BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                color: cardShadowColor,
                spreadRadius: 0,
                blurRadius: 6,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                if (data['id'] == 1) {
                  setState(() {
                    hasNewReport = false;
                  });
                }
                handleTap(data['id'], context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: data['background_color'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        data['icon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        data['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (data['id'] == 1 && hasNewReport)
          Positioned(
            right: 0,
            top: -8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: const Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Build drawer item
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFF333333),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void showSignOutDialog() {
    Get.defaultDialog(
      title: "Confirm Sign Out",
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to sign out?",
      contentPadding: EdgeInsets.all(20),
      radius: 10,
      textCancel: "Cancel",
      textConfirm: "Sign Out",
      confirmTextColor: Colors.white,
      cancelTextColor: primaryColor,
      buttonColor: primaryColor,
      onConfirm: () {
        Get.back();
        _ctrl.signOut();
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Contact Us",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "For any help, call us at:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "+1 234 567 890",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    launchUrl(Uri.parse("tel:+1234567890"));
                  },
                  icon: const Icon(Icons.call),
                  label: const Text("Call Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WelcomeText extends StatelessWidget {
  final String name;
  
  const _WelcomeText({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, $name',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'We are here to take care of you',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}