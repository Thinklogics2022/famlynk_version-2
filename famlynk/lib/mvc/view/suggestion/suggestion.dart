import 'package:cached_network_image/cached_network_image.dart';
import 'package:famlynk/mvc/controller/dropDown.dart';
import 'package:famlynk/mvc/model/familyMembers/suggestion_model.dart';
import 'package:famlynk/mvc/view/navigationBar/navBar.dart';
import 'package:famlynk/mvc/view/suggestion/personal_detials.dart';
import 'package:famlynk/services/familySevice/suggestion_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  List<Suggestion> suggestionlist = [];
  bool isLoaded = false;
  String currentQuery = '';
  List<Suggestion> filteredSuggestions = [];
  String userId = '';
  int registerMember = 0;

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchSuggestions();
  }

  void loadMoreSuggestions() {
    // pageNumber++;
    fetchSuggestions();
  }

  Future<void> fetchSuggestions() async {
    SuggestionService suggestionService = SuggestionService();
    try {
      var newSuggestions = await suggestionService.getAllSuggestions();

      setState(() {
        suggestionlist = newSuggestions;
        isLoaded = true;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  ImageProvider<Object> getProfileImageWithFallback(Suggestion suggestion) {
    final String? profileImage = suggestion.profileImage;
    if (profileImage == null || profileImage.isEmpty) {
      return AssetImage('assets/images/FL01.png');
    } else {
      return CachedNetworkImageProvider(profileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 223, 228, 237),
        appBar: AppBar(
          backgroundColor: HexColor('#0175C8'),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            'Suggestions',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: isLoaded
            ? suggestionlist!.isEmpty
                ? Center(
                    child: Text(
                      'No FamilyNews are available.',
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TypeAheadFormField<Suggestion>(
                          textFieldConfiguration: TextFieldConfiguration(
                            onChanged: (value) {
                              setState(() {
                                currentQuery = value;
                                filteredSuggestions = suggestionlist
                                    .where((suggestion) => suggestion.name
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              hintText: "Search",
                              suffixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return suggestionlist
                                .where((suggestion) => suggestion.name
                                    .toString()
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .toList();
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    getProfileImageWithFallback(suggestion),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(suggestion.name.toString()),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetails(
                                  name: suggestion.name.toString(),
                                  gender: suggestion.gender.toString(),
                                  address: suggestion.address.toString(),
                                  dateOfBirth:
                                      suggestion.dateOfBirth.toString(),
                                  email: suggestion.email.toString(),
                                  hometown: suggestion.hometown.toString(),
                                  maritalStatus:
                                      suggestion.maritalStatus.toString(),
                                  profileImage:
                                      suggestion.profileImage.toString(),
                                  uniqueUserID:
                                      suggestion.uniqueUserID.toString(),
                                  mobileNo: suggestion.mobileNo.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentQuery.isEmpty
                              ? suggestionlist.length
                              : filteredSuggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = currentQuery.isEmpty
                                ? suggestionlist[index]
                                : filteredSuggestions[index];
                            if (index == suggestionlist.length - 1 &&
                                currentQuery.isEmpty) {}

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserDetails(
                                      name: suggestion.name.toString(),
                                      gender: suggestion.gender.toString(),
                                      address: suggestion.address.toString(),
                                      dateOfBirth:
                                          suggestion.dateOfBirth.toString(),
                                      email: suggestion.email.toString(),
                                      hometown: suggestion.hometown.toString(),
                                      maritalStatus:
                                          suggestion.maritalStatus.toString(),
                                      profileImage:
                                          suggestion.profileImage.toString(),
                                      uniqueUserID:
                                          suggestion.uniqueUserID.toString(),
                                      mobileNo: suggestion.mobileNo.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      getProfileImageWithFallback(suggestion),
                                  backgroundColor: Colors.transparent,
                                  child: suggestion.profileImage == null ||
                                          suggestion.profileImage!.isEmpty
                                      ? NameAvatar(
                                          name: suggestion.name.toString())
                                      : null,
                                ),
                                title: Text(suggestion.name.toString()),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
      MaterialPageRoute(builder: (context) => NavBar(index: 0,)),
    );
    return Future.value(false);
  }
}
