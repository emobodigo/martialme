import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:martialme/model/places.dart';
import 'package:martialme/utils/info.dart';
import 'package:url_launcher/url_launcher.dart';

class InformasiDetail extends StatelessWidget {
  final Places places;

  const InformasiDetail({Key key, @required this.places}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = places.jadwal;

    _launchURL() async {
      var url = '${places.instagram}';
      if(await canLaunch(url)){
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return AnimatedContainer(
      duration: Duration(microseconds: 500),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              Info.app_name,
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                color: Color(0xFF21BFBD),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35.0),
                        bottomRight: Radius.circular(35.0)),
                    color: Colors.white),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 370.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    image: DecorationImage(
                        image: NetworkImage('${places.gambar}'),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                top: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 35.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 12.0,
                                          color: Colors.grey,
                                        ),
                                        Text('${places.alamat}',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12.0,
                                                color: Colors.grey))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7.0,
                                    ),
                                    Text('${places.namaTempat}',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 60.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () {
                                        _launchURL();
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.black,
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
                          padding:
                              const EdgeInsets.only(left: 17.0, right: 17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${places.jenisBeladiri}',
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
                                          text: '${places.harga}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17.0,
                                              color: Colors.black,
                                              fontFamily: 'Montserrat'))
                                    ]),
                              )
                            ],
                          ),
                        )),

                    Container(
                      margin: const EdgeInsets.only(
                          top: 5, left: 10.0, right: 15.0),
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.height - 530,
                      padding: EdgeInsets.only(top: 10, left: 10, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.withOpacity(0.2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Jadwal Latihan: ",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600)),
                          for (var item in list)
                            Padding(
                                padding: EdgeInsets.only(left: 15, top: 10),
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
          ),
        ),
      ),
    );
  }
}
