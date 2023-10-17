import 'package:famlynk/mvc/view/newsFeed/addNewsFeed.dart';
import 'package:famlynk/mvc/view/newsFeed/public_private/familyNewsFeed.dart';
import 'package:famlynk/mvc/view/newsFeed/public_private/public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class FamlynkNewsFeed extends StatefulWidget {
  @override
  _FamlynkNewsFeedState createState() => _FamlynkNewsFeedState();
}

class _FamlynkNewsFeedState extends State<FamlynkNewsFeed>
    with TickerProviderStateMixin {
  late TabController tabController;
  List<String> downloadedImageUrls = [];
  Set<String> likedPosts = {};
  DateTime? _lastBackPressedTime;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> deleteImage(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('imageURLs')
          .doc(docId)
          .delete();
      print('Image deleted successfully!');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  void toggleLike(String postId) {
    setState(() {
      if (likedPosts.contains(postId)) {
        likedPosts.remove(postId);
      } else {
        likedPosts.add(postId);
      }
    });
  }

  // bool isPostLiked(String postId) {
  //   return likedPosts.contains(postId);
  // }

  Future<bool> onWillpop() async {
    DateTime currentTime = DateTime.now();
    if (_lastBackPressedTime == null ||
        currentTime.difference(_lastBackPressedTime!) > Duration(seconds: 2)) {
      _lastBackPressedTime = currentTime;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Press back again to exit"),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillpop,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 223, 228, 237),
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor('#0175C8'),
          child: Icon(Icons.add,color:Colors.white,),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddImagePage()));
          },
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: HexColor('#cde0ee'),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TabBar(
                          labelColor:  HexColor('#0175C8'),
                          labelStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                          indicator: BoxDecoration(
                            color:  Color.fromARGB(255, 223, 228, 237),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          controller: tabController,
                          tabs: [
                            Tab(text: 'Public News'),
                            Tab(text: 'Family News'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                       PublicNews(),
                       FamilyNews(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


