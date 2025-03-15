import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'feedback_screen.dart';

class CaretakerListScreen extends StatefulWidget {
  @override
  _CaretakerListScreenState createState() => _CaretakerListScreenState();
}

class _CaretakerListScreenState extends State<CaretakerListScreen> {
  Future<List<Map<String, dynamic>>> fetchCaretakers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('CareTakers').get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'].toString(),
        'age': doc['age'].toString(),
        'address': doc['address'].toString(),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Caretaker")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCaretakers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No caretakers found"));
          }

          List<Map<String, dynamic>> caretakers = snapshot.data!;
          return ListView.builder(
            itemCount: caretakers.length,
            itemBuilder: (context, index) {
              var caretaker = caretakers[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    caretaker['name']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Age: ${caretaker['age']}"),
                      Text("Address: ${caretaker['address']}"),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatienceFeedbackScreen(
                          caretakerId: caretaker['id']!,
                          caretakerName: caretaker['name']!,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
