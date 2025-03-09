import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PatienceListController extends GetxController {
  var patients = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  void fetchPatients() async {
    FirebaseFirestore.instance.collection('Patients').get().then((snapshot) {
      patients.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['patientId'] = doc.id; // Store patientId separately
        return data;
      }).toList();
    });
  }
}
