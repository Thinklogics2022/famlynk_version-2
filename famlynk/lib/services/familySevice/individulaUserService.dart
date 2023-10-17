import 'dart:convert';

import 'package:famlynk/mvc/model/familyMembers/famlist_modelss.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../mvc/model/familyMembers/individualUserModel.dart';

class IndividulaUserService {
  String token = '';
  Future<dynamic> individulaUserService(String uniqueUserId) async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token") ?? '';
    try {
      http.Response response;
      response = await http.get(
          Uri.parse(FamlynkServiceUrl.individualUser + uniqueUserId),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      dynamic returnObject;
      if (response.statusCode == 200) {
        print("individual User${response.body}");
        returnObject = individualUserModelFromJson(response.body);
      }
      return returnObject;
    } catch (e) {
      print(e);
    }
  }

  Future<List<FamListModel>> familyService(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token") ?? '';
    try {
      http.Response response;
      response = await http.get(
        Uri.parse(FamlynkServiceUrl.getFamilyMember + userId),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      List<FamListModel> familyMembers = [];
      if (response.statusCode == 200) {
        print("familyService${response.body}");
        List<dynamic> jsonList = json.decode(response.body);
        familyMembers =
            jsonList.map((item) => FamListModel.fromJson(item)).toList();
      }
      print(familyMembers);
      return familyMembers;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

  

