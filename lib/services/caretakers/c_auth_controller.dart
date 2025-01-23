import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/example.dart';
import 'package:p_care/services/caretakers/usermodel.dart';


class CaretakerAuthController extends GetxController{
   FirebaseAuth auth = FirebaseAuth.instance;
   FirebaseFirestore db = FirebaseFirestore.instance;
   TextEditingController fullNameController = TextEditingController();
   TextEditingController addressController = TextEditingController();
   TextEditingController emailController = TextEditingController();
   TextEditingController phoneController = TextEditingController();
   TextEditingController ageController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
   TextEditingController confirmPasswordController =TextEditingController();
   TextEditingController loginemail = TextEditingController();
   TextEditingController loginpass = TextEditingController();

   final loading = false.obs;

   //Account Creation.
   signUp()async{
    try{
      loading.value=true;
    await auth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    await addUser();
    verifyEmail();
    Get.to(ExampleScreen(),
    transition: Transition.fade,
    duration: Duration(milliseconds: 650));
    loading.value=false;
    }
    catch(e){
      Get.snackbar("Error occured", "$e");
      loading.value=false;
    }

   }

   //Add user details on firebase database
   addUser()async{
     CaretakerModel user = CaretakerModel(
      name: fullNameController.text,
      address: addressController.text,
      email: auth.currentUser?.email,
      phone: phoneController.text,
      age: ageController.text,
      

    );
    await db.collection("CareTakers").doc(auth.currentUser?.uid).collection("Profile").add(user.toMap());
   }
   
   //Signout 
   signOut()async{
    await auth.signOut();
   }

   //Signin
   signIn()async{
    try{
      loading.value=true;
      await auth.signInWithEmailAndPassword(email: loginemail.text.trim(), password: loginpass.text.trim());
      Get.to(ExampleScreen(),
      transition: Transition.fade,
      duration: Duration(milliseconds: 650));
      loading.value=false;
    }
    catch(e){
      Get.snackbar("Error occured", "$e");
      loading.value=false;
    }
   }

   //Email Verification
   verifyEmail()async{
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