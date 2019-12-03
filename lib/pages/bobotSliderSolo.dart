import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialme/model/groupuser.dart';
import 'package:martialme/pages/hasilRekomendasiSolo.dart';

class BobotSliderSolo extends StatefulWidget {
  final double latitude, longitude;
  final String currentUserId;
  final FirebaseUser user;
  const BobotSliderSolo(
      {Key key, this.latitude, this.longitude, this.currentUserId, this.user})
      : super(key: key);

  @override
  _BobotSliderState createState() => _BobotSliderState();
}

class _BobotSliderState extends State<BobotSliderSolo> {
  List<GroupUser> group;
  String selectedGroup;
  double valueharga = 0.0;
  double valuejarak = 0.0;
  double valuewaktu = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/solo.png'), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400], blurRadius: 10, offset: Offset(0, 10))
          ]),
      child: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text("Solo Rekomendasi",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold))
                  ])),
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            top: 90,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  NamaBobot(
                    text: "Harga",
                  ),
                  Container(
                    height: 53,
                    padding: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )),
                    child: Slider(
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
                    ),
                  ),
                  Divider(),
                  NamaBobot(
                    text: "Jarak",
                  ),
                  Container(
                    height: 53,
                    padding: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )),
                    child: Slider(
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
                    ),
                  ),
                  Divider(),
                  NamaBobot(
                    text: "Jumlah Waktu Latihan",
                  ),
                  Container(
                    height: 53,
                    padding: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )),
                    child: Slider(
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
                    ),
                  ),
                  Divider(),
                  Divider(),
                  Container(
                    height: 130,
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      "Tentukan bobot masing-masing kriteria sesuai dengan preferensi anda, bobot merepresentasikan prioritas anda terhadap kriteria. Misal: Anda memprioritaskan tempat latihan yang dekat dengan posisi anda tanpa peduli harga yang ditawarkan, maka berikan bobot jarak lebih tinggi daripada bobot harga",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: Container(
                      width: 120,
                      child: RaisedButton(
                        color: Colors.indigoAccent.withOpacity(0.9),
                        textColor: Colors.white,
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Submit"),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HasilRekomendasiSolo(
                              latitude: widget.latitude,
                              longitude: widget.longitude,
                              valueHarga: valueharga,
                              valueJarak: valuejarak,
                              valueWaktu: valuewaktu,
                              user: widget.user,
                              currentUserId: widget.currentUserId,
                            );
                          }));
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    )));
  }
}

class NamaBobot extends StatelessWidget {
  final String text;

  const NamaBobot({Key key, @required this.text})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
          color: Colors.cyan.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
