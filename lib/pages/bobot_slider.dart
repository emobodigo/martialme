import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:martialme/provider/userProvider.dart';
import 'package:martialme/utils/info.dart';
import 'package:provider/provider.dart';

class BobotSlider extends StatefulWidget {
  final FirebaseUser user;

  const BobotSlider({Key key, this.user}) : super(key: key);

  @override
  _BobotSliderState createState() => _BobotSliderState();
}

class _BobotSliderState extends State<BobotSlider> {
  double valueharga = 0.0;
  double valuejarak = 0.0;
  double valuewaktu = 0.0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return AnimatedContainer(
      duration: Duration(microseconds: 500),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(Info.app_name),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.signOutAlt,
                  size: 18,
                ),
                onPressed: () {
                  user.signOut();
                },
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                NamaBobot(text: "Harga",),
                Container(
                height: 53,
                padding: EdgeInsets.only(top:5),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )
                ),
                child: Column(
                  children: <Widget>[
                    Slider(
                        value: valueharga,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '${valueharga.toDouble()}',
                        onChanged: (double changedValue) {
                          setState(() {
                            valueharga = changedValue;
                          });
                        },
                      )
                  ],
                ),
              ),
                Divider(),
                NamaBobot(text: "Jarak",),
                Container(
                height: 53,
                padding: EdgeInsets.only(top:5),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )
                ),
                child: Column(
                  children: <Widget>[
                    Slider(
                        value: valuejarak,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '${valuejarak.toDouble()}',
                        onChanged: (double changedValue) {
                          setState(() {
                            valuejarak = changedValue;
                          });
                        },
                      )
                  ],
                ),
              ),
                Divider(),
                NamaBobot(text: "Jumlah Waktu Latihan",),
                Container(
                height: 53,
                padding: EdgeInsets.only(top:5),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )
                ),
                child: Column(
                  children: <Widget>[
                    Slider(
                        value: valuewaktu,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '${valuewaktu.toDouble()}',
                        onChanged: (double changedValue) {
                          setState(() {
                            valuewaktu = changedValue;
                          });
                        },
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 130,
              ),
              Center(
                child: Container(
                  width: 120,
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    splashColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text("Submit"),
                    onPressed: (){

                    },
                  ),
                ),
              )
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}

class NamaBobot extends StatelessWidget {

  final String text;

  const NamaBobot({
    Key key, @required this.text
  }) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
