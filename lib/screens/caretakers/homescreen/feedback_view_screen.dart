import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CareTakerFeedbackViewScreen extends StatelessWidget {
  final String caretakerId;
  
  CareTakerFeedbackViewScreen({required this.caretakerId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Feedback",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 37, 100, 228),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 3, 173, 230).withOpacity(0.1), Colors.white],
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Feedback')
              .doc(caretakerId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.teal));
            }
            
            if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
              return _buildEmptyState();
            }
            
            var feedbackList = snapshot.data!.get('feedbackList') as List<dynamic>?;
            
            if (feedbackList == null || feedbackList.isEmpty) {
              return _buildEmptyState();
            }
            
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                var feedbackItem = feedbackList[index];
                String patientName = feedbackItem['patientName'] ?? "Anonymous";
                String feedbackContent = feedbackItem['content'] ?? "No feedback provided";
                String timestamp = feedbackItem['timestamp'] ?? "";
                
                String formattedDate = timestamp.isNotEmpty
                    ? DateFormat('MMM d, yyyy • h:mm a').format(DateTime.parse(timestamp))
                    : "Date unavailable";
                
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Color.fromARGB(255, 37, 100, 228), width: 4)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  patientName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 37, 100, 228),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 0.5),
                          Text(
                            feedbackContent,
                            style: TextStyle(
                              fontSize: 15, 
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
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
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.feedback_outlined,
            size: 70,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            "No feedback received yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Check back later for patient feedback",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}