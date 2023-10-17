import 'dart:convert';
import 'package:famlynk/mvc/model/newsfeed_model/addNewsFeed_model.dart';
import 'package:famlynk/mvc/model/newsfeed_model/newsFeed_model.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyTimeLineService {
  String userId = "";
  String token = '';
  String uniqueUserID = "";

  Future<List<NewsFeedModel>> getMyTimeLine() async {
    var urls = FamlynkServiceUrl.myNewsFeed;
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString("token") ?? '';
    uniqueUserID = prefs.getString("uniqueUserID") ?? '';
    try {
      final response = await http.get(
        Uri.parse(urls + userId + "/" + uniqueUserID),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          List<NewsFeedModel> PhotoList =
              jsonData.map((json) => NewsFeedModel.fromJson(json)).toList();
          return PhotoList;
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

  Future<dynamic> editMyTimeLine(AddImageNewsFeedMode editMyTimeLine) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? '';

    Map<String, dynamic> obj1 = {
      'newsFeedId': editMyTimeLine.newsFeedId,
      'description': editMyTimeLine.description,
      'photo':editMyTimeLine.photo,
    };

    var url =
        FamlynkServiceUrl.myNewsFeedEdit + editMyTimeLine.newsFeedId.toString();
    try {
      final response = await http.put(
        Uri.parse('$url'),
        headers: {
          'Authorization': 'Bearer $token',
          'content-Type': 'application/json'
        },
        body: jsonEncode(obj1),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to Edit MyTimeLine');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<dynamic> deleteMyTimeLine(String newsFeedId) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? '';

    var url = FamlynkServiceUrl.myNewsFeedDelete;
    try {
      var response = await http.delete(
        Uri.parse(url + userId + "/" + newsFeedId),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception(
            'Failed to Delete newsFeed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("FewsFeed not deleted ");
    }
  }
}
