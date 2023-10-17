import 'dart:convert';
import 'package:famlynk/mvc/model/newsfeed_model/newsFeed_model.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FamilyNewsFeedService {
  String userId = '';
  String token = '';
  Future<List<NewsFeedModel>?> getFamilyNewsFeed() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? '';

    var url = FamlynkServiceUrl.getFamilyNewsFeed + userId;
    try {
      final response = await http.get(
        Uri.parse('$url'), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          List<NewsFeedModel> familyNewsFeed = jsonData.map((data) {
            if (data is Map<String, dynamic>) {
              return NewsFeedModel.fromJson(data);
            } else {
              throw Exception('Invalid data format in response');
            }
          }).toList();
          return familyNewsFeed;
        } else {
          throw Exception('Invalid response format: expected a JSON array');
        }
      } else {
        throw Exception('Failed to fetch data from the backend');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
