import 'package:cached_network_image/cached_network_image.dart';
import 'package:famlynk/mvc/model/profile_model/profileModel.dart';
import 'package:famlynk/mvc/view/addmember/addMember.dart';
import 'package:famlynk/mvc/view/famlynkLogin/Password/resetPassword.dart';
import 'package:famlynk/mvc/view/myTimeLine/myTimeLine.dart';
import 'package:famlynk/mvc/view/profile/edit.dart';
import 'package:famlynk/mvc/view/profile/logout.dart';
import 'package:famlynk/mvc/view/profile/notification/notification.dart';
import 'package:famlynk/mvc/view/profile/userDetails.dart';
import 'package:famlynk/services/profileService/profile_Service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileUserModel profileUserModel = ProfileUserModel();
  ProfileUserService profileUserService = ProfileUserService();

  bool isLoading = true;

  ImageProvider<Object>? _getProfileImage(ProfileUserModel profileUserModel) {
    if (profileUserModel.profileImage == null ||
        profileUserModel.profileImage!.isEmpty) {
      return AssetImage('assets/images/FL01.png');
    } else {
      return CachedNetworkImageProvider(
        profileUserModel.profileImage.toString(),
      );
    }
  }

  Future<void> _fetchMembers() async {
    try {
      profileUserModel = await profileUserService.fetchMembersByUserId();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60.0),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3.0,
                                        offset: Offset(0, 4.0),
                                        color: Colors.black38,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        _getProfileImage(profileUserModel),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 19),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profileUserModel.name.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          profileUserModel.mobileNo.toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          profileUserModel.email.toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfilePage(
                                                        profileUserModel:
                                                            profileUserModel,
                                                      )),
                                            );
                                          },
                                          child: Text(
                                            "Edit Profile",
                                            style: TextStyle(
                                                color: HexColor('#FF6F20'),
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ]),
                          SizedBox(height: 20),
                          Text(
                            "Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          Card(
                            elevation: 3.0,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  InkWell(
                                    child: CustomListTile(
                                      icon: Icons.add,
                                      text: "Add Family Member",
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddMember()),
                                      );
                                    },
                                  ),
                                  Divider(
                                    height: 10.0,
                                    color: Colors.grey,
                                  ),
                                  InkWell(
                                    child: CustomListTile(
                                      icon: Icons.photo,
                                      text: "Gallery",
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyTimeLine()),
                                      );
                                    },
                                  ),
                                  Divider(
                                    height: 10.0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Notifications()),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.notifications,
                                            color: HexColor('#FF6F20')),
                                        SizedBox(width: 17),
                                        Text("Notifications",
                                            style: TextStyle(fontSize: 16))
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Divider(
                                    height: 10.0,
                                    color: Colors.grey,
                                  ),
                                  InkWell(
                                    child: CustomListTile(
                                      icon: Icons.account_circle_rounded,
                                      text: "User Details",
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileUserDetails()));
                                    },
                                  ),
                                  Divider(
                                    height: 10.0,
                                    color: Colors.grey,
                                  ),
                                  InkWell(
                                    child: CustomListTile(
                                      icon: Icons.password,
                                      text: "Reset Password",
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPassword()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LogOutPage()));
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(
                                      fontSize: 23, color: HexColor('#FF6F20')),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ))));
  }
}

class CustomListTile extends StatelessWidget {
  final IconData? icon;
  final String? text;

  CustomListTile({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: HexColor('#FF6F20'),
          ),
          SizedBox(width: 15),
          Text(
            "$text",
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
