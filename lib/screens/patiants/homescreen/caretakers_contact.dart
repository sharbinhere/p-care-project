import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CareTakersContact extends StatefulWidget {
  @override
  _CareTakersContactState createState() => _CareTakersContactState();
}

class _CareTakersContactState extends State<CareTakersContact> {
  // Color theme
  final Color primaryColor = Color.fromARGB(255, 37, 100, 228);
  final Color accentColor = Color.fromARGB(255, 77, 129, 231);
  final Color backgroundColor = Color(0xFFF9F9F9);
  final Color cardColor = Color.fromARGB(255, 91, 137, 228);
  final Color textColor = Color(0xFF232F34);
  
  Future<List<Map<String, dynamic>>> fetchCaretakers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('CareTakers').get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'].toString(),
        'phone': doc['phone'].toString(),
        'address': doc['address'].toString(),
      };
    }).toList();
  }

  // Function to dial phone number
  void _dialPhoneNumber(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch dialer")),
      );
    }
  }

  // Function to open WhatsApp chat
  void _openWhatsApp(String phoneNumber) async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/91$phoneNumber");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open WhatsApp")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Contact Caretaker",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCaretakers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No caretakers found",
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            );
          }

          List<Map<String, dynamic>> caretakers = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: caretakers.length,
            itemBuilder: (context, index) {
              var caretaker = caretakers[index];
              return Card(
                margin: EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                color: cardColor,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caretaker['name']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Text(
                            caretaker['phone']!,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              caretaker['address']!,
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Call button
                          ElevatedButton.icon(
                            onPressed: () {
                              _dialPhoneNumber(caretaker['phone']!);
                            },
                            icon: Icon(Icons.call, size: 18),
                            label: Text("Call"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // WhatsApp button
                          ElevatedButton.icon(
                            onPressed: () {
                              _openWhatsApp(caretaker['phone']!);
                            },
                            icon: FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                            label: Text("WhatsApp"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF25D366), // WhatsApp green
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
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