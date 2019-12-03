import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:martialme/pages/bobotSliderSolo.dart';
import 'package:martialme/pages/bobot_slider.dart';
import 'package:martialme/utils/info.dart';
import 'package:martialme/widget/fadeAnimation.dart';

class LaunchRekomendasi extends StatelessWidget {
  final double latitude, longitude;
  final String currentUserId;
  final FirebaseUser user;

  const LaunchRekomendasi(
      {Key key, this.latitude, this.longitude, this.currentUserId, this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: null,
        centerTitle: true,
        title: Text(Info.app_name,
            style: TextStyle(color: Colors.black, fontFamily: "Montserrat")),
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              cardItem(
                  image: 'assets/images/solo.png',
                  text: 'Solo',
                  text2: 'Rekomendasi untuk perorangan',
                  tag: 'solo',
                  onTaping: BobotSliderSolo(
                    latitude: latitude,
                    longitude: longitude,
                    currentUserId: currentUserId,
                    user: user,
                  ),
                  context: context),
              cardItem(
                  image: 'assets/images/grouprekom.png',
                  text: 'Group',
                  text2: 'Rekomendasi untuk kelompok',
                  tag: 'group',
                  onTaping: BobotSlider(
                    latitude: latitude,
                    longitude: longitude,
                    currentUserId: currentUserId,
                  ),
                  context: context)
            ],
          ),
        ),
      ),
    );
  }

  Widget cardItem({image, text, text2, tag, onTaping, context}) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return onTaping;
          }));
        },
        child: Container(
          height: 250,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[400],
                    blurRadius: 10,
                    offset: Offset(0, 10))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            1,
                            Text(text,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            1,
                            Text(
                              text2,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15, ),
                            ))
                      ],
                    ),
                  ),
                  FadeAnimation(
                      1.2,
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.lightbulb,
                            size: 20,
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
