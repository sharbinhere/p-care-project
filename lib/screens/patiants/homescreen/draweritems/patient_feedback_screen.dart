import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientFeedbackScreen extends StatefulWidget {
  @override
  _PatientFeedbackScreenState createState() => _PatientFeedbackScreenState();
}

class _PatientFeedbackScreenState extends State<PatientFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _submitted = false;

  void _submitFeedback() {
    if (_feedbackController.text.isNotEmpty) {
      setState(() {
        _submitted = true;
      });

      // Show a snackbar message
      Get.snackbar(
        "Thank You!", 
        "Your feedback has been submitted.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      // Optionally, send the feedback to a database (Supabase, Firebase, etc.)
    }
  }

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
                "FEEDBACK",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Give Your Feedback",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We value your feedback! Please share your thoughts about P-CARE below.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            
            // Feedback Text Field
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write your feedback here...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Color.fromARGB(255, 37, 100, 228),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            // Show "Thank You" message after submitting
            if (_submitted) ...[
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 40),
                    SizedBox(height: 8),
                    Text(
                      "Thank you for your feedback!",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
