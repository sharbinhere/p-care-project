import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PatientReportScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  PatientReportScreen({required this.patientId, required this.patientName});

  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  final TextEditingController reportController = TextEditingController();
  bool isLoading = false;
  String? reportId; // Stores Firestore document ID if a report exists
  bool isEditing = false; // Controls edit mode

  @override
  void initState() {
    super.initState();
    _fetchExistingReport();
  }

  /// Fetch caretaker's existing report for the selected patient
  Future<void> _fetchExistingReport() async {
    String? caretakerId = FirebaseAuth.instance.currentUser?.uid;
    if (caretakerId == null) return;

    try {
      QuerySnapshot reportQuery = await FirebaseFirestore.instance
          .collection("Reports")
          .where("patientId", isEqualTo: widget.patientId)
          .where("caretakerId", isEqualTo: caretakerId)
          .get();

      if (reportQuery.docs.isNotEmpty) {
        var existingReport = reportQuery.docs.first;
        setState(() {
          reportController.text = existingReport["report"];
          reportId = existingReport.id; // Store report ID
          isEditing = false; // Start in read-only mode
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load previous report");
    }
  }

  /// Submit or update the report
  Future<void> submitReport() async {
    if (reportController.text.isEmpty) {
      Get.snackbar("Error", "Report cannot be empty");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String? caretakerId = FirebaseAuth.instance.currentUser?.uid;
      if (caretakerId == null) {
        Get.snackbar("Error", "Caretaker not logged in");
        return;
      }

      DocumentSnapshot caretakerSnapshot = await FirebaseFirestore.instance
          .collection("CareTakers")
          .doc(caretakerId)
          .get();

      String caretakerName = caretakerSnapshot.exists
          ? caretakerSnapshot["name"]
          : "Unknown Caretaker";

      if (reportId != null) {
        // Update existing report
        await FirebaseFirestore.instance
            .collection("Reports")
            .doc(reportId)
            .update({
          "report": reportController.text,
          "timestamp": FieldValue.serverTimestamp(),
        });

        Get.snackbar("Success", "Report updated successfully");
      } else {
        // Create new report
        DocumentReference newReport = await FirebaseFirestore.instance
            .collection("Reports")
            .add({
          "patientId": widget.patientId,
          "patientName": widget.patientName,
          "caretakerId": caretakerId,
          "caretakerName": caretakerName,
          "report": reportController.text,
          "timestamp": FieldValue.serverTimestamp(),
        });

        setState(() {
          reportId = newReport.id; // Store new report ID for future edits
        });

        Get.snackbar("Success", "Report submitted successfully");
      }

      setState(() {
        isEditing = false; // Switch to read-only mode after submission
      });

    } catch (e) {
      Get.snackbar("Error", "Failed to submit report");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report for ${widget.patientName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Report:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            // Show either text field (edit mode) or read-only report
            isEditing || reportId == null
                ? TextField(
                    controller: reportController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Type the patient's condition report here...",
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Text(reportController.text),
                  ),

            SizedBox(height: 16),

            // Show submit or update button
            isEditing || reportId == null
                ? ElevatedButton(
                    onPressed: isLoading ? null : submitReport,
                    child: isLoading ? CircularProgressIndicator() : Text(reportId == null ? "Submit Report" : "Update Report"),
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: Text("Edit Report"),
                  ),
          ],
        ),
      ),
    );
  }
}
