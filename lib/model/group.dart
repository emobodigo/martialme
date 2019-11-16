class Group{
  final String namaGroup, id;
  final List<Users> users;

  Group({this.id, this.namaGroup, this.users});

  factory Group.fromMap(Map<dynamic, dynamic> data, String id){
    data = data ?? {};
   var list = data['users'] as List;
   List<Users> usersL = list.map((i) => Users.fromMap(i)).toList();
    return Group(
      id: id,
      namaGroup: data['nama_group'],
      users: usersL
    );
  }
}

class Users {
  final String userId, username;

  Users({this.userId, this.username});

  factory Users.fromMap(Map<dynamic, dynamic> data){
    return Users(
      userId: data['userId'],
      username: data['username']
    );
  }
}