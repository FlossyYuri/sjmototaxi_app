class UserModel {
  String name = '';
  String role = '';
  String uid = '';
  String email = '';
  String phone = '';
  String? photo = '';

  UserModel(this.name, this.role, this.uid, this.email, this.phone, this.photo);

  UserModel.fromMap(Map<String, dynamic> user) {
    name = user['name'];
    role = user['role'];
    uid = user['uid'];
    email = user['email'];
    phone = user['phone'];
    photo = user['photo'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'uid': uid,
      'email': email,
      'phone': phone,
      'photo': photo,
    };
  }
}
