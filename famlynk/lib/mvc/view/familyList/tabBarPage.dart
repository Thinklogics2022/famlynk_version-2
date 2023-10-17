import 'package:famlynk/mvc/model/familyMembers/individualUserModel.dart';
import 'package:famlynk/mvc/view/familyList/family.dart';
import 'package:famlynk/mvc/view/familyList/about.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../services/familySevice/individulaUserService.dart';
import 'mutualConnection.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key, required this.uniqueUserId}) : super(key: key);

  final String uniqueUserId;
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage>
    with SingleTickerProviderStateMixin {
  IndividualUserModel individualUserModel = IndividualUserModel();
  IndividulaUserService individulaUserService = IndividulaUserService();
  late TabController _tabController;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchFamilyMembers(widget.uniqueUserId);
  }

  fetchFamilyMembers(String uniqueUserID) async {
    try {
      individualUserModel = await individulaUserService
          .individulaUserService(widget.uniqueUserId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
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
        title: Text(
          'Family Members',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.account_box), text: "About"),
            Tab(icon: Icon(Icons.people), text: "Family"),
            Tab(icon: Icon(Icons.connected_tv), text: "Mutual Connection"),
          ],
          labelPadding: EdgeInsets.symmetric(horizontal: 2),
          unselectedLabelColor: Colors.white,
          labelColor: HexColor('#FF6F20'),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
       children: [
    About(
      name: individualUserModel.name ?? "", 
      gender: individualUserModel.gender ?? "", 
      dateOfBirth: individualUserModel.dateOfBirth ?? "",
      email: individualUserModel.email ?? "", 
      uniqueUserId: individualUserModel.uniqueUserID ?? "v", 
      userId: individualUserModel.userId ?? "",
      image: individualUserModel.profileImage ?? "", 
    ),
          Family(userId: individualUserModel.userId.toString()),
          MutualConnection(uniqueUserId: widget.uniqueUserId)
        ],
      ),
    );
  }
}
