import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:martialme/db/db_places.dart';
import 'package:martialme/locator.dart';
import 'package:martialme/model/groupuser.dart';
import 'package:martialme/model/places.dart';
import 'package:martialme/model/rekomendasi.dart';
import 'package:martialme/utils/constant.dart';

class PlacesProvider with ChangeNotifier {
  List<Places> places;
  List<Rekomendasi> rekomendasi;
  GroupUser groupUsers;
  DatabasePlaces _databasePlaces = locator<DatabasePlaces>();

  String listId;
  Stream<QuerySnapshot> fetchProductAsStream() {
    return _databasePlaces.streamDataCollection();
  }

  Future<List<Places>> fetchPlaces(
    double valueHarga,
    double valueJarak,
    double valueWaktu,
    double lat,
    double lon,
    String selectedGroup,
  ) async {
    String idCob = selectedGroup;
    String idCobas = idCob.substring(2, 12);

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
    double jumlahHarga = 0.0, jumlahJarak = 0.0, jumlahWaktu = 0.0;
    double kolomHarga = 0.0, kolomJarak = 0.0, kolomWaktu = 0.0;
    double pembagiBobot = valueHarga+valueJarak+valueWaktu;
    double bobotHargaNormalisasi = valueHarga/pembagiBobot;
    double bobotJarakNormalisasi = valueJarak/pembagiBobot;
    double bobotWaktuNormalisasi = valueWaktu/pembagiBobot;
   /* NORMALISASI */
      for (int i = 0; i < places.length; i += 1) {
        jumlahHarga += pow(double.parse(places[i].harga), 2);
      }
      kolomHarga = sqrt(jumlahHarga);

      for (int i = 0; i < places.length; i += 1) {
        jumlahWaktu += pow(double.parse(places[i].jumlahWaktuLatihan), 2);
      }
      kolomWaktu = sqrt(jumlahWaktu);

      for (int i = 0; i < places.length; i += 1) {
        jumlahJarak += pow(places[i].jarak, 2);
      }
      kolomJarak = sqrt(jumlahJarak);
      for (int i = 0; i < places.length; i += 1) {
        places[i].normalisasiHarga = double.parse(places[i].harga) / kolomHarga;
        places[i].normalisasiWaktu =
            double.parse(places[i].jumlahWaktuLatihan) / kolomWaktu;
        places[i].normalisasiJarak = places[i].jarak / kolomJarak;
      }
      /* ---------------------- */

      /*NORMALISASI TERBOBOT*/
      for (int i = 0; i < places.length; i += 1) {
        places[i].normalisasiHarga = places[i].normalisasiHarga * bobotHargaNormalisasi;
        places[i].normalisasiJarak = places[i].normalisasiJarak * bobotJarakNormalisasi;
        places[i].normalisasiWaktu = places[i].normalisasiWaktu * bobotWaktuNormalisasi;
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
      }
      /*------------------*/

      /* ----------Hasil Topsis------*/
      for (int i = 0; i < places.length; i += 1) {
        double hasil = places[i].siMin / (places[i].siMin + places[i].siPlus);
        places[i].hasilTopsis = hasil;
      }

      places.sort((a, b) => (a.hasilTopsis).compareTo(b.hasilTopsis));
      for (int i = 0; i < places.length; i += 1) {
        places[i].hasilBorda = places[i].hasilTopsis * (i + 1);
      }

      places.sort((a, b) => (b.hasilBorda).compareTo(a.hasilBorda));
      var usersRef = await Firestore.instance
          .collection('group')
          .document(selectedGroup)
          .collection('rekom')
          .document(idCobas)
          .get();

      if (usersRef.exists) {
        var hasil2 = await groupRef
            .document(selectedGroup)
            .collection('rekom')
            .document(idCobas)
            .collection('hasil')
            .getDocuments();
        rekomendasi = hasil2.documents
            .map((doc) => Rekomendasi.fromMap(doc.data, doc.documentID))
            .toList();
        //print(hasilBordaDb);
        rekomendasi.sort((a, b) => (a.idPlaces).compareTo(b.idPlaces));
        places.sort((a, b) => (a.id).compareTo(b.id));
        for (int i = 0; i < places.length; i += 1) {
          places[i].hasilBorda =
              rekomendasi[i].hasilBorda + places[i].hasilBorda;
          updateBorda(
              places[i].id, selectedGroup, places[i].hasilBorda, idCobas);
        }
        places.sort((a, b) => (b.hasilBorda).compareTo(a.hasilBorda));
      } else {
        for (int i = 0; i < places.length; i += 1) {
          listId = places[i].id;
          //print(listId);
          setBorda(listId, selectedGroup, places[i].hasilBorda, idCobas);
        }
      }
    return places;
  }

