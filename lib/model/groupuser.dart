
class GroupUser {
  final String id, groupId, namagroup;

  GroupUser({this.id, this.groupId, this.namagroup});

  factory GroupUser.fromMap(Map<String, dynamic> data, String id){
    data = data ?? {};
    return GroupUser(
      id: id,
      groupId: data['groupId'],
      namagroup: data['nama_group']
    );
  }

  toJson(String id) {
    return {
      "nama_group": namagroup,
      "groupId" : id
    };
  }

}