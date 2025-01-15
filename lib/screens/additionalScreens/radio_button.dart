import 'package:flutter/material.dart';

class GenderSelection extends StatefulWidget {
  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String _selectedGender = "Male"; // Default gender selection

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Sex',
        style: TextStyle(
          
          fontWeight: FontWeight.bold,
          color:Color.fromARGB(255, 37, 100, 228),
        ),),
        Expanded(
          child: ListTile(
            title: Text("Male",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color:Color.fromARGB(255, 37, 100, 228),
              
            ),),
            leading: Radio<String>(
              activeColor:Color.fromARGB(255, 37, 100, 228) ,
              value: "Male",
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text("Female",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color:Color.fromARGB(255, 37, 100, 228),
            ),),
            leading: Radio<String>(
              activeColor: Color.fromARGB(255, 37, 100, 228),
              value: "Female",
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}


