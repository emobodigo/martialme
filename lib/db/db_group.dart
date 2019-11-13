import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseGroup {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://martialme-e8d73.appspot.com/');
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

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }
}
