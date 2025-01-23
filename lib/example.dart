import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isEmailVerified = false;
  Timer? verificationCheckTimer;

  @override
  void initState() {
    super.initState();
    // Get the initial email verification status
    isEmailVerified = auth.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      // Periodically check email verification status
      verificationCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        checkEmailVerification();
      });
    }
  }

  Future<void> checkEmailVerification() async {
    // Reload the user to get the latest data
    await auth.currentUser?.reload();
    setState(() {
      isEmailVerified = auth.currentUser?.emailVerified ?? false;
    });

    // Stop checking if the email is verified
    if (isEmailVerified) {
      verificationCheckTimer?.cancel();
    }
  }

  @override
  void dispose() {
    verificationCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.orange,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isEmailVerified
                  ? const Text(
                      "Email Verified!",
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    )
                  : Text("Verify the ${auth.currentUser?.email} email"),
              const SizedBox(height: 50),
              Text(auth.currentUser?.email ?? "No Email"),
              Text(isEmailVerified ? "Verified" : "Not Verified"),
            ],
          ),
        ),
      ),
    );
  }
}
