import 'package:flutter/material.dart';
import 'package:martialme/model/group.dart';
import 'package:martialme/model/groupuser.dart';
import 'package:martialme/pages/tambah_anggota.dart';
import 'package:martialme/utils/constant.dart';
import 'package:martialme/utils/info.dart';

class GroupDetail extends StatelessWidget {
  final GroupUser groupDetail;
  final String currentUserId;
  List<Group> group;

  GroupDetail({Key key, @required this.groupDetail, this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TambahAnggota(group: groupDetail,);
                  }));
                },
              ),
              IconButton(
                icon: Icon(Icons.pages),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Group",
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
                      "Detil",
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
                          child: FutureBuilder(
                            future: groupRef
                                .document(groupDetail.groupId)
                                .collection('usersg')
                                .getDocuments(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                group = snapshot.data.documents
                                    .map<Group>((doc) =>
                                        Group.fromMap(doc.data, doc.documentID))
                                    .toList();
                              
                              return ListView.builder(
                                itemCount: group.length,
                                itemBuilder: (context, i) {
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
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              'assets/images/user.png'))),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15.0),
                                                      child: Text(
                                                        '${group[i].username}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.black,
                                            onPressed: () {},
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
