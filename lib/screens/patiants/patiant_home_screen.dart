import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_care/services/patiants/auth_controller.dart';

class PatiantHomeScreen extends StatelessWidget {
 PatiantHomeScreen({super.key});

  final _ctrl = Get.put(PatiantAuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Text("Log out"),
            IconButton(onPressed: (){
              _ctrl.signOut();
            }, 
            icon: Icon(Icons.logout) )
          ],
        ),
      ),
    );
  }
}