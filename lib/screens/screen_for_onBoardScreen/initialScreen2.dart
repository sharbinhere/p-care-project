import 'package:flutter/material.dart';

class InitialScreen2 extends StatelessWidget {
  const InitialScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         color: Color.fromARGB(255, 37, 100, 228),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Text('Connect with Care Teams',
            style: TextStyle(
              fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white
            ),),
            SizedBox(
              height: 15,
            ),
            Text('Collaborate with healthcare professionals,caregivers,\n            and family members—all in one place.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),),
            Image.asset('assets/images/palliative2-removebg-preview.png',
            height: 350,
            width: 350,)
          ],
        ),
      ),
    );
  }
}