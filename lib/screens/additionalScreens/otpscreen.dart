import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/services/caretakers/c_auth_controller.dart';


class OTPVerificationScreen extends StatelessWidget {
  final CaretakerAuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: authController.otpController,
              decoration: InputDecoration(labelText: "Enter OTP"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: authController.verifyOTP,
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
