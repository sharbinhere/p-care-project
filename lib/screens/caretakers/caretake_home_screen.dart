import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/services/caretakers/c_auth_controller.dart';

class CaretakeHomeScreen extends StatelessWidget {
   CaretakeHomeScreen({super.key});

  final _ctrl = Get.put(CaretakerAuthController());

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
            Text("Logout"),
            IconButton(onPressed: (){
              _ctrl.signOut();
            }, icon: Icon(Icons.logout))
          ],
        ),
      ),
    );
  }
}