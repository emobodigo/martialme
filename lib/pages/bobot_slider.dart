import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:martialme/model/groupuser.dart';
import 'package:martialme/pages/add_group.dart';
import 'package:martialme/pages/hasilRekomendasi.dart';
import 'package:martialme/utils/constant.dart';
import 'package:martialme/widget/fadeAnimation.dart';

class BobotSlider extends StatefulWidget {
  final FirebaseUser user;
  final double latitude, longitude;
  final String currentUserId;
  const BobotSlider(
      {Key key, this.user, this.latitude, this.longitude, this.currentUserId})
      : super(key: key);

  @override
  _BobotSliderState createState() => _BobotSliderState();
}

class _BobotSliderState extends State<BobotSlider> {
  List<GroupUser> group;
  var _formkey = GlobalKey<FormState>();
  String selectedGroup, dropdownError;
  double valueharga = 0.0;
  double valuejarak = 0.0;
  double valuewaktu = 0.0;

  _validateForm() {
    bool _isValid = _formkey.currentState.validate();
    if (selectedGroup == null) {
      setState(() {
        dropdownError = "Pilih group terlebih dahulu";
        _isValid = false;
      });
    }
    if (_isValid) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HasilRekomendasi(
          latitude: widget.latitude,
          longitude: widget.longitude,
          valueHarga: valueharga,
          valueJarak: valuejarak,
          valueWaktu: valuewaktu,
          selectedGroup: selectedGroup,
          userId: widget.currentUserId,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/grouprekom.png'),
                    fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400],
                      blurRadius: 10,
                      offset: Offset(0, 10))
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
                            child: FadeAnimation(1,Container(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                            )),
                          ),
                          FadeAnimation(1, Text("Rekomendasi Berkelompok",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold)))
                        ])),
                Positioned(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  top: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formkey,
                          child: FutureBuilder(
                            future: groupUserRef
                                .document(widget.currentUserId)
                                .collection('groups')
                                .getDocuments(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                group = snapshot.data.documents
                                    .map<GroupUser>((doc) => GroupUser.fromMap(
                                        doc.data, doc.documentID))
                                    .toList();
                                List<DropdownMenuItem> groupItem = [];
                                for (int i = 0; i < group.length; i += 1) {
                                  groupItem.add(DropdownMenuItem(
                                    child: Text(group[i].namagroup,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyan,
                                            fontStyle: FontStyle.italic)),
                                    value: "${group[i].groupId}",
                                  ));
                                }
                                if (groupItem.isNotEmpty) {
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.objectGroup,
                                            size: 20.0,
                                            color: Colors.lightBlue,
                                          ),
                                          SizedBox(
                                            width: 25.0,
                                          ),
                                          DropdownButton(
                                            items: groupItem,
                                            onChanged: (groupItemValue) {
                                              setState(() {
                                                selectedGroup = groupItemValue;
                                                dropdownError = null;
                                              });
                                            },
                                            value: selectedGroup,
                                            hint: Text(
                                              'Pilih Group',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.cyan,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                      ),
                                      dropdownError == null
                                          ? SizedBox.shrink()
                                          : Text(dropdownError ?? "",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic))
                                    ],
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            "Belum ada Group, Klik disini untuk buat group",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AddGroup(
                                                currentUserId:
                                                    widget.currentUserId);
                                          }));
                                        },
                                      )
                                    ],
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(1.2,NamaBobot(
                          text: "Harga",
                        )),
                        FadeAnimation(1.2,Container(
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
                        )),
                        Divider(),
                        FadeAnimation(1.4,NamaBobot(
                          text: "Jarak",
                        )),
                        FadeAnimation(1.4, Container(
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
                        )),
                        Divider(),
                        FadeAnimation(1.6, NamaBobot(
                          text: "Jumlah Waktu Latihan",
                        )),
                        FadeAnimation(1.6,Container(
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
                        )),
                        Divider(),
                        Divider(),
                        FadeAnimation(1.8, Container(
                          height: 130,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "Pilih group dan tentukan bobot masing-masing kriteria sesuai dengan preferensi anda, bobot merepresentasikan prioritas anda terhadap kriteria. Misal: Anda memprioritaskan tempat latihan yang dekat dengan posisi anda tanpa peduli harga yang ditawarkan, maka berikan bobot jarak lebih tinggi daripada bobot harga",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        )),
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: FadeAnimation(2,Container(
                            width: 120,
                            child: RaisedButton(
                              color: Colors.indigoAccent.withOpacity(0.9),
                              textColor: Colors.white,
                              splashColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text("Submit"),
                              onPressed: () {
                                _validateForm();
                              },
                            ),
                          )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
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
