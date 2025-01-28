import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:p_care/screens/caretakers/loginScreen_caretake.dart';
import 'package:p_care/screens/caretakers/regScreen_caretaker.dart';

//import 'package:p_care/logicScreen.dart';
//import 'package:p_care/regScreen.dart';
//import 'package:p_care/regScreen_caretaker.dart';

//import 'package:p_care/screens/patiants/logicScreen_patiants.dart';
//import 'package:p_care/screens/regScreen.dart';
//import 'package:p_care/screens/regScreen_caretaker.dart';
//import 'package:p_care/screens/regScreen_patients.dart';


class WelcomeScreenCare extends StatefulWidget {
   WelcomeScreenCare({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenCare> createState() => _WelcomeScreenCareState();
}


class _WelcomeScreenCareState extends State<WelcomeScreenCare> {
  @override
  Widget build(BuildContext context) {
    
   
    //double height = MediaQuery.sizeOf(context).height;
    //double width = MediaQuery.sizeOf(context).width;
    
    return Scaffold(

      resizeToAvoidBottomInset: false,
       body: SingleChildScrollView(
         child: Container(
           height: 820,
           width: double.infinity,
           decoration: const BoxDecoration(
            
             
             
             gradient: LinearGradient(
               colors: [
                 Color.fromARGB(255, 37, 100, 228),
                 Color.fromARGB(255, 77, 129, 231),
                 Color.fromARGB(255, 91, 137, 228),
                 Color.fromARGB(255, 142, 172, 233),
               ]
             )
           ),
           child: Column(
            
             
             children: [
               
               
               
               const Padding(
                 padding: EdgeInsets.only(top: 150),
                 
               ),
               
                
               
                 Text(
                   'GET START',
                 style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                 ),),
              const SizedBox(height: 50,),
              Image.asset('assets/images/nurse1-removebg-preview.png',
              height: 200,
              width: 200,),
               const SizedBox(height: 30,),
               GestureDetector(
                 onTap: (){
                   Get.to(
                        (){
                          return RegscreenCaretaker();
                        },
                        transition: Transition.fade,
                        duration: Duration(milliseconds: 650)
                      );
                       
                 },
                 child: Container(
                   height: 53,
                   width: 320,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(30),
                     border: Border.all(color: Colors.white),
                   ),
                   child: const Center(child: Text('SIGN UP',style: TextStyle(
                       fontSize: 20,
                       fontWeight: FontWeight.bold,
                       color:  Colors.white,
                   ),),),
                 ),
               ),
               SizedBox(height: 30,),
               GestureDetector(
                onTap: () {
                  Get.to(loginScreenCaretaker(),
                  transition: Transition.fade,
                  duration: Duration(milliseconds: 650) );
                },
                child: Container(
                   height: 53,
                   width: 320,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(30),
                     border: Border.all(color: Color.fromARGB(255, 77, 129, 231)),
                   ),
                   child: const Center(child: Text('SIGN IN',style: TextStyle(
                       fontSize: 20,
                       fontWeight: FontWeight.bold,
                       color:  Color.fromARGB(255, 77, 129, 231),
                   ),),),
                 ),
               ),
               const Spacer(),
              const SizedBox(height: 12,),
              Image(image: AssetImage('assets/images/pcare.png'),
               height: 150,
               width: 150,),
               
              ]
           ),
         ),
       ),
      
      );
    
  }
}