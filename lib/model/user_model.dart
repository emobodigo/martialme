import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String email, name, userId;
  final List<String> group;

  UsersModel({this.email, this.name, this.userId, this.group});

  factory UsersModel.fromDoc(DocumentSnapshot data){
    data = data ?? {};
    var groupfromMap = data['groups'];
    List<String> groupList = groupfromMap.cast<String>();
    return UsersModel(
      email: data['email'],
      name: data['name'],
      userId: data.documentID,
      group: groupList
    );
  }
}