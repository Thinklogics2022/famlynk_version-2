import 'dart:convert';

import 'package:famlynk/utils/utils.dart';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static Future<void> resetPassword(String email, String newPassword) async {
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
        print("Password updated successfully");
      } else {
      }
    } catch (e) {
      print("Error occurred while resetting password: $e");
    }
  }
}
