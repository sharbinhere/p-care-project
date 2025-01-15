import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/screens/screen_for_onBoardScreen/initialScreen1.dart';
import 'package:p_care/screens/screen_for_onBoardScreen/initialScreen2.dart';
import 'package:p_care/screens/screen_for_onBoardScreen/initialScreen3.dart';
import 'package:p_care/screens/additionalScreens/choose.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _forcontroll = PageController(); //using to keep track which page right now on
  
  int _flag = 0;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            
            onPageChanged: (value) {
              setState(() {
                if(value==2){
                  
                  _flag =2;
                }
                else if(value==1){
                  _flag=1;
                }
                else{
                  
                  _flag=0;
                }
              });
            },
            controller: _forcontroll,
            children: [
              InitialScreen1(),
              InitialScreen2(),
              InitialScreen3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _flag==1||_flag==2?
                GestureDetector(
                  onTap: (){
                    _forcontroll.previousPage(
                      duration: Duration(milliseconds: 550), 
                      curve: Curves.easeOutCubic);
                         },
                  child: Text('Prev'))
                  :GestureDetector(
                  onTap: (){
                    _forcontroll.animateToPage(
                        2,
                        duration: Duration(milliseconds: 550),
                        curve: Curves.easeOutCubic
                        
                      );
                         },
                  child: Text('Skip')),
                SmoothPageIndicator(
                  
                  controller: _forcontroll, 
                  count: 3),
                  _flag==2 ?
                GestureDetector(
                  onTap: (){
                    Get.to(()=>ChooseScreen(),
                    transition: Transition.fade,
                    duration: Duration(milliseconds: 650));
                  },
                  child: Text('Done')) 
                  
                  : GestureDetector(
                  onTap: (){
                    _forcontroll.nextPage(duration: Duration(
                      milliseconds: 1000), 
                      curve: Curves.easeOutCubic);
                  },
                  child: Text('Next'))
              ],
            ))
        ],
      ),
    );
  }
}