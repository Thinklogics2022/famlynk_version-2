import 'dart:convert';
import 'package:famlynk/mvc/model/login_model/register_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/utils.dart';

class RegisterService {
  Future<dynamic> addRegister(RegisterModel registerModel) async {
    Map<String, dynamic> obj1 = {
      "id": registerModel.id,
      "userId": registerModel.userId,
      "uniqueUserID": registerModel.uniqueUserID,
      "name": registerModel.name,
      "gender": registerModel.gender,
      "dateOfBirth": registerModel.dateOfBirth,
      "password": registerModel.password,
      "email": registerModel.email,
      "profileImage": registerModel.profileImage,
      "mobileNo": registerModel.mobileNo,
      "address": registerModel.address,
      "hometown": registerModel.hometown,
      "maritalStatus": registerModel.maritalStatus,
      "coverImage": registerModel.coverImage,
      "otp": registerModel.otp,
      
      "verificationToken": registerModel.verificationToken
    };
    try {
      var response = await http.post(
        Uri.parse(FamlynkServiceUrl.createUser),
        body: jsonEncode(obj1),
        headers: {"Content-Type": "application/json ; charset=UTF-8"},
      );
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final userId = responseData['userId'];
                final uniqueUserID = responseData['uniqueUserID'];

        await saveResponseToStorage(userId, uniqueUserID);
        print("object");
        print("Reg ${userId}");
         print("Reg ${uniqueUserID}");
      }
      print("Register ${response.body}");

      return response.body;
    } catch (e) {
      print("Reg error ${e}");
      throw Exception(' Register : Failed to load API Data');
    }
  }

  Future<void> saveResponseToStorage(String userId, uniqueUserId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId );
  }
}
