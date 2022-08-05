import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  String? id;
  String? firstName;
  String? secondName;
  String? userName;
  String? email;
  Timestamp? timeCreated;

  UserModal({
    this.id,
    this.firstName,
    this.secondName,
    this.email,
    this.timeCreated,
    this.userName,
  });

  //receive data from server
  factory UserModal.fromDocument(
      // DocumentSnapshot
      doc) {
    return UserModal(
      id: doc['id'],
      firstName: doc['firstName'],
      secondName: doc['secondName'],
      userName: doc['userName'],
      email: doc['email'],
      timeCreated: doc['timeCreated'],
    );
  }

  //recieve data from server
  factory UserModal.fromMap(
      //Map<String, dynamic>
      map) {
    return UserModal(
      id: map['id'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      userName: map['userName'],
      email: map['email'],
      timeCreated: map['timeCreated'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'secondName': secondName,
      'userName': userName,
      'email': email,
      'timeCreated': timeCreated,
    };
  }
}
