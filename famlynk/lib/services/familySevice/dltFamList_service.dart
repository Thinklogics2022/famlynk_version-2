import 'package:famlynk/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DltMemberService {
  String userId = "";
  String token = "";
  Future<dynamic> deleteFamilyMember(String userId, String uniqueUserID) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? '';

    Map<String, dynamic> mapObj = {
      "userId": userId,
      "uniqueUserID": uniqueUserID
    };
    print(mapObj);

    try {
      var response = await http.delete(
        Uri.parse(FamlynkServiceUrl.deleteFamilyMember +
            "$userId" +
            "/" +
            "$uniqueUserID"),
        headers: {
          "Content-Type": "application/json ; charset=UTF-8",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        print("Deleted sucessfuly");
        return response.body;
      }
    } catch (e) {
      print("Member not deleted ");
    }
  }
}
