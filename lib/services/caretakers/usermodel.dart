import 'package:cloud_firestore/cloud_firestore.dart';

class CaretakerModel {
  String? id,name,address,email,phone,age,pass,conf_pass;
  CaretakerModel({
    this.id,
    this.name,
    this.address,
    this.email,this.phone,
    this.age,
    this.pass,
    this.conf_pass});

    factory CaretakerModel.fromMap(DocumentSnapshot map){
      return CaretakerModel(
        id: map.id,
        name: map["name"],
        address: map["address"],
        email: map["email"],
        age: map["age"],
        pass: map["pass"],
        conf_pass: map["confirm pass"]
      );
    }

    Map<String,dynamic> toMap(){
      return{
        "name" : name,
        "address" : address,
        "email" : email,
        "age" : age,
        "pass" : pass,
        "confirm pass" : conf_pass
      };
    }

}