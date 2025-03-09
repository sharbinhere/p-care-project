import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Set AppBar height
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),  // Curve on the bottom left
            bottomRight: Radius.circular(40), // Curve on the bottom right
          ),
          child: AppBar(
            title: Padding(
              padding: EdgeInsets.only(
                top: 30
              ),
              child: Text(
                "ABOUT US",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 37, 100, 228),
            elevation: 0, // Removes shadow for a cleaner look
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Welcome to P-CARE",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "P-CARE is dedicated to providing seamless and efficient "
              "care services for patients and caretakers. Our goal is to "
              "connect individuals in need of assistance with qualified "
              "caregivers through a secure and user-friendly platform.",
              style: TextStyle(fontSize: 18, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text(
              "Thank you for choosing P-CARE. We are here to support you every step of the way.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Adds spacing before the logo
            Image.asset(
              'assets/images/pcare.png',
              width: 220, // Set width of the logo
              height: 220, // Set height of the logo
              fit: BoxFit.contain, // Ensures the image scales properly
            ),
          ],
        ),
      ),
    );
  }
}
