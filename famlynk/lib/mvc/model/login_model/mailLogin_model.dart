import 'dart:convert';

UserLogin userLoginFromJson(String str) => UserLogin.fromJson(json.decode(str));

String userLoginToJson(UserLogin data) => json.encode(data.toJson());

class UserLogin {
  String userName;
  String password;

  UserLogin({
    required this.userName,
    required this.password,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        userName: json["userName"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
      };
}
