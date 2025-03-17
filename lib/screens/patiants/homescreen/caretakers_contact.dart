import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CareTakersContact extends StatefulWidget {
  @override
  _CareTakersContactState createState() => _CareTakersContactState();
}

class _CareTakersContactState extends State<CareTakersContact> {
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
      appBar: AppBar(title: Text("Contact Caretaker")),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    caretaker['name']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Phone NO: ${caretaker['phone']}"),
                      Text("Address: ${caretaker['address']}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.call, color: Colors.blue),
                        onPressed: () {
                          _dialPhoneNumber(caretaker['phone']!);
                        },
                      ),
                      IconButton(
                        onPressed: (){
                          _openWhatsApp(caretaker['phone']!);
                        }, 
                        icon: FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,))
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
