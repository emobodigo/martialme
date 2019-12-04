import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:martialme/model/places.dart';
import 'package:martialme/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class HasilRekomendasiDetail extends StatelessWidget {
  final String places, currentUserId;
  final double latitude, longitude;
  final FirebaseUser user;

  HasilRekomendasiDetail(
      {Key key,
      this.places,
      this.latitude,
      this.longitude,
      this.user,
      this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String origin = "$latitude,$longitude";
    String destination;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFFE7050),
          ),
          FutureBuilder(
              future: placesRef.document(places).get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  Places placesProv = Places.fromJson(snapshot.data);
                  var list = placesProv.jadwal;
                  var url = '${placesProv.instagram}';
                  destination =
                      "${placesProv.latitude},${placesProv.longitude}";
                  return Stack(
                    children: <Widget>[
                      
                      Container(
                        height: MediaQuery.of(context).size.height - 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(35.0),
                                bottomRight: Radius.circular(35.0)),
                            color: Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 325.0,
                        child: CachedNetworkImage(
                          imageUrl: '${placesProv.gambar}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40.0),
                                  bottomRight: Radius.circular(40.0)),
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: imageProvider),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        top: 385,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 35.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_on,
                                                  size: 12.0,
                                                  color: Colors.grey,
                                                ),
                                                Text('${placesProv.alamat}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 12.0,
                                                        color: Colors.grey))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7.0,
                                            ),
                                            Text('${placesProv.namaTempat}',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 24.0,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 60.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFE7050),
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          IconButton(
                                              onPressed: () async {
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                              icon: Icon(
                                                FontAwesomeIcons.instagram,
                                                color: Colors.white,
                                                size: 20.0,
                                              )),
                                          SizedBox(
                                            height: 7.0,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 17.0, right: 17.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('${placesProv.jenisBeladiri}',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 15.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(
                                        width: 25.0,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "Rp. ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17.0,
                                                color: Colors.black,
                                                fontFamily: 'Montserrat'),
                                            children: [
                                              TextSpan(
                                                  text: '${placesProv.harga}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17.0,
                                                      color: Colors.black,
                                                      fontFamily: 'Montserrat'))
                                            ]),
                                      )
                                    ],
                                  ),
                                )),

                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10, right: 15.0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 532,
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.grey.withOpacity(0.2)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Jadwal Latihan: ",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  for (var item in list)
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 15, top: 10),
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w400),
                                        ))
                                ],
                              ),
                            ),

                            //padding
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
              Padding(
            padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 15.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 15.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white60),
                        child: IconButton(
                          onPressed: Navigator.of(context).pop,
                          icon: Icon(Icons.arrow_back_ios,
                              color: Colors.black, size: 20.0),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white60),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      icon: Icon(Icons.home, color: Colors.black, size: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
                        bottom: 22.0,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: InkWell(
                                onTap: () async {
                                  String url =
                                      "https://www.google.com/maps/dir/?api=1&origin=" +
                                          origin +
                                          "&destination=" +
                                          destination +
                                          "&travelmode=driving&dir_action=navigate";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.white.withOpacity(0.3),
                                        size: 11.0),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.white.withOpacity(0.5),
                                        size: 12.0),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 13.0),
                                    Icon(Icons.motorcycle, color: Colors.white),
                                  ],
                                ),
                              ),
                            )),
                      ),
        ],
      ),
    );
  }
}
