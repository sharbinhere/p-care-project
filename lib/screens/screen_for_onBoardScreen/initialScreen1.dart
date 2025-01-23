import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialScreen1 extends StatelessWidget {
  const InitialScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Text('Welcome to P-CARE',
            style: GoogleFonts.buenard(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 37, 100, 228)
            )),
            SizedBox(
              height: 17,
            ),
            Text('Providing comfort, care, and support for every step of the journey.\n         An application for palliative patients.We are with you',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.black
            ),),
              //Image(image: AssetImage('assets/images/pcare.png')),
            Image.asset('assets/images/pcare.png',
            height: 200,
            width: 200,),
            Text('Personalized Care for Your Needs',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Colors.black
            ),)
          ],
        ),
      ),
    );
  }
}