
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialme/db/user.dart';
import 'package:martialme/model/user_model.dart';

enum Status{Unitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  List<UsersModel> users;
  Firestore _firestore =Firestore.instance;
  

  Status _status = Status.Unitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  UserServices _services = UserServices();
  UserProvider.initialize() : _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name,String email, String password)async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user){
        Map<String, dynamic> values = {
          "name":name,
          "email":email,
          "userId": _user.uid
        };
        _services.createUser(values);
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  } 

  Future<void> _onStateChanged(FirebaseUser firebaseUser) async {
    if(firebaseUser == null){
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return _firestore.collection('users').document(id).get();
  }

  


  
}