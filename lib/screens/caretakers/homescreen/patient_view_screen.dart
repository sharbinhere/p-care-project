import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:p_care/services/patients/patient_list_controller.dart';

class PatientsScreen extends StatelessWidget {
  final PatienceListController patienceListController =
      Get.find<PatienceListController>();

  /// Function to delete a patient and related data
  Future<void> deletePatient(String patientId, String email) async {
    try {
      // Show confirmation dialog
      bool confirmDelete = await Get.dialog(
        AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this patient? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (!confirmDelete) return;

      // Delete patient from Firestore
      await FirebaseFirestore.instance.collection("Patients").doc(patientId).delete();

      // Delete related reports
      QuerySnapshot reports = await FirebaseFirestore.instance
          .collection("Reports")
          .where("patientId", isEqualTo: patientId)
          .get();

      for (var doc in reports.docs) {
        await doc.reference.delete();
      }

      // Delete patient from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete(); // Ensure Firebase rules allow this action
      }

      // Show success message
      Get.snackbar("Success", "Patient deleted successfully", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete patient: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patients List')),
      body: Obx(() {
        if (patienceListController.patients.isEmpty) {
          return Center(child: Text('No patients found'));
        }

        return ListView.builder(
          itemCount: patienceListController.patients.length,
          itemBuilder: (context, index) {
            var patient = patienceListController.patients[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(patient['name'] ?? 'No Name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Age: ${patient['age'] ?? 'N/A'}"),
                    Text("Address: ${patient['address'] ?? 'N/A'}"),
                    Text("Phone: ${patient['phone'] ?? 'N/A'}"),
                    Text("Diagnosis: ${patient['diagnosis'] ?? 'N/A'}"),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    print("Deleting patient: ${patient['id']} with email: ${patient['email']}");
                    deletePatient(patient['id'], patient['email']);
                  }
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
