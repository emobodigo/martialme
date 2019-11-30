import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:martialme/model/places.dart';
import 'package:martialme/pages/informasi_detail.dart';
import 'package:martialme/provider/placesProvider.dart';
import 'package:martialme/utils/info.dart';
import 'package:provider/provider.dart';

class InformasiTempat extends StatelessWidget {
  List<Places> places;

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlacesProvider>(context);
    return AnimatedContainer(
      duration: Duration(microseconds: 500),
      child: SafeArea(
        top: false,
        bottom: false,
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
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Informasi",
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
                      "Beladiri",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 25.0),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 35,
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
                        child: StreamBuilder(
                            stream: placeProvider.fetchProductAsStream(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                places = snapshot.data.documents
                                    .map((doc) => Places.fromMap(
                                        doc.data, doc.documentID))
                                    .toList();
                                return ListView.builder(
                                    itemCount: places.length,
                                    itemBuilder: (buildContext, index) =>
                                        ListPlaceWidget(
                                            placesDetail: places[index]));
                              }
                            }),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListPlaceWidget extends StatelessWidget {
  final Places placesDetail;

  const ListPlaceWidget({Key key, @required this.placesDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return InformasiDetail(places: placesDetail);
          }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: placesDetail.id,
                    child: Container(
                      height: 75.0,
                      width: 75.0,
                      child: CachedNetworkImage(
                        imageUrl: '${placesDetail.gambarlogo}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover, image: imageProvider),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${placesDetail.namaTempat}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text('${placesDetail.jenisBeladiri}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
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
  }
}
