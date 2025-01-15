//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
//import 'package:google_fonts/google_fonts.dart';

//import 'package:p_care/logicScreen.dart';
//import 'package:p_care/regScreen.dart';
//import 'package:p_care/regScreen_caretaker.dart';

//import 'package:p_care/screens/regScreen.dart';
//import 'package:p_care/screens/regScreen_caretaker.dart';
import 'package:p_care/screens/patiants/regScreen_patients.dart';
import 'package:p_care/screens/patiants/logicScreen_patiants.dart';


class WelcomeScreenPatient extends StatefulWidget {
   WelcomeScreenPatient({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenPatient> createState() => _WelcomeScreenPatientState();
}


class _WelcomeScreenPatientState extends State<WelcomeScreenPatient> {
  @override
  Widget build(BuildContext context) {
    
   
    //double height = MediaQuery.sizeOf(context).height;
    //double width = MediaQuery.sizeOf(context).width;
    
    return Scaffold(

      resizeToAvoidBottomInset: false,
       body: Container(
         height: double.infinity,
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
               )),
            const SizedBox(height: 50,),
            Image.asset('assets/images/patiant.png',
            height: 200,
            width: 200,),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (){
                Get.to(
                      (){
                        return RegScreenPatient();
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
                    color: Colors.white,
                ),),),
              ),
            ),
             const SizedBox(height: 30,),
             GestureDetector(
               onTap: (){
                 Get.to(
                      (){
                        return loginScreenPatient();
                      },
                      transition: Transition.fade,
                      duration: Duration(milliseconds: 650)
                    );
                     
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
      
      );
    
  }
}

//TEXT ANIMATION
/* Widget textAnimation(){
  return SizedBox(
    width: 250,
    child: DefaultTextStyle(style: GoogleFonts.birthstone(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold
    ), child: AnimatedTextKit(
      repeatForever: true,
      animatedTexts: [
        FadeAnimatedText('comfort'),
        FadeAnimatedText('compassion'),
        FadeAnimatedText('hope')
      ])),
  );
} */