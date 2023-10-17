import 'package:famlynk/mvc/model/newsfeed_model/newsFeed_model.dart';
import 'package:famlynk/mvc/view/newsFeed/like/like.dart';
// import 'package:famlynk/services/newsFeedService/likeNewsFeed_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:famlynk/services/profileService/myTimeLine/myTimeLine_service.dart';
import 'package:famlynk/mvc/model/newsfeed_model/addNewsFeed_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:famlynk/mvc/view/newsFeed/comment/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyNewsFeed extends StatefulWidget {
  const MyNewsFeed({Key? key}) : super(key: key);

  @override
  State<MyNewsFeed> createState() => _MyNewsFeedState();
}

class _MyNewsFeedState extends State<MyNewsFeed> {
  bool isLoaded = false;
  bool isLiked = false;
  late List<String> comments;
  List<NewsFeedModel>? myTimeLineList = [];
  ScrollController _scrollController = ScrollController();
  String userId = "";

  @override
  void initState() {
    super.initState();
    fetchData();
    comments = [];
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
    await _fetchMyTimeLine();
  }

  Future<void> _fetchMyTimeLine() async {
    MyTimeLineService myTimeLineService = MyTimeLineService();
    try {
      var myNewsFeed = await myTimeLineService.getMyTimeLine();
      setState(() {
        myTimeLineList!.addAll(myNewsFeed);
        isLoaded = true;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _handleRefersh() async {
    setState(() {
      myTimeLineList!.clear();
      isLoaded = false;
    });
    await _fetchMyTimeLine();
  }

  ImageProvider<Object>? _getProfileImage(NewsFeedModel myNewsFeeds) {
    final String? profilePicture = myNewsFeeds.profilePicture;
    if (profilePicture == null || profilePicture.isEmpty) {
      return AssetImage('assets/images/FL01.png');
    } else {
      return CachedNetworkImageProvider(profilePicture);
    }
  }

  void onLikeButtonPressed(int index) async {
    NewsFeedModel myNewsFeeds = myTimeLineList![index];
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

  Future<void> _editMyTimeLineDescription(BuildContext context,
      String editedDescription, NewsFeedModel myTimeLineModel) async {
    MyTimeLineService myTimeLineService = MyTimeLineService();
    AddImageNewsFeedMode editMyTimeLine = AddImageNewsFeedMode(
      newsFeedId: myTimeLineModel.newsFeedId,
      description: editedDescription,
      photo: myTimeLineModel.photo,
    );

    try {
      await myTimeLineService.editMyTimeLine(editMyTimeLine);
      Navigator.pop(context);
      _handleRefersh();
    } catch (e) {
      print('Error editing Description: $e');
    }
  }

  void _deleteMyTimeLine(NewsFeedModel myTimeLineModel) async {
    MyTimeLineService myTimeLineService = MyTimeLineService();

    try {
      await myTimeLineService.deleteMyTimeLine(myTimeLineModel.newsFeedId);
      _handleRefersh();
    } catch (e) {
      print('Error deleting MyTimeLine: $e');
    }
  }

  void _showDeleteConfirmation(NewsFeedModel myTimeLineModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete MyTimeLine'),
          content: Text('Are you sure you want to delete this Timeline?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _deleteMyTimeLine(myTimeLineModel);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, NewsFeedModel myTimeLineModel) {
    String editedDescription = myTimeLineModel.description ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Description'),
          content: TextField(
            onChanged: (value) {
              editedDescription = value;
            },
            controller: TextEditingController(text: editedDescription),
            decoration: InputDecoration(hintText: 'Edit your Description...'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _editMyTimeLineDescription(
                    context, editedDescription, myTimeLineModel);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      body: RefreshIndicator(
        onRefresh: _handleRefersh,
        child: isLoaded
            ? myTimeLineList!.isEmpty
                ? Center(
                    child: Text(
                      'You have no Posted',
                      // style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: myTimeLineList!.length,
                    itemBuilder: (context, index) {
                      NewsFeedModel myNewsFeeds = myTimeLineList![index];
                      String formattedDate = DateFormat('MMM-dd-yyyy  hh:mm a')
                          .format(myNewsFeeds.createdOn);

                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: _getProfileImage(myNewsFeeds),
                              ),
                              title: Text(myNewsFeeds.name),
                              subtitle: Text(formattedDate),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditDialog(context, myNewsFeeds);
                                  } else if (value == 'delete') {
                                    _showDeleteConfirmation(myNewsFeeds);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                myNewsFeeds.description!,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            if (myNewsFeeds.photo != null &&
                                myNewsFeeds.photo!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: myNewsFeeds.photo!,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: null,
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
                                        Icon(
                                          myNewsFeeds.userLikes.contains(userId)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 20.0,
                                          color: myNewsFeeds.userLikes
                                                  .contains(userId)
                                              ? HexColor('#FF6F20')
                                              : null,
                                        ),
                                        SizedBox(width: 5),
                                        Text(myNewsFeeds.like.toString()),
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
                                                    name: myNewsFeeds.name,
                                                    newsFeedId:
                                                        myNewsFeeds.newsFeedId,
                                                    profilePicture: myNewsFeeds
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
                            SizedBox(
                              height: 10,
                            )
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
