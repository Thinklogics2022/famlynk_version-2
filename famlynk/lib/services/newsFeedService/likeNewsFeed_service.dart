import 'package:famlynk/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LikeNewsFeedService {
  Future<void> likeNewsFeed(String newsFeedId) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? token = prefs.getString('token');

    userId ??= '';
    token ??= '';

    var url = FamlynkServiceUrl.like;
    try {
      final response = await http.get(
        Uri.parse('$url$userId/$newsFeedId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        // body: {'newsFeedId': newsFeedId},
      );
      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to like news feed');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
