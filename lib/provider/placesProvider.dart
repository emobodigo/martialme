import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:martialme/db/db_places.dart';
import 'package:martialme/locator.dart';
import 'package:martialme/model/places.dart';

class PlacesProvider with ChangeNotifier {
  Places _places;
  List<Places> places;
  DatabasePlaces _databasePlaces = locator<DatabasePlaces>();

  Stream<QuerySnapshot> fetchProductAsStream() {
    return _databasePlaces.streamDataCollection();
  }

  Future<List<Places>> fetchPlaces(
      double valueHarga, double valueJarak, double valueWaktu, double lat, double lon) async {
    var hasil = await _databasePlaces.getDataCollection();
    places = hasil.documents
        .map((doc) => Places.fromMap(doc.data, doc.documentID))
        .toList();

    /*   Menghitung Jarak               */
    radians(double degree) {
      var radian = degree * (pi / 180);
      return radian;
    }

    for (int i = 0; i < places.length; i += 1) {
      places[i].jarak = acos(
              cos(radians(90 - double.parse(places[i].latitude))) *
                      cos(radians(90 - lat)) +
                  sin(radians(90 - double.parse(places[i].latitude))) *
                      sin(radians(90 - lat)) *
                      cos(radians(double.parse(places[i].longitude) - lon))) *
          6371;
      //print(places[i].jarak);
    }
    /* ------------------------------ */

    /* ------------NORMALISASI--------------- */
    double jumlahHarga = 0.0, jumlahJarak = 0.0, jumlahWaktu = 0.0;
    double kolomHarga = 0.0, kolomJarak = 0.0, kolomWaktu = 0.0;

    for (int i = 0; i < places.length; i += 1) {
      jumlahHarga += pow(double.parse(places[i].harga), 2);
    }
    kolomHarga = sqrt(jumlahHarga);
    //print(kolomHarga);

    for (int i = 0; i < places.length; i += 1) {
      jumlahWaktu += pow(double.parse(places[i].jumlahWaktuLatihan), 2);
    }
    kolomWaktu = sqrt(jumlahWaktu);
    //print(kolomWaktu);

    for (int i = 0; i < places.length; i += 1) {
      jumlahJarak += pow(places[i].jarak, 2);
    }
    kolomJarak = sqrt(jumlahJarak);
    //print(kolomJarak);
    for (int i = 0; i < places.length; i += 1) {
      places[i].normalisasiHarga = double.parse(places[i].harga) / kolomHarga;
      places[i].normalisasiWaktu =
          double.parse(places[i].jumlahWaktuLatihan) / kolomWaktu;
      places[i].normalisasiJarak = places[i].jarak / kolomJarak;
      //print(places[i].normalisasiHarga);
    }
    /* ---------------------- */

    /*NORMALISASI TERBOBOT*/
    for (int i = 0; i < places.length; i += 1) {
      places[i].normalisasiHarga = places[i].normalisasiHarga * valueHarga;
      places[i].normalisasiJarak = places[i].normalisasiJarak * valueJarak;
      places[i].normalisasiWaktu = places[i].normalisasiWaktu * valueWaktu;
      //print(places[i].normalisasiHarga);
    }
    /*--------------------------*/

    /* ---------A+ DAN A- ----------*/
    double aPlusHarga = 999, aPlusJarak = 999, aPlusWaktu = 0.0;
    double aMinHarga = 0.0, aMinJarak = 0.0, aMinWaktu = 999;
    for (int i = 0; i < places.length; i += 1) {
      if (aPlusHarga > places[i].normalisasiHarga) {
        aPlusHarga = places[i].normalisasiHarga;
      }
      if (aMinHarga < places[i].normalisasiHarga) {
        aMinHarga = places[i].normalisasiHarga;
      }
      if (aPlusJarak > places[i].normalisasiJarak) {
        aPlusJarak = places[i].normalisasiJarak;
      }
      if (aMinJarak < places[i].normalisasiJarak) {
        aMinJarak = places[i].normalisasiJarak;
      }
      if (aPlusWaktu < places[i].normalisasiWaktu) {
        aPlusWaktu = places[i].normalisasiWaktu;
      }
      if (aMinWaktu > places[i].normalisasiWaktu) {
        aMinWaktu = places[i].normalisasiWaktu;
      }
    }
    // print(aPlusHarga);
    // print(aMinHarga);
    // print(aPlusJarak);
    // print(aMinJarak);
    // print(aPlusWaktu);
    // print(aMinWaktu);
    /* -------------------------------*/

    /*-------Si+-------*/
    double siPlus = 0.0, siMin = 0.0;
    for (int i = 0; i < places.length; i += 1) {
      siPlus = pow((places[i].normalisasiHarga - aPlusHarga), 2) +
          pow((places[i].normalisasiJarak - aPlusJarak), 2) +
          pow((places[i].normalisasiWaktu - aPlusWaktu), 2);
      siMin = pow((places[i].normalisasiHarga - aMinHarga), 2) +
          pow((places[i].normalisasiJarak - aMinJarak), 2) +
          pow((places[i].normalisasiWaktu - aMinWaktu), 2);

      places[i].siPlus = sqrt(siPlus);
      places[i].siMin = sqrt(siMin);

      //print(places[i].siMin);
    }
    /*------------------*/

    /* ----------Hasil Topsis------*/
    for (int i = 0; i < places.length; i += 1) {
      double hasil = places[i].siMin / (places[i].siMin + places[i].siPlus);
      places[i].hasilTopsis = hasil;
      //print(places[i].hasilTopsis);
    }

    places.sort((a, b) => (a.hasilTopsis).compareTo(b.hasilTopsis));
    for (int i = 0; i < places.length; i += 1) {
      places[i].hasilBorda = places[i].hasilTopsis * (i + 1);
      //print(places[i].id);
      //print(places[i].hasilBorda);
    }
    print("------------");
    places.sort((a, b) => (b.hasilBorda).compareTo(a.hasilBorda));
    for (int i = 0; i < places.length; i += 1) {
     print(places[i].hasilBorda);
    }
    return places;
  }

  Future<Places> getPlacesById(String id) async {
    var doc = await _databasePlaces.getDocumentById(id);
    return Places.fromMap(doc.data, doc.documentID);
  }
}
