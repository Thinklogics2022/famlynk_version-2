

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    String? id;
    String? fromUserId;
    String? toUniqueUserId;
    String? fromName;
    String? toName;
    String? relation;
    String? status;
    String? email;
    String? fromUniqueUserId;
    dynamic profileImage;
    String? isUsed;

    NotificationModel({
        this.id,
        this.fromUserId,
        this.toUniqueUserId,
        this.fromName,
        this.toName,
        this.relation,
        this.status,
        this.email,
        this.fromUniqueUserId,
        this.profileImage,
        this.isUsed,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        fromUserId: json["fromUserId"],
        toUniqueUserId: json["toUniqueUserID"],
        fromName: json["fromName"],
        toName: json["toName"],
        relation: json["relation"],
        status: json["status"],
        email: json["email"],
        fromUniqueUserId: json["fromUniqueUserID"],
        profileImage: json["profileImage"],
        isUsed: json["isUsed"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fromUserId": fromUserId,
        "toUniqueUserID": toUniqueUserId,
        "fromName": fromName,
        "toName": toName,
        "relation": relation,
        "status": status,
        "email": email,
        "fromUniqueUserID": fromUniqueUserId,
        "profileImage": profileImage,
        "isUsed": isUsed,
    };
}
