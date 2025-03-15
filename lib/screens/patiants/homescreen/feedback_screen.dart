import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PatienceFeedbackScreen extends StatefulWidget {
  final String caretakerId;
  final String caretakerName;

  PatienceFeedbackScreen({required this.caretakerId, required this.caretakerName});

  @override
  _PatienceFeedbackScreenState createState() => _PatienceFeedbackScreenState();
}

class _PatienceFeedbackScreenState extends State<PatienceFeedbackScreen> {
  final TextEditingController feedbackController = TextEditingController();
  bool isLoading = false;
  

  @override
  void initState() {
    super.initState();
    _fetchLatestFeedback();
  }

  Future<void> _fetchLatestFeedback() async {
    String? patientId = FirebaseAuth.instance.currentUser?.uid;
    if (patientId == null) return;

    
    try {
      DocumentSnapshot feedbackSnapshot = await FirebaseFirestore.instance
          .collection("Feedback")
          .doc(widget.caretakerId)
          .get();

      if (feedbackSnapshot.exists) {
        List feedbackList = feedbackSnapshot["feedbackList"] ?? [];
        if (feedbackList.isNotEmpty) {
          feedbackController.text = feedbackList.last["content"] ?? "";
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load previous feedback");
    }
  }

  Future<void> submitFeedback() async {
    String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    if (feedbackController.text.isEmpty) {
      Get.snackbar("Error", "Feedback cannot be empty");
      return;
    }

    setState(() => isLoading = true);

    try {
      String? patientId = FirebaseAuth.instance.currentUser?.uid;
      String? patientName = FirebaseAuth.instance.currentUser?.displayName;
      if (patientId == null || patientName == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Patients') // Replace with your collection name
        .doc(patientId) // Use the user's UID as the document ID
        .get();


      await FirebaseFirestore.instance.collection("Feedback").doc(widget.caretakerId).set({
        "caretakerId": widget.caretakerId,
        "caretakerName": widget.caretakerName,
        "feedbackList": FieldValue.arrayUnion([
          {
            "patientId": patientId,
            "patientName": userDoc['name'],
            "content": feedbackController.text,
            "timestamp": formattedTimestamp,
          }
        ])
      }, SetOptions(merge: true));

      Get.snackbar("Success", "Feedback submitted successfully");
      setState(() => isLoading = false);
    } catch (e) {
      Get.snackbar("Error", "Failed to submit feedback $e");
      print("error is $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feedback for ${widget.caretakerName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Feedback:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Write your feedback here...",
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : submitFeedback,
              child: isLoading ? CircularProgressIndicator() : Text("Submit Feedback"),
            ),
          ],
        ),
      ),
    );
  }
}
