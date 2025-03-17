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
  bool isEditing = false;
  String? previousFeedback;
  String? previousTimestamp;

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
        for (var feedback in feedbackList.reversed) {
          if (feedback["patientId"] == patientId) {
            setState(() {
              previousFeedback = feedback["content"];
              previousTimestamp = feedback["timestamp"];
              feedbackController.text = previousFeedback ?? ""; // Load previous feedback into text field
            });
            break;
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load previous feedback");
    }
  }

  Future<void> submitFeedback() async {
    if (feedbackController.text.isEmpty) {
      Get.snackbar("Error", "Feedback cannot be empty");
      return;
    }

    setState(() => isLoading = true);

    try {
      String? patientId = FirebaseAuth.instance.currentUser?.uid;
      if (patientId == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .get();

      String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

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

      setState(() {
        previousFeedback = feedbackController.text;
        previousTimestamp = formattedTimestamp;
        isEditing = false;
      });

      Get.snackbar("Success", "Feedback updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit feedback");
    } finally {
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

            // Show Previous Feedback if exists and not editing
            if (!isEditing && previousFeedback != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(previousFeedback!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Text(
                        previousTimestamp ?? "",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

            // Show Text Field only if Editing
            if (isEditing)
              TextField(
                controller: feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Edit your feedback...",
                ),
              ),

            SizedBox(height: 16),

            // Toggle Button
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (isEditing) {
                        submitFeedback();
                      } else {
                        setState(() {
                          isEditing = true;
                          feedbackController.text = previousFeedback ?? ""; // Show previous feedback in the field
                        });
                      }
                    },
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text(isEditing ? "Submit Feedback" : "New Feedback"),
            ),
          ],
        ),
      ),
    );
  }
}
