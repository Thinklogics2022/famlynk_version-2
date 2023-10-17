import 'package:famlynk/mvc/controller/dropDown.dart';
import 'package:famlynk/mvc/model/familyMembers/famlist_modelss.dart';
import 'package:famlynk/mvc/view/familyList/tabBarPage.dart';
import 'package:famlynk/mvc/view/familyList/updateFamList.dart';
import 'package:famlynk/mvc/view/navigationBar/navBar.dart';
import 'package:famlynk/services/familySevice/dltFamList_service.dart';
import 'package:famlynk/services/familySevice/famlist_servicess.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyList extends StatefulWidget {
  @override
  _FamilyListState createState() => _FamilyListState();
}

class _FamilyListState extends State<FamilyList> {
  var isLoaded = false;
  List<FamListModel> familyList = [];
  DltMemberService dltMemberService = DltMemberService();
  ShowFamilyMemberService _familyMemberService = ShowFamilyMemberService();
  String userId = "";

  @override
  void initState() {
    super.initState();
    fetchFamilyMembers();
  }

  Future<void> fetchFamilyMembers() async {
    if (familyList.isEmpty) {
      try {
        familyList = await _familyMemberService.getFamilyList();
        if (familyList.isNotEmpty) {
          familyList = familyList.sublist(1);
        }
        setState(() {
          isLoaded = true;
        });
        final prefs = await SharedPreferences.getInstance();
        userId = prefs.getString('userId') ?? '';
      } catch (e) {
        print(e);
      }
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: isLoaded
            ? familyList.isEmpty
                ? Center(
                    child: Text('There is no more family list.'),
                  )
                : ListView.builder(
                    itemCount: familyList.length,
                    itemBuilder: (context, index) {
                      final isEditable =
                          familyList[index].registerUser == false;

                      // print("RS USER :${familyList[index].registerUser}");
                      return InkWell(
                        child: Card(
                          child: Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Color.fromARGB(255, 221, 232, 232),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: defaultImage(
                                      familyList[index].image.toString(),
                                      familyList[index].name.toString(),
                                      index,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 100,
                                          child: Text(
                                            familyList[index].name.toString(),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(capitalizeFirstLetter(
                                            familyList[index]
                                                .relation
                                                .toString())),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Center(
                                    child: InkWell(
                                      child: PopupMenuButton(
                                        itemBuilder: (BuildContext context) => [
                                          if (isEditable)
                                            PopupMenuItem(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateFamList(
                                                        updateMember:
                                                            familyList[index],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                            ),
                                          if (!isEditable)
                                            PopupMenuItem(
                                              child: TextButton(
                                                onPressed: () {
                                                  showMyDialog(
                                                    familyList[index]
                                                        .userId
                                                        .toString(),
                                                    familyList[index]
                                                        .uniqueUserID
                                                        .toString(),
                                                  );
                                                },
                                                child: Text(
                                                  "remove",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (isEditable)
                                            PopupMenuItem(
                                              child: TextButton(
                                                onPressed: () {
                                                  _showMyDialog(
                                                    familyList[index]
                                                        .userId
                                                        .toString(),
                                                    familyList[index]
                                                        .uniqueUserID
                                                        .toString(),
                                                  );
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TabBarPage(
                                      uniqueUserId: (familyList[index]
                                          .uniqueUserID
                                          .toString()))));
                        },
                      );
                    },
                  )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => NavBar(
                index: 0,
              )),
    );
    return Future.value(false);
  }

  Future<void> _showMyDialog(String userId, String uniqueUserID) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('Are you sure want to delete'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NavBar(index: 1)),
                );
                dltMemberService.deleteFamilyMember(userId, uniqueUserID);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog(String userId, String uniqueUserID) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('Are you sure want to remove'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NavBar(index: 1)),
                );
                dltMemberService.deleteFamilyMember(userId, uniqueUserID);
              },
            ),
          ],
        );
      },
    );
  }
}
