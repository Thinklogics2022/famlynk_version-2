import 'package:flutter/material.dart';
import 'package:famlynk/mvc/model/newsfeed_model/comment_model.dart';
import 'package:famlynk/services/newsFeedService/commentNewsFeed_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentDateTimeFormatter {
  static String formatDateTime(String createdOn, String? modifiedOn) {
    DateTime? utcDateTime = DateTime.parse(createdOn);
    DateTime localDateTime = utcDateTime.toLocal();

    String formattedDate =
        DateFormat('MMM-dd-yyyy  hh:mm a').format(localDateTime);

    if (modifiedOn != null) {
      DateTime? modifiedDateTime = DateTime.parse(modifiedOn);
      DateTime localModifiedDateTime = modifiedDateTime.toLocal();
      String formattedModifiedDate =
          DateFormat('MMM-dd-yyyy  hh:mm a').format(localModifiedDateTime);

      return '$formattedModifiedDate';
    } else {
      return '$formattedDate';
    }
  }
}

class CommentCard extends StatefulWidget {
  final String newsFeedId;

  CommentCard({required this.newsFeedId});

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  CommentNewsFeedService _commentService = CommentNewsFeedService();
  List<CommentModel> _comments = [];
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadComments();
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _loadComments() async {
    try {
      List<CommentModel> comments =
          await _commentService.getComment(widget.newsFeedId);
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      print('Error loading comments: $e');
    }
  }

  Future<void> loadComments() async {
    try {
      List<CommentModel> comments =
          await _commentService.getComment(widget.newsFeedId);
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      print('Error loading comments: $e');
    }
  }

  void _deleteComment(CommentModel comment) async {
    try {
      await _commentService.deleteComment(comment.id!);
      _loadComments();
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }

  void _editComment(CommentModel comment) async {
    CommentModel editedComment = CommentModel(
      id: comment.id,
      userId: comment.userId,
      name: comment.name,
      profilePicture: comment.profilePicture,
      newsFeedId: comment.newsFeedId,
      comment: "${comment.comment}",
    );

    try {
      await _commentService.editComment(editedComment);
      _loadComments();
    } catch (e) {
      print('Error editing comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadComments,
        child: FutureBuilder<List<CommentModel>>(
          future: getComments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              List<CommentModel> commentList = snapshot.data!;
              if (commentList.isEmpty) {
                // Display "No comments found" message when the commentList is empty
                return Center(child: Text('No comments found.'));
              } else {
                return ListView.builder(
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    CommentModel comment = _comments[index];

                    String formattedDate =
                        CommentDateTimeFormatter.formatDateTime(
                      comment.createdOn!,
                      comment.modifiedOn,
                    );

                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(comment.profilePicture),
                            radius: 18,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(formattedDate),
                                  SizedBox(height: 5),
                                  Text(
                                    comment.comment,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CommentViewUserOptions(
                            userId: userId,
                            comment: comment,
                            onDeleteComment: _deleteComment,
                            onEditComment: _editComment,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: Text('No comments found.'));
            }
          },
        ),
      ),
    );
  }

  Future<List<CommentModel>> getComments() async {
    CommentNewsFeedService commentService = CommentNewsFeedService();
    return await commentService.getComment(widget.newsFeedId);
  }
}

// this code for visible for user only

class CommentViewUserOptions extends StatelessWidget {
  final String userId;
  final CommentModel comment;
  final Function(CommentModel) onDeleteComment;
  final Function(CommentModel) onEditComment;

  CommentViewUserOptions({
    required this.userId,
    required this.comment,
    required this.onDeleteComment,
    required this.onEditComment,
  });

  void _deleteComment(CommentModel comment) async {
    CommentNewsFeedService _commentService = CommentNewsFeedService();

    try {
      await _commentService.deleteComment(comment.id!);
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }

  void _showDltDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Comment'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteComment(comment);
                onDeleteComment(comment);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    String editedComment = comment.comment;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Comment'),
          content: TextField(
            onChanged: (value) {
              editedComment = value;
            },
            controller: TextEditingController(text: editedComment),
            decoration: InputDecoration(hintText: 'Edit your comment...'),
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
                _editComment(context, editedComment);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _editComment(BuildContext context, String editedComment) async {
    CommentNewsFeedService _commentService = CommentNewsFeedService();
    CommentModel editedCommentModel = CommentModel(
      id: comment.id,
      userId: comment.userId,
      name: comment.name,
      profilePicture: comment.profilePicture,
      newsFeedId: comment.newsFeedId,
      comment: "$editedComment",
    );

    try {
      await _commentService.editComment(editedCommentModel);
      onEditComment(editedCommentModel);
      Navigator.pop(context);
    } catch (e) {
      print('Error editing comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: userId == comment.userId,
      child: Container(
        child: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showEditDialog(context);
            } else if (value == 'delete') {
              _showDltDialog(context);
            }
           
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
