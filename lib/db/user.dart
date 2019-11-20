import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices{
  static Firestore _firestore = Firestore.instance;
  static String collection = "users";
  
  

  void createUser(Map data) {
    _firestore.collection(collection).document(data["userId"]).setData(data);
  }
  Future<QuerySnapshot> getDataCollection() {
    return _firestore.collection(collection).getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return _firestore.collection(collection).snapshots();
  }

   static Future<QuerySnapshot> searchUser(String name){
    Future<QuerySnapshot> users = _firestore.collection(collection).where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    Future<DocumentSnapshot> data = _firestore.collection(collection).document(id).get();
    return data;
  }
  
}