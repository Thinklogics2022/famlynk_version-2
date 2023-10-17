// To parse this JSON data, do
//
//     final AddImageNewsFeedMode = AddImageNewsFeedModeFromJson(jsonString);

import 'dart:convert';

AddImageNewsFeedMode addImageNewsFeedModeFromJson(String str) =>
    AddImageNewsFeedMode.fromJson(json.decode(str));

String addImageNewsFeedModeToJson(AddImageNewsFeedMode data) =>
    json.encode(data.toJson());

class AddImageNewsFeedMode {
  String? newsFeedId;
  String? userId;
  String? profilePicture;
  String? photo;
  String? description;
  String? name;
  String? uniqueUserID;

  AddImageNewsFeedMode({
    this.newsFeedId,
    this.userId,
    this.profilePicture,
    this.photo,
    this.description,
    this.name,
    this.uniqueUserID,
  });

  factory AddImageNewsFeedMode.fromJson(Map<String, dynamic> json) =>
      AddImageNewsFeedMode(
        newsFeedId: json["newsFeedId"],
        userId: json["userId"],
        profilePicture: json["profilePicture"],
        photo: json["photo"],
        description: json["description"],
        name: json["name"],
        uniqueUserID: json["uniqueUserID"],
      );

  Map<String, dynamic> toJson() => {
        "newsFeedId": newsFeedId,
        "userId": userId,
        "profilePicture": profilePicture,
        "photo": photo,
        "description": description,
        "name": name,
        "uniqueUserID": uniqueUserID,
      };
}
