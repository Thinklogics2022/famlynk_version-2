import 'dart:convert';

import 'package:famlynk/mvc/model/login_model/register_model.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordService {
  Future<dynamic> getEmail(String email) async {
    try {
      http.Response response;
      response = await http
          .get(Uri.parse(FamlynkServiceUrl.verifyEmail + email), headers: {
        'Content-Type': 'application/json',
      });
      dynamic returnObject;
      if (response.statusCode == 200) {
        print(response.body);
        returnObject = registerModelFromJson(response.body);
      }
      return returnObject;
    } catch (e) {
      print(e);
    }
  }

 Future<dynamic> getOTP(String otp) async {
  try {
    http.Response response;
    response = await http.get(
      Uri.parse(FamlynkServiceUrl.verifyOtpforPswd + otp),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    dynamic returnObject;
    if (response.body == "OTP is correct") {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData is String && jsonData == 'OTP is correct') {
          returnObject = jsonData;
        } else {
          returnObject = registerModelFromJson(response.body);
        }
      } catch (e) {
        returnObject = response.body;
      }
    } else {
      returnObject = "Error: ${response.statusCode}";
    }

    return returnObject;
  } catch (e) {
    print(e);
    return null;
  }
}

  Future<void> forgetPassword(String email, String newPassword) async {
    final urls = FamlynkServiceUrl.updatePassword;
    final url = Uri.parse('$urls$email');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'password': newPassword}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        print("Password updated successfully");
      } else {}
    } catch (e) {
      print("Error occurred while resetting password: $e");
    }
  }
}
