import 'package:flutter/material.dart';
import 'package:p_care/screens/patiants/WelcomeScreen_patiants.dart';

class RadioButon extends StatefulWidget {
  const RadioButon({super.key});

  @override
  State<RadioButon> createState() => _RadioButonState();
}
String selectedValue = 'value';

class _RadioButonState extends State<RadioButon> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text('patient'),
      value: 'Patient',
      groupValue: selectedValue,
      onChanged: (value){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>WelcomeScreen()));
        setState(() {
          
        });
      },
    );
  }
}