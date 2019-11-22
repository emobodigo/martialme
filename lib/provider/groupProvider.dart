import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:martialme/db/db_group.dart';
import 'package:martialme/db/db_groupuser.dart';
import 'package:martialme/model/group.dart';
import 'package:martialme/model/groupuser.dart';


import '../locator.dart';

class GroupProvider with ChangeNotifier{
  Firestore _firestore = Firestore.instance;
  List<Group> group;
  DatabaseGroup _databaseGroup = locator<DatabaseGroup>();
  DatabaseGroupUser _databaseGroupUser = locator<DatabaseGroupUser>();

  Stream<QuerySnapshot> fetchProductAsStream(){
    return _databaseGroup.streamDataCollection(); 
  }

  Stream<QuerySnapshot> streamWhere(String id){
    return _databaseGroup.streamDataWhere(id);
  }

  Future<List<Group>> fetchPlaces() async{
    var hasil = await _databaseGroup.getDataCollection();
    group = hasil.documents.map((doc) => Group.fromMap(doc.data, doc.documentID)).toList();
    return group;
  }

  Future<List<Group>> fetchGroupUser(String id) async{
    var hasil = await _databaseGroupUser.getDataCollection(id);
    group = hasil.documents.map((doc) => Group.fromMap(doc.data, doc.documentID)).toList();
    return group;
  }

  Future<Group> getGroupById(String id) async {
    var doc = await _databaseGroup.getDocumentById(id);
    return Group.fromMap(doc.data, doc.documentID);
  }

  Future addGrouptoUserGroup(GroupUser data, Group data2, String id) async{
    var batch = _firestore.batch();
    var ids = new DateTime.now().millisecondsSinceEpoch.toString();
    var addUserGroup = _firestore.collection('groupuser').document(id).collection('groups').document(ids);
    var addgroup = _firestore.collection('group').document(ids).collection('usersg').document(id);
    batch.setData(addUserGroup, data.toJson(ids));
    batch.setData(addgroup, data2.toJson());
    await batch.commit();
    return ;
  }

  Future addGroup(Group data) async{
    var result = await _databaseGroup.addGroup(data.toJson());
    return;
  }

  Future<QuerySnapshot> getGroup() async {
     final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    Future<QuerySnapshot> users = _firestore.collection('group').where('users', arrayContains: {'userId': uid}).getDocuments();
    return users;
  }


  Future removeGroup(String id) async{
    await _databaseGroup.removeDocument(id);
    return;
  }

  Future<void> updateGroup(String user, String id, String username) async {
    //DocumentReference userRef = _firestore.collection('users').document(user.userId);
    DocumentReference groupRef = _firestore.collection('group').document(id);
    Map<dynamic, dynamic> mapData = {
      "userId" : user,
      "name" : username
    };
    await groupRef.updateData({"users" : FieldValue.arrayUnion([mapData])});
    return;
  }
}