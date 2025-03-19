import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaretakerNeedsScreen extends StatelessWidget {
  const CaretakerNeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patients Needs",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 37, 100, 228),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 37, 100, 228).withOpacity(0.1), Colors.white],
            stops: const [0.0, 0.3],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Needs').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 37, 100, 228),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 70,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No needs mentioned yet",
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

            var needsList = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: needsList.length,
              itemBuilder: (context, index) {
                var needData = needsList[index].data() as Map<String, dynamic>;
                String patientName = needData['patientName'] ?? 'Unknown';
                List<dynamic> items = needData['needs'] ?? [];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      childrenPadding: const EdgeInsets.only(bottom: 12),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 37, 100, 228).withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 37, 100, 228),
                        ),
                      ),
                      title: Text(
                        patientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 37, 100, 228),
                        ),
                      ),
                      subtitle: Text(
                        "${items.length} items needed",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      children: [
                        Divider(
                          thickness: 1,
                          height: 24,
                          indent: 20,
                          endIndent: 20,
                          color: Colors.grey.shade200,
                        ),
                        items.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (context, itemIndex) {
                                  var item = items[itemIndex];
                                  return ListTile(
                                    dense: true,
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "x${item['quantity'] ?? item['count'] ?? 0}", // Adjust key name if needed,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      item['name'] ?? 'Unknown Item',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "No items mentioned",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
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
}