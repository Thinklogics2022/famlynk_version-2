import 'dart:convert';

UpdateFamMemberModel updateFamMemberModelFromJson(String str) =>
    UpdateFamMemberModel.fromJson(json.decode(str));

String updateFamMemberModelToJson(UpdateFamMemberModel data) =>
    json.encode(data.toJson());

class UpdateFamMemberModel {
  UpdateFamMemberModel(
      {this.userId,
      this.name,
      this.dob,
      this.image,
      this.relation,
      this.firstLevelRelation,
      this.gender,
      this.mobileNo,
      this.email,
      this.uniqueUserID,
      this.famid,
      this.secondLevelrelation,
      this.thirdLevelrelation,
      this.createdOn,
      this.modifiedOn,
      this.notification,
      this.maritalStatus,
      this.hometown,
      this.address,
      this.isRegisterUser,
      this.side});
  String? userId;
  String? name;
  String? dob;
  String? image;
  String? relation;
  String? firstLevelRelation;
  String? gender;
  String? mobileNo;
  String? email;
  String? uniqueUserID;
  String? secondLevelrelation;
  String? thirdLevelrelation;
  String? famid;
  String? createdOn;
  String? notification;
  String? maritalStatus;
  String? modifiedOn;
  String? hometown;
  String? address;
  String? side;
  bool? isRegisterUser;

  factory UpdateFamMemberModel.fromJson(Map<String, dynamic> json) => UpdateFamMemberModel(
      userId: json["userId"],
      name: json["name"],
      dob: json["dob"],
      image: json["image"],
      relation: json["relation"],
      firstLevelRelation: json["firstLevelRelation"],
      gender: json["gender"],
      mobileNo: json["mobileNo"],
      email: json["email"],
      uniqueUserID: json["uniqueUserID"],
      secondLevelrelation: json["secondLevelrelation"],
      thirdLevelrelation: json["thirdLevelrelation"],
      createdOn: json["createdOn"],
      modifiedOn: json["modifiedOn"],
      notification: json["notification"],
      maritalStatus: json["maritalStatus"],
      hometown: json["hometown"],
      address: json["address"],
      famid: json["famid"],
      side: json["side"],
      isRegisterUser: json["isRegisterUser"]);
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "dob": dob,
        "image": image,
        "relation": relation,
        "firstLevelRelation": firstLevelRelation,
        "gender": gender,
        "mobileNo": mobileNo,
        "email": email,
        "uniqueUserID": uniqueUserID,
        "secondLevelrelation": secondLevelrelation,
        "thirdLevelrelation": thirdLevelrelation,
        "createdOn": createdOn,
        "modifiedOn": modifiedOn,
        "maritalStatus": maritalStatus,
        "notification": notification,
        "hometown": hometown,
        "address": address,
        "famid": famid,
        "isRegisterUser": isRegisterUser,
        "side": side
      };
}

