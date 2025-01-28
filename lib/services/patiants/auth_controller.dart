import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/screens/additionalScreens/onboardScreen.dart';
import 'package:p_care/screens/patiants/patiant_home_screen.dart';
import 'package:p_care/services/patiants/usermodel.dart';

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
   addUser()async{
     PatiantUsermodel user = PatiantUsermodel(
      role: 'patiant',
      name: fullNameController.text,
      address: addressController.text,
      email: auth.currentUser?.email,
      phone: phoneController.text,
      age: ageController.text,
      diagnosis: diagnosisController.text,
      
      

    );
    await db.collection("Patiants").doc(auth.currentUser?.uid).collection("Profile").add(user.toMap());

    await db.collection('CareTakers').doc(auth.currentUser?.uid).set({
    'role': 'patiant', // Change this dynamically if needed
  });
   }
   
   //Signout 
   signOut()async{
    await auth.signOut();
    Get.to(OnBoardingScreen());
    
   }

   //Signin
   signIn()async{
    try{
      loading.value=true;
      await auth.signInWithEmailAndPassword(email: loginemail.text.trim(), password: loginpass.text.trim());
      Get.to(PatiantHomeScreen(),
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
        Get.to(PatiantHomeScreen());
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
    // Query Firestore to check if the email exists
    var userQuery = await FirebaseFirestore.instance
        .collection('Patiants') // Replace with your collection name
        .where('email', isEqualTo: email)
        .get();

    if (userQuery.docs.isNotEmpty) {
      // Email exists, send password reset email
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent to $email",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color.fromARGB(255, 37, 100, 228),
      colorText: Colors.white);
    } else {
      // Email does not exist in Firestore
      Get.snackbar("Error", "Email does not exist in our records.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color.fromARGB(255, 37, 100, 228),
      colorText: Colors.white);
    }
  } catch (e) {
    // Handle other errors
    Get.snackbar("Error Occurred", "$e",
    snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color.fromARGB(255, 37, 100, 228),
      colorText: Colors.white);
  }
}
}
