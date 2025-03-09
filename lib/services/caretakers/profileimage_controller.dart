import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  var profileImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileImage(); // Fetch initial profile image
  }

  void fetchProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('CareTakers')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc['profileImage'] != null) {
        profileImage.value = userDoc['profileImage'];
      }
    }
  }

  void updateProfileImage(String newImage) {
    profileImage.value = newImage;
  }
} 