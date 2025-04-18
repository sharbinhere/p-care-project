import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  var profileImages = <String, String>{}.obs; // Map to store images per user

  @override
  void onInit() {
    super.onInit();
    fetchProfileImage(); // Fetch profile image when the controller is initialized
  }

  void fetchProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('CareTakers')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc['profileImage'] != null) {
        profileImages[user.uid] = userDoc['profileImage'];
        update(); // Notify UI about changes
      }
    }
  }

  Future<void> updateProfileImage(String newImage) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('CareTakers')
          .doc(user.uid)
          .update({'profileImage': newImage});

      // ✅ Update locally after Firestore update
      profileImages[user.uid] = newImage;
      update(); // Notify UI about changes
    }
  }

  String getProfileImage(String userId) {
    return profileImages[userId] ?? ''; // Return empty string if not found
  }
}
