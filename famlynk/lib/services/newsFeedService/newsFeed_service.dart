import 'dart:convert';

import 'package:famlynk/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewsFeedService {
  String token = '';

  Future<void> postNewsFeed(Map<String, dynamic> postData) async {
  var postNewsFeedUrl = FamlynkServiceUrl.postNewsFeed;
  final prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token') ?? '';
  postData.removeWhere((key, value) => value == '' || value == null);

  try {
    final response = await http.post(
      Uri.parse(postNewsFeedUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode(postData),
    );
    if (response.statusCode == 200) {
      print('News feed posted successfully');
    } else {
      print('Failed to post news feed');
    }
  } catch (e) {
    print('Exception occurred while posting news feed: $e');
  }
}

}
