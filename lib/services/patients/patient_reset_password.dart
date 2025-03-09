import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/screens/patiants/logicScreen_patiants.dart';
import 'package:p_care/services/patients/auth_controller.dart';

class PatiantResetPassword extends StatelessWidget {
  PatiantResetPassword({super.key});
  final _email = TextEditingController();
  final _ctrl = Get.put(PatiantAuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 37, 100, 228),
          Color.fromARGB(255, 77, 129, 231),
          Color.fromARGB(255, 91, 137, 228),
          Color.fromARGB(255, 142, 172, 233),
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "RESET PASSWORD",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Enter your email to sent you a password reset link",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: _email,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(color: Colors.white),
                    )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: GestureDetector(
                onTap: () async{
                 await _ctrl.sendPasswordReset(_email.text);
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A link send to your email to reset password")));
                 Get.to(loginScreenPatient(),
                 transition: Transition.rightToLeft);
                },
                child: Center(
                        child: Text(
                          'Sent Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 37, 100, 228)),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}