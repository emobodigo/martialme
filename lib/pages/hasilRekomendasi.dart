import 'package:flutter/material.dart';
import 'package:martialme/provider/placesProvider.dart';
import 'package:provider/provider.dart';

class HasilRekomendasi extends StatelessWidget {
  final double longitude, latitude, valueHarga, valueJarak, valueWaktu;
  final String selectedGroup;

  const HasilRekomendasi(
      {Key key,
      this.longitude,
      this.latitude,
      this.valueHarga,
      this.valueJarak,
      this.valueWaktu, this.selectedGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placesProvider = Provider.of<PlacesProvider>(context);
    return Scaffold(
      body: FutureBuilder(
        future: placesProvider.fetchPlaces( valueHarga, valueJarak, valueWaktu, latitude, longitude),
        builder: (context, AsyncSnapshot snapshot) {
          return Container(
            height: 0.0,
            width: 0.0,
          );
        },
      ),
    );
  }
}
