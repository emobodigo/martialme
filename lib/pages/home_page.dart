import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:martialme/model/userLocation.dart';
import 'package:martialme/pages/informasi_group.dart';
import 'package:martialme/pages/informasi_tempat.dart';
import 'package:martialme/pages/launchRekomendasi.dart';
import 'package:martialme/provider/userProvider.dart';
import 'package:martialme/utils/info.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final FirebaseUser users;
  
  final String currentUserid;
  const HomePage({Key key, this.users, this.currentUserid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final location = Provider.of<UserLocation>(context);
    final double latitude = location?.latitude;
    final double longitude = location?.longitude;
    return AnimatedContainer(
      duration: Duration(microseconds: 500),
      //Define color provider
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(Info.app_name, style: TextStyle(fontFamily: 'Montserrat'),),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  //provider
                  FontAwesomeIcons.signOutAlt, size: 18,
                ),
                onPressed: () {
                  user.signOut();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new ImageCard(),
                  SizedBox(
                    height: 20,
                  ),
                  ...text(context),
                  SizedBox(
                    height: 50,
                  ),
                  buttonGo(context, user.user, latitude, longitude),
                  SizedBox(
                    height: 30,
                  ),
                  Text('Location: Lat ${location?.latitude}, Long: ${location?.longitude}'),
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    Info.app_version,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> text(context) =>  [
        Text(
          Info.welcomeText,
          style: Theme.of(context)
              .textTheme
              .headline
              .apply(fontFamily: 'Montserrat'),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          Info.headlineText,
          style: Theme.of(context)
              .textTheme
              .caption
              .apply(fontFamily: 'Montserrat'),
          textAlign: TextAlign.center,
        ),
      ];

  Widget buttonGo(context, user, latitude, longitude)  =>  Wrap(
        alignment: WrapAlignment.center,
        spacing: 20.0,
        runSpacing: 20.0,
        children: <Widget>[
          new CardButton(
            iconData: FontAwesomeIcons.diagnoses,
            title: Info.rekomendasi,
            color: Colors.green,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LaunchRekomendasi(latitude: latitude, longitude: longitude, currentUserId: currentUserid, user: user ,);
              }));
            },
          ),
          CardButton(
            iconData: FontAwesomeIcons.bookOpen,
            title: Info.dataLatihan,
            color: Colors.redAccent,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return InformasiTempat();
              }));
            },
          ),
          CardButton(
            iconData: FontAwesomeIcons.users,
            title: Info.group,
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return InformasiGroup(currentUserid: currentUserid,);
              }));
            },
          )
        ],
      );
}

class CardButton extends StatelessWidget {
  final Function onPressed;
  final IconData iconData;
  final String title;
  final Color color;

  const CardButton(
      {Key key, this.onPressed, this.iconData, this.color, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPressed,
      child: Ink(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
            color: //provider
                Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: //provider null
                [
              BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, color: color),
            SizedBox(
              height: 10,
            ),
            Text(title,
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 12))
          ],
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      padding: EdgeInsets.all(20),
      child: Image.asset(
        //provider
        'assets/images/banner_light.png', fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
      decoration: BoxDecoration(
          color: //provider
              Colors.white,
          borderRadius: BorderRadius.circular(20)),
    );
  }
}
