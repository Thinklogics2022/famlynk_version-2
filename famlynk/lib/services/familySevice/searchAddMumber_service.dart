import 'dart:convert';
import 'package:famlynk/mvc/model/addmember_model/searchAddMember_model.dart';
import 'package:http/http.dart' as http;
import 'package:famlynk/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchAddMemberService {
  String userId = '';
  String token = '';

  Future<dynamic> searchAddMemberPost(
      SearchAddMember searchAddMemberModel) async {
    var urls = FamlynkServiceUrl.searchAddMember;
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? '';
    final url =
        Uri.parse(urls + userId + "/" + searchAddMemberModel.uniqueUserID);

    Map<String, dynamic> requestBody = {
      // "famid": searchAddMemberModel.famid,
      // "name": searchAddMemberModel.name,
      // "gender": searchAddMemberModel.gender,
      // "dob": searchAddMemberModel.dob,
      // "email": searchAddMemberModel.email,
      // "userId": searchAddMemberModel.userId,
      // "image": searchAddMemberModel.image,
      // "mobileNo": searchAddMemberModel.mobileNo,
      // "uniqueUserID": searchAddMemberModel.uniqueUserID,
      // "relation": searchAddMemberModel.relation,
      "firstLevelRelation": searchAddMemberModel.firstLevelRelation,
      "secondLevelRelation": searchAddMemberModel.secondLevelRelation,
      "thirdLevelRelation": searchAddMemberModel.thirdLevelRelation,
    };
    try {
      print(url);
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print('POST request successful');
        print("search${response.body}");
        return response.body;
      } else {
        print('POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> fetchSecondLevelRelations(
      String firstLevelRelation) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? '';
    var url = FamlynkServiceUrl.secondLevelRelation + firstLevelRelation;
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List<dynamic>) {
        return data.map((relation) => relation.toString()).toList();
      } else {
        print('Invalid response format for second-level relations.');
        throw Exception('Invalid response format for second-level relations.');
      }
    } else {
      print('Failed to fetch second-level relations: ${response.statusCode}');
      throw Exception('Failed to fetch second-level relations');
    }
  }

  Future<List<String>> fetchthirdLevelRelations(
      String secondLevelRelation) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? '';
    var url = FamlynkServiceUrl.thirdLevelRelation + secondLevelRelation;
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List<dynamic>) {
        return data.map((relation) => relation.toString()).toList();
      } else {
        print('Invalid response format for third-level relations.');
        throw Exception('Invalid response format for third-level relations.');
      }
    } else {
      print('Failed to fetch third-level relations: ${response.statusCode}');
      throw Exception('Failed to fetch third-level relations');
    }
  }
}
