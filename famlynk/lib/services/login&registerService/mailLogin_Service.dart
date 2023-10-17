import 'dart:convert';
import 'package:famlynk/mvc/model/login_model/mailLogin_model.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MailLoginServices {
  Future<dynamic> authenticate(UserLogin userData) async {
    Map<String, dynamic> userObj = {
      "userName": userData.userName,
      "password": userData.password,
    };
    try {
      var response = await http.post(
        Uri.parse(FamlynkServiceUrl.login),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(userObj),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final name = responseData['name'];
        final userId = responseData['userId'];
        final email = responseData['email'];
        final token = responseData['token'];
        final uniqueUserID = responseData['uniqueUserID'];
        await saveResponseToStorage(name, userId, email, token, uniqueUserID);
        print("ttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
        print(userId);
        print(token);
        print(uniqueUserID);
      } else {
        throw Exception(
            'Failed to load API Data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to connect to the server.');
    }
  }

  Future<void> saveResponseToStorage(
    String name,
    String userId,
    String email,
    String token,
    String uniqueUserID,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('userId', userId);
    await prefs.setString('email', email);
    await prefs.setString('token', token);
    await prefs.setString('uniqueUserID', uniqueUserID);
  }
}
