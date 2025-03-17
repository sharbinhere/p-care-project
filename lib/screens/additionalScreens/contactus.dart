import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

void showContactDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Contact Us"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("For any inquiries, call us at:"),
            const SizedBox(height: 10),
            const Text(
              "+1 234 567 890",  // Replace with your actual contact number
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                launchUrl(Uri.parse("tel:+1234567890")); // Dial the number
              },
              icon: const Icon(Icons.call),
              label: const Text("Call Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
