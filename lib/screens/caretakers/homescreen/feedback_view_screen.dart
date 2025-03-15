import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CareTakerFeedbackViewScreen extends StatelessWidget {
  final String caretakerId;

  CareTakerFeedbackViewScreen({required this.caretakerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feedback for You")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Feedback')
            .doc(caretakerId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return Center(child: Text("No feedback received yet"));
          }

          var feedbackList = snapshot.data!.get('feedbackList') as List<dynamic>?;

          if (feedbackList == null || feedbackList.isEmpty) {
            return Center(child: Text("No feedback received yet"));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              var feedbackItem = feedbackList[index];
              String patientName = feedbackItem['patientName'] ?? "Unknown";
              String feedbackContent = feedbackItem['content'] ?? "No feedback";
              String timestamp = feedbackItem['timestamp'] ?? "";
              
              // Format timestamp using intl package
              String formattedDate = timestamp.isNotEmpty
                  ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(timestamp))
                  : "Unknown Date";

              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            patientName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        feedbackContent,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
