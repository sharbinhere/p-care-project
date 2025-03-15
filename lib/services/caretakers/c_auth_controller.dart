import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/screens/additionalScreens/onboardScreen.dart';
import 'package:p_care/screens/additionalScreens/otpscreen.dart';
import 'package:p_care/screens/caretakers/homescreen/caretake_home_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/draweritems/profile_screen.dart';
import 'package:p_care/screens/caretakers/homescreen/patient_view_for_report.dart';
import 'package:p_care/screens/caretakers/homescreen/patient_view_screen.dart';
import 'package:p_care/services/caretakers/usermodel.dart';

class CaretakerAuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController loginemail = TextEditingController();
  TextEditingController loginpass = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final loading = false.obs;
  RxString verificationId = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  //Account Creation.
  signUp() async {
    try {
      loading.value = true;
      await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      await addUser();
      await verifyEmail();
      Get.put(CareTakerHomeScreen());
      Get.put(CareTakerProfileScreen());
      Get.put(PatientsViewScreen());
      Get.put(PatientsScreen());
    } catch (e) {
      Get.snackbar("Error occured", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 37, 100, 228),
          colorText: Colors.white);
      loading.value = false;
    }
  }

  //Add user details on firebase database
  Future<void> addUser() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No authenticated user');
      return;
    }

    final caretaker = CaretakerModel(
      role: 'caretaker',
      name: fullNameController.text.trim(),
      address: addressController.text.trim(),
      email: user.email,
      phone: phoneController.text.trim(),
      age: ageController.text.trim(),
    );

    await FirebaseFirestore.instance
        .collection('CareTakers')
        .doc(user.uid)
        .set(caretaker.toMap());

    //print('User added successfully');
  } catch (e) {
    //print('Error adding user: $e');
    rethrow;
  }
}

  //Signout
  signOut() async {
    await auth.signOut();
    Get.offAll(()=>OnBoardingScreen());
  }

  //Signin
  signIn() async {
    try {
      loading.value = true;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: loginemail.text.trim(), password: loginpass.text.trim());

          //print("User: ${userCredential.user?.uid}.....................");
      Get.put(CareTakerHomeScreen());
      Get.put(CareTakerProfileScreen());
      Get.offAll(()=>CareTakerHomeScreen(),
          transition: Transition.fade, duration: Duration(milliseconds: 650));
      loading.value = false;
    } catch (e) {
      Get.snackbar("Error occured", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 37, 100, 228),
          colorText: Colors.white);
      loading.value = false;
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
        await Future.delayed(
            const Duration(seconds: 3)); // Wait for a few seconds
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
          Get.to(CareTakerHomeScreen());
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

    // Query the "CareTakers" collection for the email
    final caretakerQuery = await db
        .collection('CareTakers')
        .where('email', isEqualTo: email.trim())
        .get();

    print("CareTakers results: ${caretakerQuery.docs.length}");

    if (caretakerQuery.docs.isNotEmpty) {
      // Email exists, send reset link
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent to $email",
      snackPosition: SnackPosition.BOTTOM);
    } else {
      // Email not found
      Get.snackbar("Error", "This email doesn't exist in our records.",
      snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar("Error Occurred", "$e",
    snackPosition: SnackPosition.BOTTOM);
  }
}

//send otp
Future<void> sendOTP() async {
  try {
    loading.value = true;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-signs in for some numbers
        UserCredential userCredential = await auth.signInWithCredential(credential);
        Get.offAll(() => CareTakerHomeScreen()); // Navigate after auto-login
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("Error", e.message ?? "Failed to verify phone number");
        loading.value = false;
      },
      codeSent: (String verId, int? resendToken) {
        verificationId.value = verId;
        Get.snackbar("OTP Sent", "Enter the OTP sent to your phone");
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    loading.value = false;
  }
}

//verifyotp
Future<void> verifyOTP() async {
  try {
    loading.value = true;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId.value,
      smsCode: otpController.text.trim(),
    );

    UserCredential userCredential = await auth.signInWithCredential(credential);

    // Check if it's a new user (optional, but useful)
    bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    if (isNewUser) {
      await addUser(); // Save user details if it's a new user
    }

    Get.offAll(() => CareTakerHomeScreen()); // Navigate to home screen
  } catch (e) {
    Get.snackbar("Error", "Invalid OTP. Try again.");
  } finally {
    loading.value = false;
  }
}



}
