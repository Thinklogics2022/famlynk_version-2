class Suggestion {
  String id;
  String userId;
  String name;
  String gender;
  String dateOfBirth;
  String password;
  String email;
  DateTime? createdOn;
  DateTime? modifiedOn;
  bool? status;
 
  bool? enabled;
  String? verificationToken;
  String? mobileNo;
  String? otp;
  String? profileImage;
  String uniqueUserID;
  String? coverImage;
  String? maritalStatus;
  String? hometown;
  String? address;

  Suggestion({
    required this.id,
    required this.userId,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.password,
    required this.email,
    required this.createdOn,
    this.modifiedOn,
    required this.status,
    
    required this.enabled,
    required this.verificationToken,
    this.mobileNo,
    this.otp,
    this.profileImage,
    required this.uniqueUserID,
    this.coverImage,
    this.maritalStatus,
    this.hometown,
    this.address,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json["id"].toString(),
      userId: json["userId"].toString(),
      name: json["name"].toString(),
      gender: json["gender"],
      dateOfBirth: json["dateOfBirth"].toString(),
      password: json["password"].toString(),
      email: json["email"].toString(),
      createdOn: json["createdOn"] != null
          ? DateTime.parse(json["createdOn"].toString())
          : null,
      modifiedOn: json["modifiedOn"] != null
          ? DateTime.parse(json["modifiedOn"].toString())
          : null,
      status: json["status"] as bool?,
      enabled: json["enabled"] as bool?,
      verificationToken: json["verificationToken"]?.toString(),
      mobileNo: json["mobileNo"]?.toString(),
      otp: json["otp"]?.toString(),
      profileImage: json["profileImage"]?.toString(),
      uniqueUserID: json["uniqueUserID"].toString(),
      coverImage: json["coverImage"]?.toString(),
      maritalStatus: json["maritalStatus"]?.toString(),
      hometown: json["hometown"]?.toString(),
      address: json["address"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "password": password,
        "email": email,
        "createdOn": createdOn?.toIso8601String(),
        "modifiedOn": modifiedOn?.toIso8601String(),
        "status": status,
        "enabled": enabled,
        "verificationToken": verificationToken,
        "mobileNo": mobileNo,
        "otp": otp,
        "profileImage": profileImage,
        "uniqueUserID": uniqueUserID,
        "coverImage": coverImage,
        "maritalStatus": maritalStatus,
        "hometown": hometown,
        "address": address,
      };
}
