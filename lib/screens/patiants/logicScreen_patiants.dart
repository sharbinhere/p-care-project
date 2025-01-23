import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/screens/patiants/regScreen_patients.dart';
import 'package:p_care/services/patiants/auth_controller.dart';
import 'package:p_care/services/patiants/patiant_reset_password.dart';
//import 'package:p_care/screens/patiants/regScreen_patients.dart';

class loginScreenPatient extends StatefulWidget {
  const loginScreenPatient({Key? key}) : super(key: key);

  @override
  State<loginScreenPatient> createState() => _loginScreenPatientState();
}

class _loginScreenPatientState extends State<loginScreenPatient> {
  bool _obscure_Text=true;
  final _ctrl = Get.put(PatiantAuthController()); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: 800,
            child: Stack(
                  children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                   Color.fromARGB(255, 37, 100, 228),
                   Color.fromARGB(255, 77, 129, 231),
                   Color.fromARGB(255, 91, 137, 228),
                   Color.fromARGB(255, 142, 172, 233),
                ]),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Hello\nSign in!',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child:  Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       TextField(
                        controller: _ctrl.loginemail,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email,color: Colors.grey,),
                          label: Text('Email',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:Color.fromARGB(255, 37, 100, 228)
                          ),)
                        ),
                      ),
                      TextField(
                        controller: _ctrl.loginpass,
                        obscureText: _obscure_Text,
                        
                        decoration:  InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  _obscure_Text=!_obscure_Text;
                                });
                              }, 
                              icon: _obscure_Text?Icon(Icons.visibility_off):Icon(Icons.visibility),
                              color: Colors.grey,),
                            label: Text('Password',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color.fromARGB(255, 37, 100, 228)
                              
                            ),)
                        ),
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          Get.to(PatiantResetPassword(),
                          transition: Transition.fade,
                          duration: Duration(milliseconds: 650));
                        },
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forgot Password?',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),),
                        ),
                      ),
                      const SizedBox(height: 50,),
                      Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 37, 100, 228),
                              Color.fromARGB(255, 77, 129, 231),
                              Color.fromARGB(255, 91, 137, 228),
                              Color.fromARGB(255, 142, 172, 233),
                            ]
                          ),
                        ),
                        child: Obx(
                          ()=> GestureDetector(
                            onTap: (){
                              _ctrl.signIn();
                            },
                            child: _ctrl.loading.value?CircularProgressIndicator(color: Colors.white,) 
                            : Center(child: Text('SIGN IN',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white
                            ),),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Don't have account?",style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                              ),),
                              TextButton(
                                onPressed: (){
                                  Get.to(RegScreenPatient(),
                                  transition: Transition.fade,
                                  duration: Duration(seconds: 1));
                                }, 
                                child: const Text('Sign Up',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black
                                ),)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
                  ],
                ),
          ),
        ));
  }
}