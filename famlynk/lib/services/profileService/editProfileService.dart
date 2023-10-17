import 'dart:convert';
import 'package:famlynk/mvc/model/profile_model/imageModel.dart';
import 'package:famlynk/mvc/model/profile_model/profileModel.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileService {
  String userId = '';
  String token = "";
  Future<dynamic> editProfile(ProfileUserModel data) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? "";
    Map<String, dynamic> editProfile = {
      "id": data.id,
      "name": data.name,
      "gender": data.gender,
      "email": data.email,
      "address": data.address,
      "maritalStatus": data.maritalStatus,
      "mobileNo": data.mobileNo,
      "profileImage": data.profileImage,
      "dateOfBirth": data.dateOfBirth,
      "hometown": data.hometown,
      "userId": data.userId,
      "uniqueUserID": data.uniqueUserID,
      "password": data.password,
      "createdOn": data.createdOn,
      "modifiedOn": data.modifiedOn,
      "status": data.status,
      "role": data.role,
      "enabled": data.enabled,
      "verificationToken": data.verificationToken,
      "otp": data.otp,
      "coverImage": data.coverImage
    };
    try {
      var response = await http.put(
        Uri.parse(FamlynkServiceUrl.editProfile + data.userId.toString()),
        body: jsonEncode(editProfile),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        print("Update request failed with : ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> imageService(ImageModel data) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? "";
    Map<String, dynamic> image = {
      "name": data.name,
      "profilePicture": data.profilePicture,
      "userId": data.userId,
    };
    try {
      var response = await http.put(
        Uri.parse(FamlynkServiceUrl.imgUrl + userId),
        body: jsonEncode(image),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        print("Update request failed with : ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }
}
