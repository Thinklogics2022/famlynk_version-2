import 'dart:convert';
import 'package:famlynk/mvc/model/familyTree_model/familyTree_model.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FamilyTreeServices {
  String userId = '';
  String token = '';
  String uniqueUserID = "";

  Future<List<FamilyTreeModel>> getAllFamilyTree(String level) async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getString('userId');
    userId = userIdFromPrefs ?? '';
    token = prefs.getString('token') ?? '';
    uniqueUserID = prefs.getString('uniqueUserID') ?? '';
    var url = FamlynkServiceUrl.familyTree +
        userId +
        '/' +
        uniqueUserID +
        '/' +
        level;
    print("Family tree url : ${url}");
    try {
      final response = await http.get(
        Uri.parse('$url'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData is List) {
          var familyTree = List<FamilyTreeModel>.from(
            jsonData.map((i) => FamilyTreeModel.fromJson(i)),
          );
          print("family tree : ${response.body}");
          return familyTree;
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
