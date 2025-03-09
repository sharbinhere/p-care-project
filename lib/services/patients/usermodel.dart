import 'package:cloud_firestore/cloud_firestore.dart';

class PatiantUsermodel {
  String? role,id,name,address,email,phone,age,diagnosis,pass,conf_pass;
  PatiantUsermodel({
    this.role,
    this.id,
    this.name,
    this.address,
    this.email,this.phone,
    this.age,
    this.diagnosis,
    this.pass,
    this.conf_pass,
    
    });

    factory PatiantUsermodel.fromMap(DocumentSnapshot map){
      return PatiantUsermodel(
        role: map["role"],
        id: map.id,
        name: map["name"],
        address: map["address"],
        email: map["email"],
        age: map["age"],
        diagnosis: map["diagnosis"],
        pass: map["pass"],
        conf_pass: map["confirm pass"],
        phone: map["phone"]
        
      );
    }

    Map<String,dynamic> toMap(){
      return{
        "role" : role,
        "name" : name,
        "address" : address,
        "email" : email,
        "age" : age,
        "diagnosis" : diagnosis,
        "pass" : pass,
        "confirm pass" : conf_pass,
        "phone" : phone
        
      };
    }

}