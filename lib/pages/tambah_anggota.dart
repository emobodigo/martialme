import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:martialme/db/user.dart';
import 'package:martialme/model/group.dart';
import 'package:martialme/model/groupuser.dart';
import 'package:martialme/model/user_model.dart';
import 'package:martialme/provider/groupProvider.dart';
import 'package:provider/provider.dart';

class TambahAnggota extends StatefulWidget {
  final GroupUser group;
  final String currentUserId;

  const TambahAnggota({Key key, @required this.group, this.currentUserId}) : super(key: key);

  @override
  _TambahAnggotaState createState() => _TambahAnggotaState();
}

class _TambahAnggotaState extends State<TambahAnggota> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                border: InputBorder.none,
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  size: 30.0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _clearSearch();
                  },
                ),
                filled: true),
            onSubmitted: (input) {
              if (input.isNotEmpty) {
                setState(() {
                  _users = UserServices.searchUser(input);
                });
              }
            },
          ),
        ),
        body: _users == null
            ? Center(
                child: Text("Cari user untuk ditambahkan.."),
              )
            : FutureBuilder(
                future: _users,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Text("Tidak ada user yang ditemukan, coba lagi.."),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      UsersModel user =
                          UsersModel.fromDoc(snapshot.data.documents[index]);
                      return _buildUserTile(user);
                    },
                  );
                },
              ));
  }

  _buildUserTile(UsersModel user) {
    final groupProvider = Provider.of<GroupProvider>(context);
    return user.userId == widget.currentUserId ? Visibility(
          child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage('assets/images/userIcon.png'),
        ),
        title: Text(user.name),
        trailing: Icon(Icons.add),
        onTap: () async {
          await groupProvider.addUserToGroup(
              GroupUser(
                  groupId: widget.group.groupId,
                  namagroup: widget.group.namagroup),
              Group(userId: user.userId, username: user.name),
              user.userId,
              widget.group.groupId);
        },
      ),
      visible: false,
    ) : Visibility(
          child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage('assets/images/userIcon.png'),
        ),
        title: Text(user.name),
        trailing: Icon(Icons.add),
        onTap: () async {
          await groupProvider.addUserToGroup(
              GroupUser(
                  groupId: widget.group.groupId,
                  namagroup: widget.group.namagroup),
              Group(userId: user.userId, username: user.name),
              user.userId,
              widget.group.groupId);
        },
      ),
      visible: true,
    ) ;
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }
}
