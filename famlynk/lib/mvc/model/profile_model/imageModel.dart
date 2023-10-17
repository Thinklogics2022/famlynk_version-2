import 'dart:convert';

ImageModel registerModelFromJson(String str) =>
    ImageModel.fromJson(json.decode(str));

String registerModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  ImageModel({this.name, this.profilePicture, this.userId});

  String? name;
  String? userId;
  String? profilePicture;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
      name: json["name"],
      profilePicture: json["profilePicture"],
      userId: json["userId"]);
      
  Map<String, dynamic> toJson() => {
        "name": name,
        "userId": userId,
        "profilePicture": profilePicture,
      };
}
