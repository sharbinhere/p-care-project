import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:p_care/choose.dart';
//import 'package:p_care/screens/choose.dart';
import 'package:p_care/screens/additionalScreens/onboardScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
//import 'package:p_care/screens/additionalScreens/splash_screen.dart';
//import 'package:p_care/screens/patiants/regScreen_patients.dart';

//import 'WelcomeScreen.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    /*options: FirebaseOptions(
      apiKey: "AIzaSyDeRUs0q0FqdlPOCNFe5d7yx8p2D4O4pT0",
      authDomain: "p-care-firebase.firebaseapp.com",
      projectId: "p-care-firebase",
      storageBucket: "p-care-firebase.firebasestorage.app",
      messagingSenderId: "845887676725",
      appId: "1:845887676725:web:3c16357c68058247e0ec7c",
  )*/
  );
  
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState(){
    super.initState();
    initialization();
  }

  void initialization()async{
    await Future.delayed(Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 37, 100, 228))
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 37, 100, 228),
            width: 2),
          )
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 37, 100, 228),
        ),
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home: OnBoardingScreen(),
      
    );
  }
}