import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NeedsMentioningScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const NeedsMentioningScreen(
      {Key? key, required this.patientId, required this.patientName})
      : super(key: key);

  @override
  _NeedsMentioningScreenState createState() => _NeedsMentioningScreenState();
}

class _NeedsMentioningScreenState extends State<NeedsMentioningScreen> {
  final CollectionReference needsRef =
      FirebaseFirestore.instance.collection("Needs");
  final TextEditingController needController = TextEditingController();
  final FocusNode textFieldFocus = FocusNode(); // Track focus state

  bool isTyping = false; // Flag to track typing state

  // Theme colors
  final Color primaryColor = Color.fromARGB(255, 37, 100, 228);
  final Color accentColor = Color.fromARGB(255, 77, 129, 231);
  final Color lightColor = Color.fromARGB(255, 91, 137, 228);
  final Color backgroundColor = Color(0xFFF5F5F5);

  final List<String> predefinedNeeds = [
    "Diapers",
    "Tubes",
    "Masks",
    "Gloves",
    "Bandages"
  ];
  Map<String, int> selectedNeeds = {}; // Stores needs with quantities

  @override
  void initState() {
    super.initState();
    textFieldFocus.addListener(() {
      setState(() {
        isTyping = textFieldFocus.hasFocus; // True when user is typing
      });
    });
     markNeedsAsChecked();
  }

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
      SnackBar(
        content: Text("Please select at least one need!"),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  List<Map<String, dynamic>> needsList = selectedNeeds.entries
      .map((e) => {
            "name": e.key,
            "quantity": e.value,
            "viewedByCaretaker": false // Mark as unchecked initially
          })
      .toList();

  DocumentReference docRef = needsRef.doc(widget.patientId);

  try {
    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      await docRef.update({
        "needs": FieldValue.arrayUnion(needsList),
        "updatedAt": FieldValue.serverTimestamp()
      });
    } else {
      await docRef.set({
        "patientId": widget.patientId,
        "patientName": widget.patientName,
        "needs": needsList,
        "createdAt": FieldValue.serverTimestamp()
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text("Needs submitted successfully!"),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    setState(() {
      selectedNeeds.clear();
    });
  } catch (e) {
    print("🔥 Error submitting needs: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
//update when the caretaker check
void markNeedsAsChecked() async {
  DocumentReference docRef = needsRef.doc(widget.patientId);

  try {
    await docRef.update({
      "needs": FieldValue.arrayRemove([]), // This forces Firestore to update the array
      "viewedByCaretaker": true
    });
  } catch (e) {
    print("🔥 Error marking needs as checked: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          "Medical Supplies Needed",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 700,
          child: Column(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patient: ${widget.patientName}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Select supplies needed:",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  "Common Supplies",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
              Container(
                height: 115,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: predefinedNeeds.length,
                  itemBuilder: (context, index) {
                    String need = predefinedNeeds[index];
                    bool isSelected = selectedNeeds.containsKey(need);
          
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => toggleNeed(need),
                        child: Container(
                          width: 95,
                          decoration: BoxDecoration(
                            color: isSelected ? lightColor : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getIconForNeed(need),
                                color: isSelected ? Colors.white : accentColor,
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                need,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    focusNode: textFieldFocus,
                    controller: needController,
                    decoration: InputDecoration(
                      labelText: "Enter custom need",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle, color: lightColor),
                        onPressed: addCustomNeed,
                      ),
                    ),
                    onSubmitted: (_) => addCustomNeed(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected Items",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    Text(
                      "${selectedNeeds.length} items",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: selectedNeeds.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_basket_outlined,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No items selected yet",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        itemCount: selectedNeeds.length,
                        itemBuilder: (context, index) {
                          String need = selectedNeeds.keys.elementAt(index);
                          return Card(
                            margin:
                                EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: lightColor.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getIconForNeed(need),
                                      color: lightColor,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      need,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          constraints: BoxConstraints.tightFor(
                                              width: 32, height: 32),
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.remove, size: 18),
                                          onPressed: () => decreaseQuantity(need),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            "${selectedNeeds[need]}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          constraints: BoxConstraints.tightFor(
                                              width: 32, height: 32),
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.add, size: 18),
                                          onPressed: () => increaseQuantity(need),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.grey),
                                    onPressed: () => removeNeed(need),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: isTyping ? null : submitNeeds, // Disable when typing
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTyping
                        ? Colors.grey
                        : lightColor, // Change color when disabled
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Submit Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get icons for needs
  IconData _getIconForNeed(String need) {
    switch (need.toLowerCase()) {
      case 'diapers':
        return Icons.baby_changing_station;
      case 'tubes':
        return Icons.medical_services;
      case 'masks':
        return Icons.masks;
      case 'gloves':
        return Icons.back_hand;
      case 'bandages':
        return Icons.healing;
      default:
        return Icons.medical_services;
    }
  }
}
