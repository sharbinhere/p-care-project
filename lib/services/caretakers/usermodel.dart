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
    final data = map.data() as Map<String, dynamic>? ?? {};
    return CaretakerModel(
      role: data["role"] as String?,
      id: map.id,
      name: data["name"] as String?,
      address: data["address"] as String?,
      email: data["email"] as String?,
      age: data["age"] as String?,
      pass: data["pass"] as String?,
      conf_pass: data["confirm pass"] as String?,
      phone: data["phone"] as String?,
      
        // Add role field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      "role": role, 
      "name": name,
      "address": address,
      "email": email,
      "age": age,
      "phone":phone,
      "pass": pass,
      "confirm pass": conf_pass,
       // Add role field
    };
  }
}