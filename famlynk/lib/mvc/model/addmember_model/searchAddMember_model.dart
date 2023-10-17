import 'dart:convert';

SearchAddMember searchAddMemberFromJson(String str) =>
    SearchAddMember.fromJson(json.decode(str));
String searchAddMemberToJson(SearchAddMember data) =>
    json.encode(data.toJson());

class SearchAddMember {
  String? famid;
  String? name;
  String? gender;
  String? dob;
  String? email;
  String? userId;
  String? image;
  String? mobileNo;
  String uniqueUserID;
  String? relation;
  String firstLevelRelation;
  String secondLevelRelation;
  String thirdLevelRelation;
  String? maritalStatus;
  String? createdOn;
  String? modifiedOn;
  String? address;
  String? homeTown;
  List<dynamic>? mutualConnection = [];
  Map<String, dynamic>? notification = {};
  String? side;
  bool? isRegisterUser;

  SearchAddMember({
    this.famid,
     this.name,
     this.gender,
     this.dob,
     this.email,
     this.userId,
     this.image,
     this.mobileNo,
    required this.uniqueUserID,
     this.relation,
    required this.firstLevelRelation,
    required this.secondLevelRelation,
    required this.thirdLevelRelation,
    this.maritalStatus,
    this.address,
    this.homeTown,
    this.createdOn,
    this.modifiedOn,
    this.mutualConnection,
    this.notification,
    this.side,
    this.isRegisterUser,
  });
  factory SearchAddMember.fromJson(Map<String, dynamic> json) {
    return SearchAddMember(
        famid: json["famid"],
        name: json["name"],
        gender: json["gender"],
        dob: json["dob"],
        email: json["email"],
        userId: json["userId"],
        image: json["image"],
        mobileNo: json["mobileNo"],
        uniqueUserID: json["uniqueUserID"],
        relation: json["relation"],
        createdOn: json["createdOn"],
        modifiedOn: json["modifiedOn"],
        address: json["address"],
        maritalStatus: json["maritalStatus"],
        homeTown: json["homeTown"],
        firstLevelRelation: json["firstLevelRelation"],
        secondLevelRelation: json["secondLevelRelation"],
        thirdLevelRelation: json["thirdLevelRelation"],
        notification: json['notification'],
        mutualConnection: json['mutualConnection'],
        side: json['side'],
        isRegisterUser: json['isRegisterUser']);
  }
  Map<String, dynamic> toJson() => {
        "famid": famid,
        "name": name,
        "gender": gender,
        "dob": dob,
        "email": email,
        "userId": userId,
        "image": image,
        "mobileNo": mobileNo,
        "uniqueUserID": uniqueUserID,
        "relation": relation,
        "createdOn": createdOn,
        "modifiedOn": modifiedOn,
        "maritalStatus": maritalStatus,
        "address": address,
        "homeTown": homeTown,
        "firstLevelRelation": firstLevelRelation,
        "secondLevelRelation": secondLevelRelation,
        "thirdLevelRelation": thirdLevelRelation,
        'notification': notification,
        'mutualConnection': mutualConnection,
        'side': side,
        'isRegisterUser': isRegisterUser,
      };
}
