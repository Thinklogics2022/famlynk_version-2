import 'dart:convert';
import 'package:famlynk/mvc/model/familyMembers/updateFamMember_model.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class UpdateFamListService {
  String token = "";

  Future<dynamic> updateFamMember(UpdateFamMemberModel data) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    Map<String, dynamic> updatefam = {
      "name": data.name,
      "gender": data.gender,
      "mobileNo": data.mobileNo,
      "email": data.email,
      // "relation": "",
      "dob": data.dob,
      "image": data.image,
      "famid": data.famid,
      "userId": data.userId,
      "firstLevelRelation": data.firstLevelRelation,
      "uniqueUserID": data.uniqueUserID
    };
    var url = FamlynkServiceUrl.updateFamilyMember + data.famid.toString();
    try {
      var response = await http.put(
        Uri.parse(url),
        body: jsonEncode(updatefam),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print(updatefam);
      print("Upadte : ${url}");
      if (response.statusCode == 200 || response.statusCode == 202) {
        print("update : ${response.body}");
        print(data.famid);
        return response.body;
      } else {
        print("Update request failed with : ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }
}
