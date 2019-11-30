import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabasePlaces {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://martialme-e8d73.appspot.com/');
  final String path;
  CollectionReference ref;

  DatabasePlaces(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Future<QuerySnapshot> getDataRinciSubCollection(String groupId, String idCobas){
    return _db.collection('group').document(groupId).collection('rekom')
        .document(idCobas)
        .collection('hasil')
        .getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }
}
