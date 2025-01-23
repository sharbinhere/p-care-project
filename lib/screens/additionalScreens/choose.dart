//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:p_care/screens/caretakers/WelcomeScreen_caretakers.dart';
//import 'package:p_care/materials/radio_button.dart';

import 'package:p_care/screens/patiants/WelcomeScreen_patiants.dart';

class ChooseScreen extends StatefulWidget {
  const ChooseScreen({super.key});

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height:double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
               Color.fromARGB(255, 37, 100, 228),
               Color.fromARGB(255, 77, 129, 231),
               Color.fromARGB(255, 91, 137, 228),
               Color.fromARGB(255, 142, 172, 233),
            ])
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Text('SELECT ONE',
              
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white
                
              )),
              SizedBox(
                height: 30,
              ),
              Image.asset('assets/images/pall4-removebg-preview.png',
              height: 350,
              width: 350,),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){Get.to(
                      (){
                        return WelcomeScreenCare();
                      },
                      transition: Transition.fade,
                      duration: Duration(milliseconds: 650)
                    );},
                    child: Container(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.white
                      ),
                      child:  Center(child: Text('CareTaker',
                      style: TextStyle(
                        color: Color.fromARGB(255, 77, 129, 231),
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),)),
      
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: (){Get.to(
                      (){
                        return WelcomeScreenPatient();
                      },
                      transition: Transition.fade,
                      duration: Duration(milliseconds: 650),
                      
                    );},
                    child: Container(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.white
                      ),
                      child: Center(child: Text('Patient',
                      style: TextStyle(
                        color: Color.fromARGB(255, 77, 129, 231),
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),)),
                    ),
                  )
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



