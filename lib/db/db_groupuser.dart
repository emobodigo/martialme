import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseGroupUser{
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  DatabaseGroupUser(this.path){
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection(String id) {
    return ref.document(id).collection('groups').getDocuments();
  }

  Future<DocumentReference> addGroup(Map data, String id){
    
    return ref.document(id).collection('groups').document().setData(data);
  }
}