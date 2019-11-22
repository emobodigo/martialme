import 'package:cloud_firestore/cloud_firestore.dart';


class Group{
  final String id, userId, username;

  Group({this.id, this.userId, this.username});

  factory Group.fromMap(Map<String, dynamic> data, String id){
    data = data ?? {};
    return Group(
      id: id,
      username: data['name'],
      userId: data['userId']
    );
  }
  toJson() {
    return {
      "name": username,
      "userId" : userId
    };
  }
}

// class Users {
//   final String userId, username;

//   Users({this.userId, this.username});

//   factory Users.fromMap(Map<dynamic, dynamic> data){
//     return Users(
//       userId: data['userId'],
//       username: data['name']
//     );
//   }
// }