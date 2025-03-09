import 'package:flutter/material.dart';

class NeedScreen extends StatelessWidget {
  const NeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('What you need',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}