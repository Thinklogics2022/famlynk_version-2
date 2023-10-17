import 'package:famlynk/mvc/view/newsFeed/comment/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:famlynk/mvc/model/newsfeed_model/comment_model.dart';
import 'package:famlynk/services/newsFeedService/commentNewsFeed_service.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({
    required this.name,
    required this.profilePicture,
    required this.newsFeedId,
  });

  final String name;
  final String profilePicture;
  final String newsFeedId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentEditController = TextEditingController();
  String userId = "";
  bool isPostingComment = false;
  List<CommentModel> commentList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadComments();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _loadComments() async {
    try {
      CommentNewsFeedService commentService = CommentNewsFeedService();
      List<CommentModel> comments =
          await commentService.getComment(widget.newsFeedId);
      setState(() {
        commentList = comments;
      });
    } catch (e) {
      print('Error loading comments: $e');
    }
  }

  Future<void> postComment() async {
    String commentText = commentEditController.text.trim();
    if (commentText.isNotEmpty) {
      try {
        setState(() {
          isPostingComment = true;
        });
        CommentNewsFeedService commentService = CommentNewsFeedService();
        CommentModel commentModel = CommentModel(
          userId: userId,
          name: widget.name,
          newsFeedId: widget.newsFeedId,
          profilePicture: widget.profilePicture,
          comment: commentText,
        );
        await commentService.addComment(commentModel);
        commentEditController.clear();
        FocusScope.of(context).unfocus();
        setState(() {
          isPostingComment = false;
        });
        setState(() {
          commentList.insert(0, commentModel);
        });
        await _loadComments();
      } catch (e) {
        print('Error posting comment: $e');
        setState(() {
          isPostingComment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: HexColor('#0175C8'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CommentCard(newsFeedId: widget.newsFeedId),
          ),
          SafeArea(
            child: Container(
              height: kTextTabBarHeight,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              padding: EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: TextField(
                        controller: commentEditController,
                        decoration: InputDecoration(
                          hintText: 'Comment as anything',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: isPostingComment ? null : postComment,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical : 8, horizontal : 8),
                      child: isPostingComment
                          ? CircularProgressIndicator()
                          : Text('Post',
                              style: TextStyle(
                                color: HexColor('#0175C8'),
                              )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
