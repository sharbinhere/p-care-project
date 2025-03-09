import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/screens/additionalScreens/onboardScreen.dart';
import 'package:p_care/screens/patiants/homescreen/patients_home_screen.dart';
import 'package:p_care/services/patients/usermodel.dart';

class PatiantAuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController loginemail = TextEditingController();
  TextEditingController loginpass = TextEditingController();

  final loading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;

  // Account creation with OTP verification
  signUp()async{
    try{
      loading.value=true;
    await auth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    await addUser();
    verifyEmail();
    
    }
    catch(e){
      Get.snackbar("Error occured", "$e",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color.fromARGB(255, 37, 100, 228),
      colorText: Colors.white);
      loading.value=false;
    }

   }

   //Add user details on firebase database
   Future<void> addUser() async {
  try {
    // Create a patient model
    PatiantUsermodel user = PatiantUsermodel(
      role: 'patient',
      name: fullNameController.text,
      address: addressController.text,
      email: auth.currentUser?.email, // Use the authenticated user's email
      phone: phoneController.text,
      age: ageController.text,
      diagnosis: diagnosisController.text,
    );

    // Add the patient to the "Patiants" collection
    await db
        .collection("Patients")
        .doc(auth.currentUser?.uid) // Use UID as the document ID
        .set(user.toMap()); // Store all patient data in a single document

    print("Patient added successfully!");
  } catch (e) {
    print("Error adding patient: $e");
  }
}
   
   //Signout 
   signOut() async {
    await auth.signOut();
    Get.offAll(()=>OnBoardingScreen());
  }


   //Signin
   signIn()async{
    try{
      loading.value=true;
      await auth.signInWithEmailAndPassword(email: loginemail.text.trim(), password: loginpass.text.trim());
      Get.offAll(()=>PatientsHomeScreen(),
      transition: Transition.fade,
      duration: Duration(milliseconds: 650));
      loading.value=false;
    }
    catch(e){
      
      Get.snackbar("Error occured", "$e",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color.fromARGB(255, 37, 100, 228),
      colorText: Colors.white);
      loading.value=false;
    }
   }

   //Email Verification
   verifyEmail() async {
  try {
    // Send verification email
    await auth.currentUser?.sendEmailVerification();

    Get.snackbar(
      "Verification",
      "A verification email has been sent to ${auth.currentUser?.email}. Please verify your email to continue.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color.fromARGB(255, 37, 100, 228),
      colorText: Colors.white,
    );

    // Polling to check for verification status
    bool isEmailVerified = false;

    while (!isEmailVerified) {
      await Future.delayed(const Duration(seconds: 3)); // Wait for a few seconds
      await auth.currentUser?.reload(); // Reload the user's data
      isEmailVerified = auth.currentUser?.emailVerified ?? false;

      if (isEmailVerified) {
        Get.snackbar(
          "Email Verified",
          "Your email has been successfully verified!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 37, 100, 228),
          colorText: Colors.white,
        );

        // Redirect the user to their respective homepage based on their role
        Get.offAll(()=>PatientsHomeScreen());
        break;
      }
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "An error occurred while verifying the email: $e",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


    //Password Reset
  Future<void> sendPasswordReset(String email) async {
  try {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email.");
      return;
    }

    print("Searching for email: $email in Firestore...");

    // Query the "Patiants" collection for the email
    final patientQuery = await db
        .collection('Patients')
        .where('email', isEqualTo: email.trim())
        .get();

    print("Patiants results: ${patientQuery.docs.length}");

    if (patientQuery.docs.isNotEmpty) {
      // Email exists, send reset link
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent to $email",snackPosition: SnackPosition.BOTTOM);
    } else {
      // Email not found
      Get.snackbar("Error", "This email doesn't exist in our records.",snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar("Error Occurred", "$e",snackPosition: SnackPosition.BOTTOM);
  }
}
}