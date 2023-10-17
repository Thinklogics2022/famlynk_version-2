import 'package:famlynk/mvc/view/myTimeLine/photo.dart';
import 'package:famlynk/mvc/view/myTimeLine/myNewsFeed.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyTimeLine extends StatefulWidget {
  const MyTimeLine({Key? key}) : super(key: key);

  @override
  _MyTimeLineState createState() => _MyTimeLineState();
}

class _MyTimeLineState extends State<MyTimeLine> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: HexColor('#0175C8'),
        title: Text('MyTimeLine',style: TextStyle(color: Colors.white),),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.newspaper), text: "MyTimeLine"),
            Tab(icon: Icon(Icons.photo), text: "Photo"),
          ],
          unselectedLabelColor: Colors.white,
          labelColor: HexColor('#FF6F20'),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyNewsFeed(),
          PhotoPage(),
        ],
      ),
    );
  }
}
