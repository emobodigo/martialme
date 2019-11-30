
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupUser {
  final String id, groupId, namagroup;
  final double hasil;

  GroupUser({this.id, this.groupId, this.namagroup, this.hasil});

  factory GroupUser.fromMap(Map<String, dynamic> data, String id){
    data = data ?? {};
    return GroupUser(
      id: id,
      groupId: data['groupId'],
      namagroup: data['nama_group'],
      hasil: data['borda']
    );
  }

  factory GroupUser.fromJson(DocumentSnapshot snapshot){
    snapshot = snapshot ?? {};
    return GroupUser(
      hasil: snapshot['borda']
    );
  }

  toJson(String id) {
    return {
      "nama_group": namagroup,
      "groupId" : id
    };
  }

}