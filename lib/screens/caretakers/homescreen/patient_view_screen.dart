import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:p_care/services/patients/patient_list_controller.dart';

class PatientsScreen extends StatelessWidget {
  final PatienceListController patienceListController =
      Get.find<PatienceListController>();

  /// Function to delete a patient and related data
  Future<void> deletePatient(String patientId) async {
  try {
    print("Deleting patient with ID: $patientId");

    //  Delete from Patients collection
    await FirebaseFirestore.instance.collection("Patients").doc(patientId).delete();

    //  Delete associated reports
    QuerySnapshot reports = await FirebaseFirestore.instance
        .collection("Reports")
        .where("patientId", isEqualTo: patientId)
        .get();

    for (var doc in reports.docs) {
      await doc.reference.delete();
    }

    // Delete associated Needs
    QuerySnapshot need = await FirebaseFirestore.instance
        .collection("Needs")
        .where("patientId", isEqualTo: patientId)
        .get();

    for (var doc in need.docs) {
      await doc.reference.delete();
    }   

    Get.snackbar("Success", "Patient deleted successfully", backgroundColor: Colors.green, colorText: Colors.white);
  } catch (e) {
    Get.snackbar("Error", "Failed to delete patient: $e", backgroundColor: Colors.red, colorText: Colors.white);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patients List')),
      body:  StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("Patients").snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator()); // Show loading state
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No patients found'));
      }

      return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          var patientDoc = snapshot.data!.docs[index]; // Firestore DocumentSnapshot
          var patientData = patientDoc.data() as Map<String, dynamic>; // Convert to Map
          var patientId = patientDoc.id; // Get Firestore document ID

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(patientData['name'] ?? 'No Name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Age: ${patientData['age'] ?? 'N/A'}"),
                  Text("Address: ${patientData['address'] ?? 'N/A'}"),
                  Text("Phone: ${patientData['phone'] ?? 'N/A'}"),
                  Text("Diagnosis: ${patientData['diagnosis'] ?? 'N/A'}"),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await deletePatient(patientId);
                },
              ),
            ),
          );
        },
      );
    },
  )




    );
  }
}
