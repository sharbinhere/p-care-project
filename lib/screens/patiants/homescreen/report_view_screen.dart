import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportViewScreen extends StatefulWidget {
  @override
  _ReportViewScreenState createState() => _ReportViewScreenState();
}

class _ReportViewScreenState extends State<ReportViewScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? patientId;

  @override
  void initState() {
    super.initState();
    _getPatientId();
  }

  void _getPatientId() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        patientId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Reports')),
      body: patientId == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loader if patient ID isn't ready
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('Reports')
                  .where('patientId', isEqualTo: patientId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print("🔥 Firestore Error: ${snapshot.error}");
                  return Center(child: Text("${snapshot.error}"));
                }

                // ✅ FIX: Properly check if the snapshot has valid documents
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No reports found."));
                }

                var reports = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    var reportData =
                        reports[index].data() as Map<String, dynamic>;
                    List<dynamic> allReports = reportData['reports'] ?? [];

                    return Card(
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 10,
                      child: Column(
                        children: allReports.map((singleReport) {
                          return ListTile(
                            title: Text(
                              "Caretaker: ${reportData['caretakerName'] ?? 'Unknown'}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Report: ${singleReport['text']}"),
                                Text(
                                  "Date: ${singleReport['timestamp'].toDate()}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Divider(
                                  color: Colors.grey, // Color of the line
                                  thickness: 1, // Line thickness
                                )
                              ],
                            ),
                            leading: Icon(Icons.assignment, color: Colors.blue),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