  Future<Places> getPlacesById(String id) async {
    var doc = await _databasePlaces.getDocumentById(id);
    return Places.fromMap(doc.data, doc.documentID);
  }

  Future<void> setBorda(
      String placeId, String groupId, double hasil, String idCobas) async {
    var batch = Firestore.instance.batch();

    var cond1 =
        groupRef.document(groupId).collection('rekom').document(idCobas);

    var cond2 = groupRef
        .document(groupId)
        .collection('rekom')
        .document(idCobas)
        .collection('hasil')
        .document(placeId);
    Map<String, dynamic> values = {"borda": hasil};
    Map<String, dynamic> values2 = {"dummy": 'dummy'};

    batch.setData(cond2, values);
    batch.setData(cond1, values2);
    await batch.commit();
  }

  Future<void> updateBorda(
      String placeId, String groupId, double hasil, String idCobas) async {
    var batch = Firestore.instance.batch();

    var cond2 = groupRef
        .document(groupId)
        .collection('rekom')
        .document(idCobas)
        .collection('hasil')
        .document(placeId);
    Map<String, dynamic> values = {"borda": hasil};
    batch.updateData(cond2, values);
    await batch.commit();
  }

  Future<List<Places>> doTopsis(
    double valueHarga,
    double valueJarak,
    double valueWaktu,
    double lat,
    double lon,
  ) async {
    var hasil = await _databasePlaces.getDataCollection();
    places = hasil.documents
        .map((doc) => Places.fromMap(doc.data, doc.documentID))
        .toList();

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
    }
    double jumlahHarga = 0.0, jumlahJarak = 0.0, jumlahWaktu = 0.0;
    double kolomHarga = 0.0, kolomJarak = 0.0, kolomWaktu = 0.0;
    double pembagiBobot = valueHarga+valueJarak+valueWaktu;
    double bobotHargaNormalisasi = valueHarga/pembagiBobot;
    double bobotJarakNormalisasi = valueJarak/pembagiBobot;
    double bobotWaktuNormalisasi = valueWaktu/pembagiBobot;

    for (int i = 0; i < places.length; i += 1) {
      jumlahHarga += pow(double.parse(places[i].harga), 2);
    }
    kolomHarga = sqrt(jumlahHarga);
    print(kolomHarga);

    for (int i = 0; i < places.length; i += 1) {
      jumlahWaktu += pow(double.parse(places[i].jumlahWaktuLatihan), 2);
    }
    kolomWaktu = sqrt(jumlahWaktu);

    for (int i = 0; i < places.length; i += 1) {
      jumlahJarak += pow(places[i].jarak, 2);
    }
    kolomJarak = sqrt(jumlahJarak);

    for (int i = 0; i < places.length; i += 1) {
      places[i].normalisasiHarga = double.parse(places[i].harga) / kolomHarga;
      places[i].normalisasiWaktu =
          double.parse(places[i].jumlahWaktuLatihan) / kolomWaktu;
      places[i].normalisasiJarak = places[i].jarak / kolomJarak;
    }

    for (int i = 0; i < places.length; i += 1) {
      places[i].normalisasiHarga = places[i].normalisasiHarga * bobotHargaNormalisasi;
      places[i].normalisasiJarak = places[i].normalisasiJarak * bobotJarakNormalisasi;
      places[i].normalisasiWaktu = places[i].normalisasiWaktu * bobotWaktuNormalisasi;
    }

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
    }

    for (int i = 0; i < places.length; i += 1) {
      double hasil = places[i].siMin / (places[i].siMin + places[i].siPlus);
      places[i].hasilTopsis = hasil;
    }

    places.sort((a, b) => (a.hasilTopsis).compareTo(b.hasilTopsis));
    for (int i = 0; i < places.length; i += 1) {
      places[i].hasilBorda = places[i].hasilTopsis * (i + 1);
    }
    places.sort((a, b) => (b.hasilBorda).compareTo(a.hasilBorda));
    return places;
  }
}
