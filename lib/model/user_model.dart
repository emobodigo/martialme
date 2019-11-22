import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String email, name, userId;


  UsersModel({this.email, this.name, this.userId});

  factory UsersModel.fromDoc(DocumentSnapshot data){
    data = data ?? {};
    return UsersModel(
      email: data['email'],
      name: data['name'],
      userId: data.documentID,
    );
  }
}