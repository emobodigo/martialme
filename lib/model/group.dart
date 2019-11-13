class Group{
  final String namaGroup, id;
  final List<String> users;

  Group({this.id, this.namaGroup, this.users});

  factory Group.fromMap(Map<String, dynamic> data, String id){
    data = data ?? {};
   var userfromMap = data['user'];
    List<String> userList = userfromMap.cast<String>();
    return Group(
      id: id,
      namaGroup: data['nama_group'],
      users: userList
    );
  }
}