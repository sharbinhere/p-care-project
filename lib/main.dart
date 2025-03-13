import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:p_care/screens/additionalScreens/onboardScreen.dart';
import 'package:p_care/screens/caretakers/homescreen/caretake_home_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/profile_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/patient_view_for_report.dart';
import 'package:p_care/screens/caretakers/homescreen/patient_view_screen.dart';
import 'package:p_care/screens/patiants/homescreen/draweritems/patient_profile_screen.dart';
import 'package:p_care/screens/patiants/homescreen/patients_home_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:p_care/services/caretakers/profileimage_controller.dart';
import 'package:p_care/services/patients/patient_list_controller.dart';
//import 'package:p_care/services/patients/p_profileimage_controller.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(CareTakerHomeScreen());
  Get.put(PatientsHomeScreen());
  Get.put(PatienceListController());
  Get.put(CareTakerProfileScreen());
  Get.put(PatientProfileScreen());
  Get.put(PatientsScreen());
  Get.put(PatientsViewScreen());
  
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Widget> _initialScreen;

  @override
  void initState() {
    super.initState();
    initialization();
    _initialScreen = _getInitialScreen();
  }

  // Determines the initial screen based on user authentication and role
  Future<Widget> _getInitialScreen() async {
    // Simulate a delay (optional)
    await Future.delayed(const Duration(seconds: 1));

    // Check if the user is signed in
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return OnBoardingScreen(); // User not signed in
    }

    // Debugging: Log current user UID
    //print("User UID: ${user.uid}");

    // Fetch user document from both the 'Patiants' and 'CareTakers' collections
    final patientDoc = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(user.uid)
        .get();

    final caretakerDoc = await FirebaseFirestore.instance
        .collection('CareTakers')
        .doc(user.uid)
        .get();

    // Debugging: Log existence of patient and caretaker documents
    /// print("Is Patient: ${patientDoc.exists}");
    ///print("Is Caretaker: ${caretakerDoc.exists}");

    // Check if the user is found in 'Patiants'
    if (patientDoc.exists) {
      print("User is a Patient");
      return PatientsHomeScreen(); // User is a patient
    }

    // If the user is not found in 'Patiants', check in 'CareTakers'
    if (caretakerDoc.exists) {
      //print("User is a Caretaker");
      return CareTakerHomeScreen(); // User is a caretaker
    }

    // If no matching document is found in either collection
    // print("No matching document found in Patiants or CareTakers");
    return OnBoardingScreen();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 37, 100, 228)))),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 37, 100, 228),
        ),
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        future: _initialScreen, // Use the future from initState
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.waveDots(
                  color: Color.fromARGB(255, 37, 100, 228),
                  size: 80,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      "Error: ${snapshot.error.toString()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          return snapshot.data ?? const OnBoardingScreen();
        },
      ),
    );
  }
}
