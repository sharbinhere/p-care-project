import 'package:cloud_firestore/cloud_firestore.dart';

class CaretakerModel {
  String? id, name, address, email, phone, age, pass, conf_pass, role;
  CaretakerModel({
    this.role,
    this.id,
    this.name,
    this.address,
    this.email,
    this.phone,
    this.age,
    this.pass,
    this.conf_pass,
      // Add role field
  });

  factory CaretakerModel.fromMap(DocumentSnapshot map) {
    return CaretakerModel(
      role: map["role"],
      id: map.id,
      name: map["name"],
      address: map["address"],
      email: map["email"],
      age: map["age"],
      pass: map["pass"],
      conf_pass: map["confirm pass"],
        // Add role field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "role": role, 
      "name": name,
      "address": address,
      "email": email,
      "age": age,
      "pass": pass,
      "confirm pass": conf_pass,
       // Add role field
    };
  }
}
