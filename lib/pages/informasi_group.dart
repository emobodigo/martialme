import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:martialme/model/group.dart';
import 'package:martialme/pages/add_group.dart';
import 'package:martialme/pages/group_detail.dart';
import 'package:martialme/provider/groupProvider.dart';
import 'package:martialme/utils/info.dart';
import 'package:provider/provider.dart';

class InformasiGroup extends StatelessWidget {
  List<Group> group;

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
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
                      "Group",
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
                            stream: groupProvider.fetchProductAsStream(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Text("Loading");
                              } else {
                                group = snapshot.data.documents
                                    .map((doc) => Group.fromMap(
                                        doc.data, doc.documentID))
                                    .toList();
                                return ListView.builder(
                                    itemCount: group.length,
                                    itemBuilder: (buildContext, index) =>
                                        ListPlaceWidget(
                                            groupDetail: group[index]));
                              }
                            }),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.lightBlue,
            elevation: 2.0,
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AddGroup();
              }));
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}

class ListPlaceWidget extends StatelessWidget {
  final Group groupDetail;
  
  const ListPlaceWidget({Key key, @required this.groupDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: InkWell(
        onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) {
             return GroupDetail(groupDetail: groupDetail);
           }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: groupDetail.id,
                    child: Container(
                      height:  75.0,
                      width: 75.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/group.png')
                        )
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          '${groupDetail.namaGroup}',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
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
              onPressed: () async{
                await groupProvider.removeGroup(groupDetail.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
