import 'package:famlynk/mvc/model/newsfeed_model/newsFeed_model.dart';
import 'package:famlynk/services/newsFeedService/likeNewsFeed_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikesNewsFeed {
  String userId = '';
  Future<void> handleLike(
      NewsFeedModel newsFeedModel, Function() setStateCallback) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    try {
      await LikeNewsFeedService().likeNewsFeed(newsFeedModel.newsFeedId);
      setStateCallback();
    } catch (e) {
      print(e);
    }
  }
}
