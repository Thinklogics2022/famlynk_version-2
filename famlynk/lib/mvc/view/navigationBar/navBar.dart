import 'package:famlynk/constants/constVariables.dart';
import 'package:famlynk/mvc/model/profile_model/notificationModel.dart';
import 'package:famlynk/mvc/view/familyTree/famTree.dart';
import 'package:famlynk/mvc/view/newsFeed/newsFeed.dart';
import 'package:famlynk/mvc/view/profile/notification/notification.dart';
import 'package:famlynk/mvc/view/profile/profile.dart';
import 'package:famlynk/mvc/view/suggestion/suggestion.dart';
import 'package:famlynk/services/profileService/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '../familyList/famList.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<NotificationModel> notificationModel = [];
  NotificationService notificationService = NotificationService();
  var isLoading = false;

  late int _selectedIndex;
  MyProperties myProperties = MyProperties();
  @override
  void initState() {
    super.initState();
     _selectedIndex = widget.index;
    fetchAPI();
  }

  final List<Widget> _pages = [
    FamlynkNewsFeed(),
    FamilyList(),
    FamilyTree(),
    ProfilePage(),
  ];

  void _onTabSelected(int index) {
    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    print(index);
    print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchAPI() async {
    if (notificationModel.isEmpty) {
      try {
        notificationModel = await notificationService.notificationService();
        
        setState(() {
          isLoading = true;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: 30,
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuggestionScreen()));
                  },
                  icon: Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notifications()));
                  },
                  icon: Badge(
                      label: Text(notificationModel.length.toString()),
                      child: Icon(Icons.notifications))),
              SizedBox(width: 14),
            ],
          )
        ],
        
        title: GestureDetector(
          onTap: () {
            _onTabSelected(0); 
          },
          child: Row(
            children: [
              Image.asset(
                'assets/images/FL01.png',
                width: 40,
                height: 40,
              ),
              SizedBox(width: 10),
              Text(
                "Famlynk",
                style: GoogleFonts.dancingScript(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#0175C8')),
                // TextStyle(
                //   color: Colors.white,
                //   fontSize: 20,
                //   fontWeight: FontWeight.bold,
                // ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        backgroundColor: Colors.white,
        selectedItemColor: HexColor('#FF6F20'),
        unselectedItemColor: HexColor('#0175C8'),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.home,
              size: 25.0,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.person,
              size: 25.0,
            ),
            label: 'FamilyList',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.tree,
              size: 25.0,
            ),
            label: 'Family Tree',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.personCircleCheck,
                size: 25.0,
              ),
              label: 'Profile'),
        ],
      ),
    );
  }
}
