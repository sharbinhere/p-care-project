import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:p_care/example.dart';
import 'package:p_care/materials/radio_button.dart';
import 'package:p_care/services/caretakers/c_auth_controller.dart';

class RegscreenCaretaker extends StatefulWidget {
  const RegscreenCaretaker({Key? key}) : super(key: key);

  @override
  State<RegscreenCaretaker> createState() => _RegscreenCaretakerState();
}

class _RegscreenCaretakerState extends State<RegscreenCaretaker> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  final _formKey = GlobalKey<FormState>();

 
 //object of CareTaker AuthController
  final _ctrl = Get.put(CaretakerAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: 900,
        color: Colors.white,
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
                  'Create Your\nAccount',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _ctrl.fullNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                              label: Text(
                            'Full Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 37, 100, 228),
                            ),
                          )),
                        ),
                        TextFormField(
                          controller: _ctrl.addressController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                              //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                              label: Text(
                            'Address',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 37, 100, 228),
                            ),
                          )),
                        ),
                        TextFormField(
                          controller: _ctrl.emailController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                          minLines: 1,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 37, 100, 228),
                                ),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Restrict input to digits
                          ],
                          controller: _ctrl.phoneController,
                          decoration: InputDecoration(
                              label: Text(
                            'Phone',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 37, 100, 228),
                            ),
                          )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length != 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _ctrl.ageController,
                          decoration: InputDecoration(

                              //suffixIcon: Icon(Icons.visibility,color: Colors.grey,),
                              label: Text(
                            'Age',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 37, 100, 228),
                            ),
                          )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        GenderSelection(),
                        TextFormField(
                          controller: _ctrl.passwordController,
                          obscureText: _obscureText1,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText1 = !_obscureText1;
                                    });
                                  },
                                  icon: _obscureText1
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                              label: Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 37, 100, 228),
                                ),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (value.length < 6) {
                              return 'Password should be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _ctrl.confirmPasswordController,
                          obscureText: _obscureText2,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText2 = !_obscureText2;
                                    });
                                  },
                                  icon: _obscureText2
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                              label: Text(
                                'Confirm Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 37, 100, 228),
                                ),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != _ctrl.confirmPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        //const SizedBox(height: 10,),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 37, 100, 228),
                              Color.fromARGB(255, 77, 129, 231),
                              Color.fromARGB(255, 91, 137, 228),
                              Color.fromARGB(255, 142, 172, 233),
                            ]),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState?.validate() == true) {
                                // Navigate to the next screen if valid
                                _ctrl.signUp();
                              }
                            },
                            child:  Obx(
                              ()=> Center(
                                child:_ctrl.loading.value?CircularProgressIndicator(color: Colors.white,)
                                : Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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