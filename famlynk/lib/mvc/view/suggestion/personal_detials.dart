import 'package:famlynk/mvc/model/addmember_model/searchAddMember_model.dart';
import 'package:famlynk/mvc/view/navigationBar/navBar.dart';
import 'package:famlynk/mvc/view/suggestion/suggestion.dart';
import 'package:famlynk/services/familySevice/searchAddMumber_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Relationship {
  String value;
  String viewValue;

  Relationship({required this.value, required this.viewValue});
}

List<Relationship> relationship = [
  Relationship(value: 'none', viewValue: 'None'),
  Relationship(value: 'father', viewValue: 'Father'),
  Relationship(value: 'mother', viewValue: 'Mother'),
  Relationship(value: 'brother', viewValue: 'Brother'),
  Relationship(value: 'sister', viewValue: 'Sister'),
  Relationship(value: 'husband', viewValue: 'Husband'),
  Relationship(value: 'wife', viewValue: 'Wife'),
  Relationship(value: 'son', viewValue: 'Son'),
  Relationship(value: 'daughter', viewValue: 'Daughter'),
];

class UserDetails extends StatefulWidget {
  UserDetails({
    Key? key,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
    required this.maritalStatus,
    required this.hometown,
    required this.profileImage,
    required this.address,
    required this.uniqueUserID,
    required this.mobileNo,
  }) : super(key: key);

  final String name;
  final String gender;
  final String dateOfBirth;
  final String email;
  final String maritalStatus;
  final String hometown;
  final String profileImage;
  final String address;
  final String uniqueUserID;
  final String mobileNo;

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String selectedFirstLevelRelation = 'none';
  String userId = '';
  String selectedSecondLevelRelation = '';
  String selectedThirdLevelRelation = '';
  // String? profileImage;
  List<String> secondLevelRelationList = [];
  List<String> thirdLevelRelationList = [];
  Set<String> secondLevelRelationSet = {};
  Set<String> thirdLevelRelationSet = {};

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  String? firstLevelRelationError;

  @override
  void initState() {
    super.initState();
    fetchData();
    if (relationship.isNotEmpty) {
      selectedFirstLevelRelation = relationship[0].value;
      updateSecondRelations(selectedFirstLevelRelation).then((_) {
        setState(() {
          if (secondLevelRelationSet.isNotEmpty) {
            selectedSecondLevelRelation = secondLevelRelationSet.first;
          }
        });
      });
      selectedSecondLevelRelation = relationship[0].value;
      updateThirdLevelRelations(selectedSecondLevelRelation).then((_) {
        setState(() {
          if (thirdLevelRelationSet.isNotEmpty) {
            selectedThirdLevelRelation = thirdLevelRelationSet.first;
          }
        });
      });
    }
  }

