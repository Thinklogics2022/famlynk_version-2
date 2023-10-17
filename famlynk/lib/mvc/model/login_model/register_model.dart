import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel(
      {this.id,
      this.userId,
      this.uniqueUserID,
      this.name,
      this.gender,
      this.dateOfBirth,
      this.password,
      this.email,
      this.profileImage,
      this.mobileNo,
      this.address,
      this.coverImage,
      this.hometown,
      this.maritalStatus, 
      this.otp,
      this.verificationToken});
  String? id;
  String? userId;
  String? uniqueUserID;
  String? name;
  String? gender;
  String? dateOfBirth;
  String? password;
  String? email;
  String? profileImage;
  String? mobileNo;
  String? address;
  String? hometown;
  String? maritalStatus;
  String? coverImage;
  String? otp;
  String? verificationToken;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
      id: json['id'],
      uniqueUserID: json['uniqueUserID'],
      userId: json['userId'],
      name: json["name"],
      gender: json["gender"],
      dateOfBirth: json["dateOfBirth"],
      password: json["password"],
      email: json["email"],
      profileImage: json["profileImage"],
      mobileNo: json["mobileNo"],
      address: json["address"],
      hometown: json["hometown"],
      maritalStatus: json["maritalStatus"],
      coverImage: json["coverImage"],
      otp: json["otp"],
      verificationToken: json["verificationToken"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "uniqueUserID": uniqueUserID,
        "userId": userId,
        "name": name,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "password": password,
        "email": email,
        "profileImage": profileImage,
        "mobileNo": mobileNo,
        "address": address,
        "hometown": hometown,
        "maritalStatus": maritalStatus,
        "coverImage": coverImage,
        "otp": otp,
        "verificationToken": verificationToken
      };
}
