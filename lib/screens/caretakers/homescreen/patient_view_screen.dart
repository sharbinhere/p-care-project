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
      appBar: AppBar(
        title: Text(
          'Patients List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100.withOpacity(0.3), Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Patients").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue.shade700,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_off_outlined,
                      size: 70,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No patients found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var patientDoc = snapshot.data!.docs[index];
                var patientData = patientDoc.data() as Map<String, dynamic>;
                var patientId = patientDoc.id;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patientData['name'] ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                  Text(
                                    "Age: ${patientData['age'] ?? 'N/A'}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade400,
                                size: 26,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Confirm Deletion"),
                                    content: Text("Are you sure you want to delete this patient? This action cannot be undone."),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () => Navigator.of(ctx).pop(),
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(ctx).pop();
                                          await deletePatient(patientId);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Divider(height: 24),
                        _buildInfoItem(
                          Icons.home_outlined,
                          "Address",
                          patientData['address'] ?? 'N/A',
                        ),
                        _buildInfoItem(
                          Icons.phone_outlined,
                          "Phone",
                          patientData['phone'] ?? 'N/A',
                        ),
                        _buildInfoItem(
                          Icons.medical_information_outlined,
                          "Diagnosis",
                          patientData['diagnosis'] ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.blue.shade300,
          ),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}