import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseGroup {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  DatabaseGroup(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Stream<QuerySnapshot> streamDataWhere(String cond){
    
    return ref.where('users', arrayContains: {'userId': cond}).snapshots();
  }

  Future<QuerySnapshot> getGroup(String cond){
    Future<QuerySnapshot> users = ref.where('users.userId', arrayContains: cond).getDocuments();
    return users;
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<DocumentReference> addGroup(Map data){
    return ref.document().collection('usersg').add(data);
  }

  Future<void> removeDocument(String id){
    return ref.document(id).delete();
  }

  Future<void> updateDocument(Map data, String id){
    return ref.document(id).updateData(data);
  }
}
