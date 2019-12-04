
import 'package:flutter/material.dart';
import 'package:martialme/model/groupuser.dart';
import 'package:martialme/pages/add_group.dart';
import 'package:martialme/pages/group_detail.dart';
import 'package:martialme/provider/groupProvider.dart';
import 'package:martialme/utils/constant.dart';
import 'package:martialme/utils/info.dart';
import 'package:provider/provider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';


class InformasiGroup extends StatefulWidget {
  final String currentUserid;

  InformasiGroup({Key key, this.currentUserid}) : super(key: key);

  @override
  _InformasiGroupState createState() => _InformasiGroupState();
}

class _InformasiGroupState extends State<InformasiGroup> {
  List<GroupUser> group;
  
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
                        child: FutureBuilder(
                            future: groupUserRef.document(widget.currentUserid).collection('groups').getDocuments(),
                            builder: (context,
                                AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator(),);
                              } else {
                                group = snapshot.data.documents
                                    .map<GroupUser>((doc) => GroupUser.fromMap(
                                        doc.data, doc.documentID))
                                    .toList();
                                return ListView.builder(
                                    itemCount: group.length,
                                    itemBuilder: (buildContext, index) =>
                                        ListPlaceWidget(
                                            groupDetail: group[index], currentUserId: widget.currentUserid, parent: this,));
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
                return AddGroup(currentUserId: widget.currentUserid);
              }));
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
 
}


class ListPlaceWidget extends StatefulWidget  {
  final GroupUser groupDetail;
  final String currentUserId;
  final _InformasiGroupState parent;
  const ListPlaceWidget({Key key, @required this.groupDetail, this.currentUserId, this.parent}) : super(key: key);

  @override
  _ListPlaceWidgetState createState() => _ListPlaceWidgetState();
}

class _ListPlaceWidgetState extends State<ListPlaceWidget> {
  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: InkWell(
        onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) {
             return GroupDetail(groupDetail: widget.groupDetail, currentUserId: widget.currentUserId);
           }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: widget.groupDetail.id,
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
                          '${widget.groupDetail.namagroup}',
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
              onPressed: () {
                showDialog(context: context, builder: (_) => AssetGiffyDialog(
                  image: Image.asset('assets/images/question.gif'),
                  title: Text('Hapus Group?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  description: Text('Apakah anda yakin menghapus Group?, menghapus group akan menghapus seluruh anggota di dalamnya', textAlign: TextAlign.center,),
                  onOkButtonPressed: () async{
                    await groupProvider.removeGroup(widget.groupDetail.id, widget.currentUserId);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                      return InformasiGroup(currentUserid: widget.currentUserId,);
                    }));
                  },
                  onCancelButtonPressed: (){
                    Navigator.pop(context);
                  },
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
