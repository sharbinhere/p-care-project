import 'package:flutter/material.dart';

class loginScreenCareTaker extends StatelessWidget {
  const loginScreenCareTaker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
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
                  const TextField(
                    
                    decoration: InputDecoration(
                      //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                      label: Text('Caretaker ID',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:Color.fromARGB(255, 37, 100, 228)
                      ),)
                    ),
                  ),
                  
                  const SizedBox(height: 20,),
                  
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
                    child: const Center(child: Text('SIGN IN',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),),),
                  ),
                  const SizedBox(height: 30,),
                  
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}