  Future<void> addToFamily() async {
    try {
      SearchAddMemberService searchAddMemberService = SearchAddMemberService();

      SearchAddMember searchAddMemberModel = SearchAddMember(
        // famid: '',
        // name: widget.name,
        // gender: widget.gender,
        // dob: widget.dateOfBirth,
        // email: widget.email,
        // userId: userId,
        // image: widget.profileImage,
        // mobileNo: widget.mobileNo,
        // relation: '',
        uniqueUserID: widget.uniqueUserID,
        firstLevelRelation: selectedFirstLevelRelation,
        secondLevelRelation: selectedSecondLevelRelation,
        thirdLevelRelation: selectedThirdLevelRelation,
      );
      searchAddMemberService
          .searchAddMemberPost(searchAddMemberModel)
          .then((value) => {
                if (value.isNotEmpty)
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuggestionScreen()))
                  }
              });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to Family successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to Family.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> updateSecondRelations(String firstLevelRelation) async {
    SearchAddMemberService searchAddMemberService = SearchAddMemberService();
    try {
      List<String> fetchedSecondLevelRelations = await searchAddMemberService
          .fetchSecondLevelRelations(firstLevelRelation);

      setState(() {
        selectedFirstLevelRelation = firstLevelRelation;
        secondLevelRelationList = fetchedSecondLevelRelations;
        selectedSecondLevelRelation = '';
      });
    } catch (e) {
      print("Error fetching relations: $e");
    }
  }

  Future<void> updateThirdLevelRelations(String secondLevelRelation) async {
    SearchAddMemberService searchAddMemberService = SearchAddMemberService();
    try {
      List<String> fetchedThirdLevelRelations = await searchAddMemberService
          .fetchthirdLevelRelations(secondLevelRelation);

      setState(() {
        selectedSecondLevelRelation = secondLevelRelation;
        thirdLevelRelationList = fetchedThirdLevelRelations;
        selectedThirdLevelRelation = '';
      });
    } catch (e) {
      print("Error fetching relations: $e");
    }
  }

  List<DropdownMenuItem<String>> buildThirdLevelDropdownItems() {
    if (selectedSecondLevelRelation.isEmpty) {
      return [];
    } else {
      return thirdLevelRelationList.map((relation) {
        int startIndex = relation.indexOf("thirdLevelRelation:") +
            "thirdLevelRelation:".length;

        String restOfData = relation.substring(startIndex);

        int endIndex = restOfData.indexOf(",") != -1
            ? restOfData.indexOf(",")
            : restOfData.indexOf("}");

        String thirdLevelRelationn = restOfData.substring(0, endIndex).trim();
        return DropdownMenuItem<String>(
          value: thirdLevelRelationn,
          child: Text(thirdLevelRelationn),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: HexColor('#0175C8'),
        centerTitle: true,
        title: Text(
          'Family Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Colors.lightBlue,
          //       Color.fromARGB(255, 223, 228, 237),
          //     ],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CircleAvatar(
                      //   radius: 60,
                      //   backgroundImage: NetworkImage(
                      //     widget.profileImage ?? '',
                      //   ),
                      // ),
                      SizedBox(height: 20),
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Gender :',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${widget.gender}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'DOB      :',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${widget.dateOfBirth}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Email    :',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${widget.email}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'First Level Relation',
                          errorText:
                              firstLevelRelationError, // Set the error text here
                        ),
                        value: selectedFirstLevelRelation,
                        onChanged: (newValue) {
                          setState(() {
                            selectedFirstLevelRelation = newValue!;
                            selectedSecondLevelRelation = '';
                            updateSecondRelations(selectedFirstLevelRelation);
                            firstLevelRelationError =
                                null; // Reset the error message
                          });
                        },
                        items: relationship.map((relation) {
                          return DropdownMenuItem<String>(
                            value: relation.value,
                            child: Text(relation.viewValue),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Second Level Relation',
                        ),
                        value: selectedSecondLevelRelation,
                        onChanged: (newValue) {
                          setState(() {
                            selectedSecondLevelRelation = newValue!;
                            selectedThirdLevelRelation = '';
                            updateThirdLevelRelations(
                                selectedSecondLevelRelation);
                          });
                        },
                        items: secondLevelRelationList.map((relation) {
                          int startIndex =
                              relation.indexOf("secondLevelRelation:") +
                                  "secondLevelRelation:".length;

                          String restOfData = relation.substring(startIndex);

                          int endIndex = restOfData.indexOf(",") != -1
                              ? restOfData.indexOf(",")
                              : restOfData.indexOf("}");

                          String secondLevelRelationn =
                              restOfData.substring(0, endIndex).trim();

                          return DropdownMenuItem(
                            value: secondLevelRelationn,
                            child: Text(secondLevelRelationn),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Third Level Relation',
                        ),
                        value: selectedThirdLevelRelation,
                        onChanged: (newValue) {
                          setState(() {
                            selectedThirdLevelRelation = newValue!;
                          });
                        },
                        items: buildThirdLevelDropdownItems(),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // ignore: unnecessary_null_comparison
                          if (selectedFirstLevelRelation == null ||
                              selectedFirstLevelRelation.isEmpty ||
                              selectedFirstLevelRelation == "none") {
                            setState(() {
                              firstLevelRelationError =
                                  'Please select a valid first level relation';
                            });
                          } else {
                            setState(() {
                              firstLevelRelationError = null;
                            });
                            addToFamily();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Add to Family",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
