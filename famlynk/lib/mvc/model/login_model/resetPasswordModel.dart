import 'dart:convert';

ResetPasswordModel ResetPasswordModelFromJson(String str) =>
    ResetPasswordModel.fromJson(json.decode(str));

String ResetPasswordModelToJson(ResetPasswordModel data) =>
    json.encode(data.toJson());

class ResetPasswordModel {
  String? email;
  String? password;

  ResetPasswordModel({
    this.email,
    this.password,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
