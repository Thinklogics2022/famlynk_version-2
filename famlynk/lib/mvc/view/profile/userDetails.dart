import 'package:cached_network_image/cached_network_image.dart';
import 'package:famlynk/mvc/model/profile_model/profileModel.dart';
import 'package:famlynk/utils/commonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../services/profileService/profile_Service.dart';

class ProfileUserDetails extends StatefulWidget {
  @override
  _ProfileUserDetailsState createState() => _ProfileUserDetailsState();
}

class _ProfileUserDetailsState extends State<ProfileUserDetails>
    with SingleTickerProviderStateMixin {
  ProfileUserModel profileUserModel = ProfileUserModel();
  ProfileUserService profileUserService = ProfileUserService();
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  ImageProvider<Object>? _getProfileImage(ProfileUserModel profileUserModel) {
    if (profileUserModel.profileImage == null ||
        profileUserModel.profileImage!.isEmpty) {
      return AssetImage('assets/images/FL01.png');
    } else {
      return CachedNetworkImageProvider(
          profileUserModel.profileImage.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _fetchMembers();
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.bounceInOut);
    _animationController.forward();
  }

  _fetchMembers() async {
    try {
      profileUserModel = await profileUserService.fetchMembersByUserId();
      print("img :  ${profileUserModel.profileImage}");
      setState(() {
        isLoading = false;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // _controller.forward();
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: HexColor('#0175C8'),
        centerTitle: true,
        title: Text(
          'User Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200,
              child: HeaderWidget(200, false, Icons.abc),
            ),
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 70),
                          ScaleTransition(
                            scale: _animation,
                            child: CircleAvatar(
                                radius: 65,
                                backgroundImage:
                                    _getProfileImage(profileUserModel)),
                          ),
                          SizedBox(height: 20),
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    size: 20,
                                                    color: Colors.deepOrange,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    profileUserModel.name
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.date_range,
                                                size: 20,
                                                color: Colors.deepOrange,
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                profileUserModel.dateOfBirth
                                                    .toString(),
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.email,
                                                size: 20,
                                                color: Colors.deepOrange,
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  profileUserModel.email
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.people,
                                                size: 20,
                                                color: Colors.deepOrange,
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                profileUserModel.gender
                                                    .toString(),
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                size: 20,
                                                color: Colors.deepOrange,
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                profileUserModel.mobileNo
                                                    .toString(),
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Visibility(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: (profileUserModel
                                                                  .maritalStatus !=
                                                              null &&
                                                          profileUserModel
                                                              .maritalStatus!
                                                              .isNotEmpty)
                                                      ? Row(
                                                          children: [
                                                            Icon(
                                                              Icons.child_care,
                                                              size: 20,
                                                              color: Colors
                                                                  .deepOrange,
                                                            ),
                                                            SizedBox(width: 12),
                                                            Text(
                                                              profileUserModel
                                                                  .maritalStatus
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox.shrink(),
                                                ),
                                                SizedBox(height: 12),
                                                Container(
                                                  child: (profileUserModel
                                                                  .hometown !=
                                                              null &&
                                                          profileUserModel
                                                              .hometown!
                                                              .isNotEmpty)
                                                      ? Row(
                                                          children: [
                                                            Icon(
                                                              Icons.home,
                                                              size: 20,
                                                              color: Colors
                                                                  .deepOrange,
                                                            ),
                                                            SizedBox(width: 12),
                                                            Text(
                                                              profileUserModel
                                                                  .hometown
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox.shrink(),
                                                ),
                                                SizedBox(height: 12),
                                                Container(
                                                  child: (profileUserModel
                                                                  .address !=
                                                              null &&
                                                          profileUserModel
                                                              .address!
                                                              .isNotEmpty)
                                                      ? Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_city,
                                                              size: 20,
                                                              color: Colors
                                                                  .deepOrange,
                                                            ),
                                                            SizedBox(width: 12),
                                                            Text(
                                                              profileUserModel
                                                                  .address
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox.shrink(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
