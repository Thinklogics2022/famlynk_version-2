import 'dart:convert';

IndividualUserModel individualUserModelFromJson(String str) =>
    IndividualUserModel.fromJson(json.decode(str));

String individualUserModelToJson(IndividualUserModel data) =>
    json.encode(data.toJson());

class IndividualUserModel {
  String? famid;
  String? userId;
  String? name;
  String? dateOfBirth;
  String? profileImage;
  String? relation;
  String? gender;
  String? mobileNo;
  String? email;
  String? uniqueUserID;
  bool? isRegisterUser;
  IndividualUserModel({
    this.famid,
    this.userId,
    this.name,
    this.dateOfBirth,
    this.profileImage,
    this.relation,
    this.gender,
    this.mobileNo,
    this.email,
    this.uniqueUserID,
    this.isRegisterUser
  });

  factory IndividualUserModel.fromJson(Map<String, dynamic> json) =>
      IndividualUserModel(
        famid: json["famid"],
        userId: json["userId"],
        name: json["name"],
        dateOfBirth: json["dateOfBirth"],
        profileImage: json["profileImage"],
        relation: json["relation"],
        gender: json["gender"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        uniqueUserID: json["uniqueUserID"],
        isRegisterUser : json['isRegisterUser']
      );

  Map<String, dynamic> toJson() => {
        "famid": famid,
        "userId": userId,
        "name": name,
        "dateOfBirth": dateOfBirth,
        "profileImage": profileImage,
        "relation": relation,
        "gender": gender,
        "mobileNo": mobileNo,
        "email": email,
        "uniqueUserID": uniqueUserID,
        "isRegisterUser" : isRegisterUser
      };
}
