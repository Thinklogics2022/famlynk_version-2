import 'dart:convert';
import 'package:famlynk/mvc/model/addmember_model/addMember_model.dart';
import 'package:http/http.dart' as http;
import 'package:famlynk/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMemberService {
  String email = '';
  String token = '';

  Future<dynamic> addMemberPost(AddMemberModel addMemberModel) async {
    var urls = FamlynkServiceUrl.addMember;
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    token = prefs.getString('token') ?? '';

    final url = Uri.parse(urls + email);
    print("add member ${url}");
    Map<String, dynamic> requestBody = {
      "name": addMemberModel.name,
      "gender": addMemberModel.gender,
      "mobileNo": addMemberModel.mobileNo,
      "email": addMemberModel.email,
      // "relation" : addMemberModel.relation,
      "firstLevelRelation": addMemberModel.firstLevelRelation,
      "dob": addMemberModel.dob,
      "image": addMemberModel.image,
      "userId": addMemberModel.userId,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('POST request successful');
        print("requestBody : ${requestBody}");
        print("add : ${response.body}");

        return response.body;
      } else {
        print('POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
