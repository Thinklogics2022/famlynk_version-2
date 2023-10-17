
import 'package:famlynk/mvc/model/profile_model/profileModel.dart';
import 'package:famlynk/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileUserService {
  String userId = '';
  String token = '';
  Future<dynamic> fetchMembersByUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString("token") ?? '';
    try {
      http.Response response;
      response = await http.get(
          Uri.parse(FamlynkServiceUrl.profileUser + userId),
          headers: {'Authorization': 'Bearer $token'});
      dynamic returnObject;
      if (response.statusCode == 200) {
        print("profile : ${response.body}");
        returnObject = profileUserModelFromJson(response.body);
      }
      return returnObject;
    } catch (e) {
      print(e);
    }
  }
}
