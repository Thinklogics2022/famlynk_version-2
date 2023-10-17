import 'dart:convert';
import 'package:famlynk/mvc/model/familyMembers/famlist_modelss.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/utils.dart';

class MutualService {
  String userId = "";
  String token = '';

  Future<List<FamListModel>> mutualService(String uniqueUserId) async {
    var urls = FamlynkServiceUrl.mutualConnection;
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString("token") ?? '';
    var url = urls + userId + "/" + uniqueUserId;
    print("urls : $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print("mutual connection : ${response.body}");

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          List<FamListModel> familyList =
              jsonData.map((json) => FamListModel.fromJson(json)).toList();
          return familyList;
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
