import 'dart:convert';
import 'package:famlynk/mvc/model/familyMembers/famlist_modelss.dart';
import 'package:famlynk/mvc/model/profile_model/notificationModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/utils.dart';

class NotificationService {
  String uniqueUserID = "";
  String token = '';
  String userId = '';
  Future<List<NotificationModel>> notificationService() async {
    var urls = FamlynkServiceUrl.notification;
    final prefs = await SharedPreferences.getInstance();
    uniqueUserID = prefs.getString('uniqueUserID') ?? '';
    token = prefs.getString("token") ?? '';
    var url = urls + uniqueUserID;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      print("object");
      print("notification url ${url}");

      if (response.statusCode == 200) {
        print("notification (show): ${response.body}");

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          List<NotificationModel> notifications =
              jsonData.map((json) => NotificationModel.fromJson(json)).toList();
          return notifications;
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

  Future<dynamic> acceptNotificationService(
      String fromUniqueUserId, String relation, String toUniqueUserId) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString("token") ?? '';

    try {
      http.Response response;
      response = await http.get(
          Uri.parse(FamlynkServiceUrl.acceptNotification +
              userId +
              "/" +
              fromUniqueUserId +
              "/" +
              relation +
              "/" +
              toUniqueUserId),
          headers: {'Authorization': 'Bearer $token'});
      dynamic returnObject;

      if (response.statusCode == 200) {
        print("profile accept : ${response.body}");
        returnObject = famListModelFromJson(response.body);
      }
      return returnObject;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> declineNotificationService(
      String fromUserId, String toUniqueUserId) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString("token") ?? '';

    try {
      http.Response response;
      response = await http.delete(
          Uri.parse(FamlynkServiceUrl.declineNotification +
              fromUserId +
              "/" +
              toUniqueUserId),
          headers: {'Authorization': 'Bearer $token'});
      dynamic returnObject;

      if (response.statusCode == 200) {
        print("profile (decline): ${response.body}");
        returnObject = famListModelFromJson(response.body);
      }
      return returnObject;
    } catch (e) {
      print(e);
    }
  }
}
