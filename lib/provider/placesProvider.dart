import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:martialme/db/db_places.dart';
import 'package:martialme/locator.dart';
import 'package:martialme/model/places.dart';


class PlacesProvider with ChangeNotifier{
  List<Places> places;
  DatabasePlaces _databasePlaces = locator<DatabasePlaces>();

  Stream<QuerySnapshot> fetchProductAsStream(){
    return _databasePlaces.streamDataCollection(); 
  }

  Future<List<Places>> fetchPlaces() async{
    var hasil = await _databasePlaces.getDataCollection();
    places = hasil.documents.map((doc) => Places.fromMap(doc.data, doc.documentID)).toList();
    return places;
  }

  Future<Places> getPlacesById(String id) async {
    var doc = await _databasePlaces.getDocumentById(id);
    return Places.fromMap(doc.data, doc.documentID);
  }
}