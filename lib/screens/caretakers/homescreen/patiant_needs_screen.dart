import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaretakerNeedsScreen extends StatelessWidget {
  const CaretakerNeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patients Needs",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: const Color.fromARGB(255, 37, 100, 228),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Needs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No needs mentioned yet."));
          }

          var needsList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: needsList.length,
            itemBuilder: (context, index) {
              var needData = needsList[index].data() as Map<String, dynamic>;

              String patientName = needData['patientName'] ?? 'Unknown';
              List<dynamic> items = needData['needs'] ?? [];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  minTileHeight: 80,
                  title: Text(
                    patientName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: items.isNotEmpty
                      ? items.map((item) {
                          return ListTile(
                            title: Text(item['name'] ?? 'Unknown Item'),
                            trailing: Text("x${item['items.no'] ?? 0}"),
                          );
                        }).toList()
                      : [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("No items mentioned"),
                          )
                        ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
