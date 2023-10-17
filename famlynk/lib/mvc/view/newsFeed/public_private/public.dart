// ignore: unused_import
import 'package:famlynk/mvc/controller/dropDown.dart';
import 'package:famlynk/mvc/view/familyList/mutualConnection.dart';
import 'package:famlynk/mvc/view/newsFeed/like/like.dart';
import 'package:flutter/material.dart';
import 'package:famlynk/mvc/model/newsfeed_model/newsFeed_model.dart';
import 'package:famlynk/mvc/view/newsFeed/comment/comment.dart';
import 'package:famlynk/services/newsFeedService/publicNewsFeed_service.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicNews extends StatefulWidget {
  const PublicNews({Key? key}) : super(key: key);

  @override
  State<PublicNews> createState() => _PublicNewsState();
}

class _PublicNewsState extends State<PublicNews> {
  bool isLoaded = false;
  int pageNumber = 0;
  int pageSize = 20;
  bool isLiked = false;
  int LikedCount = 0;
  late List<String> comments;
  List<NewsFeedModel>? publicNewsFeedList = [];
  ScrollController _scrollController = ScrollController();
  String userId = "";

  @override
  void initState() {
    super.initState();
    fetchData();
    comments = [];
    _scrollController.addListener(_onScroll);
    _handleRefresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      loadMoreSuggestions();
    }
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> fetchPublicNewsFeed(int pageNumber, int pageSize) async {
    PublicNewsFeedService publicNewsFeedService = PublicNewsFeedService();
    try {
      var newsFeedPublic =
          await publicNewsFeedService.getPublicNewsFeed(pageNumber, pageSize);
      setState(() {
        publicNewsFeedList!.addAll(newsFeedPublic);
        isLoaded = true;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void loadMoreSuggestions() {
    setState(() {
      pageNumber++;
    });
    fetchPublicNewsFeed(pageNumber, pageSize);
  }

  void onLikeButtonPressed(int index) async {
    NewsFeedModel myNewsFeeds = publicNewsFeedList![index];
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

  Future<void> addComment(int index, String comment) async {
    setState(() {
      comments.add(comment);
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      pageNumber = 0;
      publicNewsFeedList!.clear();
      isLoaded = false;
    });
    await fetchPublicNewsFeed(pageNumber, pageSize);
  }

  ImageProvider<Object>? _getProfileImage(NewsFeedModel publicNewsFeedList) {
    final String? profilePicture = publicNewsFeedList.profilePicture;
    if (profilePicture != null && profilePicture.isNotEmpty) {
      return CachedNetworkImageProvider(profilePicture);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: isLoaded
            ? publicNewsFeedList!.isEmpty
                ? Center(
                    child: Text(
                      'No PublicNews are available.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: publicNewsFeedList!.length,
                    itemBuilder: (context, index) {
                      NewsFeedModel newsFeed = publicNewsFeedList![index];
                      DateTime? utcDateTime =
                          DateTime.parse(newsFeed.createdOn.toString());
                      DateTime localDateTime = utcDateTime.toLocal();

                      String formattedDate = DateFormat('MMM-dd-yyyy  hh:mm a')
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
                                  // backgroundColor: Colors.white,
                                  backgroundColor: backgroundColors[
                                      index % backgroundColors.length],

                                  backgroundImage: _getProfileImage(newsFeed),
                                  child: _getProfileImage(newsFeed) == null
                                      ? Text(
                                          newsFeed.name.isNotEmpty
                                              ? newsFeed.name[0].toUpperCase()
                                              : "?",
                                          style: TextStyle(
                                            // backgroundColor: Colors.white,
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
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                newsFeed.description!,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            if (newsFeed.photo != null &&
                                newsFeed.photo!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PhotoViewGallery.builder(
                                                    itemCount: 1,
                                                    builder: (context, index) {
                                                      return PhotoViewGalleryPageOptions(
                                                          imageProvider:
                                                              CachedNetworkImageProvider(
                                                                  newsFeed
                                                                      .photo!),
                                                          minScale:
                                                              PhotoViewComputedScale
                                                                      .contained *
                                                                  0.3,
                                                          maxScale:
                                                              PhotoViewComputedScale
                                                                      .covered *
                                                                  1.8,
                                                          initialScale:
                                                              PhotoViewComputedScale
                                                                  .contained,
                                                          heroAttributes:
                                                              PhotoViewHeroAttributes(
                                                                  tag: newsFeed
                                                                      .photo!));
                                                    })));
                                  },
                                  child: Container(
                                      height: 250,
                                      width: 550,
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
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 0, 0),
                                          child: Icon(
                                            newsFeed.userLikes.contains(userId)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 25.0,
                                            color: newsFeed.userLikes
                                                    .contains(userId)
                                                ? HexColor('#FF6F20')
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(newsFeed.like.toString()),
                                      ],
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
