import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NeedsMentioningScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const NeedsMentioningScreen({Key? key, required this.patientId, required this.patientName}) : super(key: key);

  @override
  _NeedsMentioningScreenState createState() => _NeedsMentioningScreenState();
}

class _NeedsMentioningScreenState extends State<NeedsMentioningScreen> {
  final CollectionReference needsRef = FirebaseFirestore.instance.collection("Needs");
  final TextEditingController needController = TextEditingController();

  final List<String> predefinedNeeds = ["Diapers", "Tubes", "Ointments", "Gloves", "Bandages"];
  Map<String, int> selectedNeeds = {}; // Stores needs with quantities

  void toggleNeed(String need) {
    setState(() {
      if (selectedNeeds.containsKey(need)) {
        selectedNeeds.remove(need);
      } else {
        selectedNeeds[need] = 1; // Default quantity = 1
      }
    });
  }

  void addCustomNeed() {
    String need = needController.text.trim();
    if (need.isNotEmpty && !selectedNeeds.containsKey(need)) {
      setState(() {
        selectedNeeds[need] = 1; // Default quantity = 1
        needController.clear();
      });
    }
  }

  void increaseQuantity(String need) {
    setState(() {
      selectedNeeds[need] = (selectedNeeds[need] ?? 1) + 1;
    });
  }

  void decreaseQuantity(String need) {
    if (selectedNeeds.containsKey(need) && selectedNeeds[need]! > 1) {
      setState(() {
        selectedNeeds[need] = selectedNeeds[need]! - 1;
      });
    }
  }

  void removeNeed(String need) {
    setState(() {
      selectedNeeds.remove(need);
    });
  }

  void submitNeeds() async {
  if (selectedNeeds.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select at least one need!")),
    );
    return;
  }

  List<Map<String, dynamic>> needsList = selectedNeeds.entries
      .map((e) => {
            "name": e.key,
            "quantity": e.value,
          })
      .toList();

  DocumentReference docRef = needsRef.doc(widget.patientId);

  try {
    DocumentSnapshot doc = await docRef.get();

    DateTime now = DateTime.now(); // ✅ Get the current date and time

    if (doc.exists) {
      await docRef.update({
        "needs": FieldValue.arrayUnion(needsList), // ✅ Append new needs
        "updatedAt": now.toIso8601String(), // ✅ Store current date-time as a string
      });
    } else {
      await docRef.set({
        "patientId": widget.patientId,
        "patientName": widget.patientName,
        "needs": needsList,
        "createdAt": now.toIso8601String(), // ✅ Store current date-time
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Needs submitted successfully!")),
    );

    setState(() {
      selectedNeeds.clear(); // ✅ Clear the selection after submitting
    });

  } catch (e) {
    print("🔥 Error submitting needs: $e"); // ✅ Debug error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")), // ✅ Show error message
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Needs")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Select what you need:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: predefinedNeeds.length,
              itemBuilder: (context, index) {
                String need = predefinedNeeds[index];
                return CheckboxListTile(
                  title: Text(need),
                  value: selectedNeeds.containsKey(need),
                  onChanged: (bool? value) => toggleNeed(need),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: needController,
                    decoration: const InputDecoration(labelText: "Enter custom need"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: addCustomNeed,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedNeeds.length,
              itemBuilder: (context, index) {
                String need = selectedNeeds.keys.elementAt(index);
                return ListTile(
                  title: Text(need),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => decreaseQuantity(need),
                      ),
                      Text("${selectedNeeds[need]}"),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => increaseQuantity(need),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => removeNeed(need),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: submitNeeds,
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
