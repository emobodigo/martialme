import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:martialme/db/db_group.dart';
import 'package:martialme/model/group.dart';

import '../locator.dart';

class GroupProvider with ChangeNotifier{
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

  Future<Group> getPlacesById(String id) async {
    var doc = await _databaseGroup.getDocumentById(id);
    return Group.fromMap(doc.data, doc.documentID);
  }
}