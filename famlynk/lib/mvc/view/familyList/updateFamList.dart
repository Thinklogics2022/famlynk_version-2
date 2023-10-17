import 'dart:io';
import 'package:famlynk/constants/constVariables.dart';
import 'package:famlynk/mvc/controller/dropDown.dart';
import 'package:famlynk/mvc/model/familyMembers/famlist_modelss.dart';
import 'package:famlynk/mvc/model/familyMembers/updateFamMember_model.dart';
import 'package:famlynk/mvc/view/navigationBar/navBar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:famlynk/services/familySevice/updateFamList_service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class UpdateFamList extends StatefulWidget {
  UpdateFamList({super.key, required this.updateMember});

  FamListModel? updateMember;

  @override
  _UpdateFamListState createState() => _UpdateFamListState();
}

class _UpdateFamListState extends State<UpdateFamList> {
  final firebase_storage.Reference storageRef =
      firebase_storage.FirebaseStorage.instance.ref();
  File? imageFile;

  MyProperties myProperties = new MyProperties();
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController phNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dateinput = TextEditingController();

  String _selectedGender = '';
  String dropdownValue1 = '';

  // String dropdownValue = 'Select Relation';
  String? profilBase64;
  String userId = "";

  bool validateEmail(String value) {
    const emailRegex = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]";
    final RegExp regex = RegExp(emailRegex);
    return !regex.hasMatch(value);
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.updateMember!.name.toString();
    _selectedGender = widget.updateMember!.gender.toString();
    phNumber.text = widget.updateMember!.mobileNo.toString();
    email.text = widget.updateMember!.email.toString();
    dateinput.text = widget.updateMember!.dob.toString();
    profilBase64 = widget.updateMember!.image.toString();
    dropdownValue1 = widget.updateMember!.firstLevelRelation.toString();
    if (relation.contains(widget.updateMember!.firstLevelRelation)) {
      dropdownValue1 = widget.updateMember!.firstLevelRelation.toString();
    } else {
      dropdownValue1 = "Select Relation";
    }

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#0175C8'),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Update Family Member',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  imageprofile(),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 1),
                      labelText: "Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_add,
                              color: Colors.orange, size: 25),
                          SizedBox(
                            width: 8,
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 'male',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                              SizedBox(height: 6),
                              Text("Male"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 'female',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                              SizedBox(height: 6),
                              Text("Female"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 'others',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                              SizedBox(height: 6),
                              Text("Others"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: dateinput,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 1),
                      labelText: "DOB",
                      prefixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.orange,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2500));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dateinput.text = formattedDate;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phNumber,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 1),
                      labelText: "Mobile No",
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.orange,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 1),
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.orange,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  Container(
                      child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 1),
                      labelText: "Relation",
                      prefixIcon: Icon(
                        Icons.people,
                        color: Colors.orange,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    dropdownColor: Color.fromARGB(255, 255, 255, 255),
                    value: dropdownValue1, // Use the updated dropdownValue1
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue1 = newValue!;
                      });
                    },
                    items:
                        relation.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),
                  )),
                  SizedBox(height: 35),
                  Container(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
     showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
    String imageUrl = widget.updateMember!.image.toString();

    if (imageFile != null) {
      final storageResult = await storageRef
          .child('profile_images/${name.text}')
          .putFile(imageFile!);
      imageUrl = await storageResult.ref.getDownloadURL();
    }
    UpdateFamMemberModel updateFamMemberModel = UpdateFamMemberModel(
        name: name.text,
        dob: dateinput.text,
        gender: _selectedGender,
        mobileNo: phNumber.text,
        famid: widget.updateMember!.famid,
        email: email.text,
        userId: widget.updateMember!.userId,
        uniqueUserID: widget.updateMember!.uniqueUserID,
        // relation: "",
        firstLevelRelation: dropdownValue1,
        image: imageUrl);
    print(widget.updateMember!.famid.toString());
    UpdateFamListService updateFamListService = UpdateFamListService();
    updateFamListService.updateFamMember(updateFamMemberModel);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NavBar(index: 1,)));
  }
Widget imageprofile() {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 20,
                  color: Colors.blue.withOpacity(0.2),
                  offset: Offset(0, 10),
                )
              ],
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: imageFile == null
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(widget.updateMember!.image.toString()),
                    )
                  : Image.file(imageFile!, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  color: Colors.blue,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Update your photo",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      imageFile = File(pickedImage.path);
                    });
                  }
                },
                icon: Icon(Icons.image, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
