import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:martialme/provider/placesProvider.dart';
import 'package:martialme/utils/info.dart';
import 'package:provider/provider.dart';

class HasilRekomendasi extends StatelessWidget {
  final double longitude, latitude, valueHarga, valueJarak, valueWaktu;
  final String selectedGroup;
  final String userId;

  const HasilRekomendasi(
      {Key key,
      this.longitude,
      this.latitude,
      this.valueHarga,
      this.valueJarak,
      this.valueWaktu,
      this.selectedGroup,
      this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placesProvider = Provider.of<PlacesProvider>(context);
    return AnimatedContainer(
      duration: Duration(microseconds: 500),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFF21BFBD),
          appBar: AppBar(
            backgroundColor: Color(0xFF21BFBD),
            title: Text(
              Info.app_name,
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.filter_list),
                color: Colors.white,
                onPressed: () {},
              )
            ],
          ),
          body: ListView(children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40),
              child: Row(
                children: <Widget>[
                  Text(
                    "Hasil",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Rekomendasi",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 25.0),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 170,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(75))),
              child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 17, right: 10),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 190,
                      child: FutureBuilder(
                        future: placesProvider.fetchPlaces(
                          valueHarga,
                          valueJarak,
                          valueWaktu,
                          latitude,
                          longitude,
                          selectedGroup,
                        ),
                        builder: (context, AsyncSnapshot snapshot) {
                          //print(snapshot.data);
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: placesProvider.places.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 75.0,
                                                width: 75.0,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '${placesProvider.places[index].gambarlogo}',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: imageProvider),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    '${placesProvider.places[index].namaTempat}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      '${placesProvider.places[index].jenisBeladiri}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 15.0,
                                                        color: Colors.grey,
                                                      )),
                                                  Text(
                                                      '${placesProvider.places[index].jarak}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 14.0,
                                                        color: Colors.grey,
                                                      )),
                                                  Text(
                                                      '${placesProvider.places[index].hasilBorda}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 10.0,
                                                        color: Colors.grey,
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
