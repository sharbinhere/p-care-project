import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/example.dart';
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
  Future<void> signUp() async {
    try {
      if (phoneController.text.isEmpty || phoneController.text.length != 10) {
        Get.snackbar("Error", "Please enter a valid 10-digit phone number");
        return;
      }

      loading.value = true;

      // Trigger OTP verification
      await auth.verifyPhoneNumber(
        phoneNumber: '+91${phoneController.text}', // Update country code as needed
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification for some devices
          await auth.signInWithCredential(credential);
          Get.snackbar("Phone Verified", "Your phone number has been verified!");
          await _completeSignUp();
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Verification Failed", e.message ?? "An error occurred");
          loading.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          Get.snackbar("OTP Sent", "Please check your phone for the OTP");
          loading.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      loading.value = false;
    }
  }

  // Verify the entered OTP
  Future<void> verifyOtp(String otp) async {
    try {
      loading.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );

      // Verify OTP and sign in
      await auth.signInWithCredential(credential);
      Get.snackbar("Phone Verified", "Your phone number has been verified!");

      // Complete the sign-up process
      await _completeSignUp();
    } catch (e) {
      Get.snackbar("Invalid OTP", "The OTP entered is incorrect. Please try again.");
    } finally {
      loading.value = false;
    }
  }

  // Complete the sign-up process after OTP verification
  Future<void> _completeSignUp() async {
    try {
      // Create user with email and password
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save user details in Firestore
      await addUser();

      // Send email verification
      await verifyEmail();

      // Navigate to the next screen
      Get.to(
        ExampleScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 650),
      );
    } catch (e) {
      Get.snackbar("Error", "Sign-up failed: $e");
    }
  }

  // Add user details to Firestore
  Future<void> addUser() async {
    PatiantUsermodel user = PatiantUsermodel(
      name: fullNameController.text,
      address: addressController.text,
      email: auth.currentUser?.email,
      phone: phoneController.text,
      age: ageController.text,
      diagnosis: diagnosisController.text,
    );
    await db
        .collection("Patiants")
        .doc(auth.currentUser?.uid)
        .collection("Profile")
        .add(user.toMap());
  }

  // Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  // Sign in
  Future<void> signIn() async {
    try {
      loading.value = true;
      await auth.signInWithEmailAndPassword(
        email: loginemail.text.trim(),
        password: loginpass.text.trim(),
      );
      Get.to(
        ExampleScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 650),
      );
    } catch (e) {
      Get.snackbar("Error occurred", "$e");
    } finally {
      loading.value = false;
    }
  }

  // Email verification
  Future<void> verifyEmail() async {
    await auth.currentUser?.sendEmailVerification();
  }

  //Password Reset
  Future<void> sendPasswordReset(String email)async{
    try{
      await auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      Get.snackbar("Error Occured", "$e");
    }
  }
}
