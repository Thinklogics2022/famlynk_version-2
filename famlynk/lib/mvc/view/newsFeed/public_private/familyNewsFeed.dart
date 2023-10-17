import 'package:cached_network_image/cached_network_image.dart';
import 'package:famlynk/mvc/controller/dropDown.dart';
import 'package:famlynk/mvc/model/newsfeed_model/newsFeed_model.dart';
import 'package:famlynk/mvc/view/familyList/mutualConnection.dart';
import 'package:famlynk/mvc/view/newsFeed/comment/comment.dart';
import 'package:famlynk/mvc/view/newsFeed/like/like.dart';
import 'package:famlynk/services/newsFeedService/familyNewsFeed_services.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyNews extends StatefulWidget {
  const FamilyNews({Key? key}) : super(key: key);

  @override
  State<FamilyNews> createState() => _FamilyNewsState();
}

class _FamilyNewsState extends State<FamilyNews> {
  bool isLoaded = false;
  bool isLiked = false;
  late List<String> comments;
  List<NewsFeedModel>? familyNewsFeedList = [];
  ScrollController _scrollController = ScrollController();
  String userId = "";

  @override
  void initState() {
    super.initState();
    _fetchFamilyNewsFeed();
    comments = [];
    fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {}
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _fetchFamilyNewsFeed() async {
    FamilyNewsFeedService familyNewsFeedService = FamilyNewsFeedService();
    try {
      var newsFeedFamily = await familyNewsFeedService.getFamilyNewsFeed();
      setState(() {
        familyNewsFeedList!.addAll(newsFeedFamily!);
        isLoaded = true;
      });
    } catch (e) {
      print('Error fetching family news feed: $e');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      familyNewsFeedList!.clear();
      isLoaded = false;
    });
    await _fetchFamilyNewsFeed();
  }

  void onLikeButtonPressed(int index) async {
    NewsFeedModel myNewsFeeds = familyNewsFeedList![index];
    setState(() {
      if (myNewsFeeds.userLikes.contains(userId)) {
        myNewsFeeds.userLikes.remove(userId);
        myNewsFeeds.like--;
      } else {
        myNewsFeeds.userLikes.add(userId);
        myNewsFeeds.like++;
      }
    });
    LikesNewsFeed likesNewsFeed = LikesNewsFeed();
    try {
      await likesNewsFeed.handleLike(myNewsFeeds, () {});
    } catch (e) {
      setState(() {
        if (myNewsFeeds.userLikes.contains(userId)) {
          myNewsFeeds.userLikes.remove(userId);
          myNewsFeeds.like--;
        } else {
          myNewsFeeds.userLikes.add(userId);
          myNewsFeeds.like++;
        }
      });
      print('Error liking news feed: $e');
    }
  }

  ImageProvider<Object>? _getProfileImage(NewsFeedModel newsFeedModel) {
    final String? profilePicture = newsFeedModel.profilePicture;
    if (profilePicture != null && profilePicture.isNotEmpty) {
      return CachedNetworkImageProvider(profilePicture);
    }
    return null;
    //   if (profilePicture == null || profilePicture.isEmpty) {
    //     return AssetImage('assets/images/FL01.png');
    //   } else {
    //     return CachedNetworkImageProvider(profilePicture);
    //   }
    // }
  }

  Future<void> addComment(int index, String comment) async {
    setState(() {
      comments.add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: isLoaded
            ? familyNewsFeedList!.isEmpty
                ? Center(
                    child: Text(
                      'No FamilyNews are available.',
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: familyNewsFeedList!.length,
                    itemBuilder: (context, index) {
                      NewsFeedModel newsFeed = familyNewsFeedList![index];
                      DateTime? utcDateTime =
                          DateTime.parse(newsFeed.createdOn.toString());
                      DateTime localDateTime = utcDateTime.toLocal();

                      String formattedDate = DateFormat('MMMM-dd-yyyy  hh:mm a')
                          .format(localDateTime);
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MutualConnection(
                                            uniqueUserId:
                                                newsFeed.uniqueUserID)));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: backgroundColors[
                                      index % backgroundColors.length],
                                  backgroundImage: _getProfileImage(newsFeed),
                                  child: _getProfileImage(newsFeed) == null
                                      ? Text(
                                          newsFeed.name.isNotEmpty
                                              ? newsFeed.name[0].toUpperCase()
                                              : "?",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(newsFeed.name),
                                subtitle: Text(formattedDate),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                newsFeed.description!,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            if (newsFeed.photo != null &&
                                newsFeed.photo!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhotoViewGallery.builder(
                                          itemCount: 1,
                                          builder: (context, index) {
                                            return PhotoViewGalleryPageOptions(
                                              imageProvider:
                                                  CachedNetworkImageProvider(
                                                      newsFeed.photo!),
                                              minScale: PhotoViewComputedScale
                                                      .contained *
                                                  0.3,
                                              maxScale: PhotoViewComputedScale
                                                      .covered *
                                                  1.8,
                                              initialScale:
                                                  PhotoViewComputedScale
                                                      .contained,
                                              heroAttributes:
                                                  PhotoViewHeroAttributes(
                                                      tag: newsFeed.photo!),
                                            );
                                          },
                                          backgroundDecoration: BoxDecoration(
                                            color: Colors.black,
                                          ),
                                          pageController: PageController(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      height: 250,
                                      width: 500,
                                      child: CachedNetworkImage(
                                        imageUrl: newsFeed.photo!,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),
                                ),
                              ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => onLikeButtonPressed(index),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            newsFeed.userLikes.contains(userId)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 25,
                                            color: newsFeed.userLikes
                                                    .contains(userId)
                                                ? HexColor('#FF6F20')
                                                : null,
                                          ),
                                          SizedBox(width: 5),
                                          Text(newsFeed.like.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScreen(
                                                    name: newsFeed.name,
                                                    newsFeedId:
                                                        newsFeed.newsFeedId,
                                                    profilePicture: newsFeed
                                                        .profilePicture
                                                        .toString(),
                                                  )));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.chat_bubble_outline),
                                        SizedBox(width: 6),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("Liked by "),
                                  Text(
                                    "gokul ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('and '),
                                  Text(
                                    "others",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 8),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Gokul',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: 'qwdefgfd',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
