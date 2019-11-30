import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
final groupUserRef = _firestore.collection('groupuser');
final groupRef = _firestore.collection('group');
final placesRef = _firestore.collection('places');