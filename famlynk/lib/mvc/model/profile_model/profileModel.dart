import 'dart:convert';

ProfileUserModel profileUserModelFromJson(String str) =>
    ProfileUserModel.fromJson(json.decode(str));

String profileUserModelToJson(ProfileUserModel data) =>
    json.encode(data.toJson());

class ProfileUserModel {
  ProfileUserModel(
      {this.id,
      this.userId,
      this.name,
      this.gender,
      this.dateOfBirth,
      this.password,
      this.email,
      this.createdOn,
      this.modifiedOn,
      this.status,
      this.role,
      this.enabled,
      this.verificationToken,
      this.mobileNo,
      this.otp,
      this.profileImage,
      this.uniqueUserID,
      this.coverImage,
      this.maritalStatus,
      this.hometown,
      this.address});

  String? id;
  String? userId;
  String? name;
  String? gender;
  String? dateOfBirth;
  String? password;
  String? email;
  String? createdOn;
  String? modifiedOn;
  bool? status;
  String? role;
  bool? enabled;
  String? verificationToken;
  String? mobileNo;
  String? otp;
  String? profileImage;
  String? uniqueUserID;
  String? coverImage;
  String? maritalStatus;
  String? hometown;
  String? address;

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) =>
      ProfileUserModel(
        id: json['id'],
        userId: json['userId'],
        name: json["name"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"],
        password: json["password"],
        email: json["email"],
        createdOn: json['createdOn'],
        modifiedOn: json['modifiedOn'],
        status: json['status'],
        role: json['role'],
        enabled: json['enabled'],
        verificationToken: json['verificationToken'],
        mobileNo: json['mobileNo'],
        otp: json['otp'],
        profileImage: json["profileImage"],
        uniqueUserID: json['uniqueUserID'],
        address: json["address"],
        hometown: json["hometown"],
        maritalStatus: json["maritalStatus"],
        coverImage: json["coverImage"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "password": password,
        "email": email,
        "createdOn": createdOn,
        "modifiedOn": modifiedOn,
        "status": status,
        "role": role,
        "enabled": enabled,
        "verificationToken": verificationToken,
        "mobileNo": mobileNo,
        "otp": otp,
        "profileImage": profileImage,
        "uniqueUserID": uniqueUserID,
        "address": address,
        "hometown": hometown,
        "maritalStatus": maritalStatus,
        "coverImage": coverImage
      };
}
