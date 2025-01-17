import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/screens/additionalScreens/onboardScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    @override
   void initState(){
      super.initState();

      Timer(Duration(seconds: 3),
      (){
        Get.to(OnBoardingScreen(),
        );
      } );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logogif.gif",
            height: 300,
            width: 300,)
          ],
        ),
      ),
    );
  }
}