import 'package:flutter/material.dart';

class InitialScreen3 extends StatelessWidget {
  const InitialScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         color: Color.fromARGB(205, 54, 211, 70),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Text('Focus on What Matters',
            style: TextStyle(
              fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white
            ),),
            SizedBox(
              height: 15,
            ),
            Text('Tools to manage medication, appointments, and well-being,\n               so you can focus on moments that count.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),),
            Image.asset('assets/images/hc-removebg-preview.png',
            height: 350,
            width: 350,)
          ],
        ),
      ),
    );
  }
}