import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:martialme/db/db_group.dart';
import 'package:martialme/model/group.dart';
import 'package:martialme/model/user_model.dart';

import '../locator.dart';

class GroupProvider with ChangeNotifier{
  Firestore _firestore = Firestore.instance;
  List<Group> group;
  DatabaseGroup _databaseGroup = locator<DatabaseGroup>();

  Stream<QuerySnapshot> fetchProductAsStream(){
    return _databaseGroup.streamDataCollection(); 
  }

  Future<List<Group>> fetchPlaces() async{
    var hasil = await _databaseGroup.getDataCollection();
    group = hasil.documents.map((doc) => Group.fromMap(doc.data, doc.documentID)).toList();
    return group;
  }

  Future<Group> getGroupById(String id) async {
    var doc = await _databaseGroup.getDocumentById(id);
    return Group.fromMap(doc.data, doc.documentID);
  }

  Future addGroup(Group data) async{
    var result  = await _databaseGroup.addGroup(data.toJson()) ;

    return ;
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