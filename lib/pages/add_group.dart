import 'package:flutter/material.dart';
import 'package:martialme/model/group.dart';
import 'package:martialme/provider/groupProvider.dart';
import 'package:martialme/provider/userProvider.dart';
import 'package:martialme/utils/info.dart';
import 'package:provider/provider.dart';

class AddGroup extends StatefulWidget {
  

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  TextEditingController _namaGroup;
  final _formKey = GlobalKey<FormState>();

  String namaGroup;

  @override
  void initState(){
    super.initState();
    _namaGroup = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
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
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Tambah",
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _namaGroup,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nama Group',
                            fillColor: Colors.grey[300],
                            filled: true
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'Masukkan nama group';
                            }
                          },
                          onSaved: (value) => namaGroup = value,
                        ),
                        RaisedButton(
                          splashColor: Colors.red,
                          onPressed: () async{
                            var temp = await userProvider.inputData();
                            
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              await groupProvider.addGroup(Group(namaGroup: namaGroup),);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Tambah Group', style: TextStyle(color: Colors.white)),
                          color: Colors.lightBlue,
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
