import 'dart:convert';

List<LoginModel> loginModelFromJson(String str) =>
    List<LoginModel>.from(json.decode(str).map((x) => LoginModel.fromJson(x)));

String loginModelToJson(List<LoginModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginModel {
  LoginModel({
    this.phoneNumber,
    this.uuid,
  });

  String? phoneNumber;
  String? uuid;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        phoneNumber: json["phoneNumber"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "uuid": uuid,
      };
}
