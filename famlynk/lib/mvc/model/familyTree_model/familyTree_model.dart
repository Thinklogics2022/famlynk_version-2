import 'dart:convert';

FamilyTreeModel familyTreeModelFromJson(String str) =>
    FamilyTreeModel.fromJson(json.decode(str));

String familyTreeModelToJson(FamilyTreeModel data) => json.encode(data.toJson());

class FamilyTreeModel {
  String? name;
  String? image;
  String? relationShip;
  String? uniqueUserID;
  String? gender;
  String? userId;
  String? fId;
  String? mId;
  String? bId;
  String? sId;
  String? wId;
  String? dId;
  String? sonId;
  String? uId;
  String? gMId;
  String? gFId;
  String? hId;
  String? email;
  String? dob;
  String? number;
  String? side;

  // Constructor
  FamilyTreeModel({
     this.name,
     this.image,
     this.relationShip,
     this.uniqueUserID,
     this.gender,
     this.userId,
     this.fId,
     this.mId,
     this.bId,
     this.sId,
     this.wId,
     this.dId,
     this.sonId,
     this.uId,
     this.gMId,
     this.gFId,
     this.hId,
     this.email,
     this.dob,
     this.number,
     this.side,
  });

  // Factory method to create a FamilyTreeModel object from a json
  factory FamilyTreeModel.fromJson(Map<String, dynamic> json) {
    return FamilyTreeModel(
      name: json['name'],
      image: json['image'],
      relationShip: json['relationShip'],
      uniqueUserID: json['uniqueUserID'],
      gender: json['gender'],
      userId: json['userId'],
      fId: json['fId'],
      mId: json['mId'],
      bId: json['bId'],
      sId: json['sId'],
      wId: json['wId'],
      dId: json['dId'],
      sonId: json['sonId'],
      uId: json['uId'],
      gMId: json['gMId'],
      gFId: json['gFId'],
      hId: json['hId'],
      email: json['email'],
      dob: json['dob'],
      number: json['number'],
      side: json['side'],
    );
  }

  // Method to convert a FamilyTreeModel object to a json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'relationShip': relationShip,
      'uniqueUserID': uniqueUserID,
      'gender': gender,
      'userId': userId,
      'fId': fId,
      'mId': mId,
      'bId': bId,
      'sId': sId,
      'wId': wId,
      'dId': dId,
      'sonId': sonId,
      'uId': uId,
      'gMId': gMId,
      'gFId': gFId,
      'hId': hId,
      'email': email,
      'dob': dob,
      'number': number,
      'side': side,
    };
  }
}