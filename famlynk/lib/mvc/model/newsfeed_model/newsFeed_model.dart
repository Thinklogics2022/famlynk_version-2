import 'dart:convert';

NewsFeedModel publicNewsFeedModelFromJson(String str) =>
    NewsFeedModel.fromJson(json.decode(str));

String publicNewsFeedModelToJson(NewsFeedModel data) =>
    json.encode(data.toJson());

class NewsFeedModel {
  String newsFeedId;
  String userId;
  String? profilePicture;
  // String video;
  String? photo;
  int like;
  String? description;
  String name;
  DateTime createdOn;
  List<String> userLikes;
  List<String>? userLikeNames;
  String uniqueUserID;
  List<dynamic>? mutualConnection;

  NewsFeedModel({
    required this.newsFeedId,
    required this.userId,
    this.profilePicture,
    // required this.video,
    required this.photo,
    required this.like,
    this.description,
    required this.name,
    required this.createdOn,
    required this.userLikes,
    this.userLikeNames,
    required this.uniqueUserID,
    this.mutualConnection,
  });

  factory NewsFeedModel.fromJson(Map<String, dynamic> json) {
    return NewsFeedModel(
      newsFeedId: json['newsFeedId'],
      userId: json['userId'],
      profilePicture: json['profilePicture'],
      // video: json['video'],
      photo: json['photo'],
      like: json['like'],
      description: json['description'] != null ? json['description'] : '',
      name: json['name'],
      createdOn: DateTime.parse(json['createdOn']),
      userLikes: List<String>.from(json['userLikes']),
      userLikeNames: List<String>.from(json['userLikeNames']),
      uniqueUserID: json['uniqueUserID'],
      mutualConnection: List<dynamic>.from(json['mutualConnection']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newsFeedId': newsFeedId,
      'userId': userId,
      'profilePicture': profilePicture,
      // 'video': video,
      'photo': photo,
      'like': like,
      'description': description,
      'name': name,
      'createdOn': createdOn.toIso8601String(),
      'userLikes': userLikes,
      'userLikeNames': userLikeNames,
      'uniqueUserID': uniqueUserID,
      'mutualConnection': mutualConnection,
    };
  }
}
