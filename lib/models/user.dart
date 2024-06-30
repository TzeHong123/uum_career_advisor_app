class User {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? password;
  String? otp;
  String? datereg;
  String? role;
  String? profilePicture;

  User(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.password,
      this.otp,
      this.datereg,
      this.role,
      this.profilePicture});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
    otp = json['otp'];
    datereg = json['datereg'];
    role = json['role'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['password'] = password;
    data['otp'] = otp;
    data['datereg'] = datereg;
    data['role'] = role;
    data['profilePicture'] = profilePicture;

    return data;
  }
}
