
import 'dart:io';
import 'package:famlynk/constants/constVariables.dart';
import 'package:famlynk/mvc/controller/dropDown.dart';
import 'package:famlynk/mvc/model/profile_model/imageModel.dart';
import 'package:famlynk/mvc/model/profile_model/profileModel.dart';
import 'package:famlynk/mvc/view/navigationBar/navBar.dart';
import 'package:famlynk/services/profileService/editProfileService.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profileUserModel});

  final ProfileUserModel? profileUserModel;
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firebase_storage.Reference storageRef =
      firebase_storage.FirebaseStorage.instance.ref();
  File? imageFile;
  bool _isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController homeTownController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController _dateinput = TextEditingController();
  String _selectedGender = '';

  String? profilBase64;
  String dropdownValuess = 'Marital Status';

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController.text = widget.profileUserModel!.name.toString();
    _dateinput.text = widget.profileUserModel!.dateOfBirth.toString();
    emailController.text = widget.profileUserModel!.email.toString();
    mobileNumberController.text = widget.profileUserModel!.mobileNo.toString();
    _selectedGender = widget.profileUserModel!.gender.toString();
    homeTownController.text = widget.profileUserModel!.hometown.toString();
    addressController.text = widget.profileUserModel!.address.toString();
    dropdownValuess = widget.profileUserModel!.maritalStatus.toString();

    super.initState();
  }

  void _snackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Profile Updated", style: TextStyle(fontSize: 15),),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    MyProperties myProperties = MyProperties();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      appBar: AppBar(
        backgroundColor: HexColor('#0175C8'),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Form(
              key: formkey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  SizedBox(height: 25),
                  Center(
                    child: Stack(
                      children: [
                        imageprofile(),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  buildTextField("Full Name", nameController, Icons.person),
                  buildTextField("E-mail", emailController, Icons.email,
                      enabled: false),
                  buildTextField(
                      "Mobile Number", mobileNumberController, Icons.phone),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_add, color: Colors.grey, size: 25),
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
                  SizedBox(height: 12.5),
                  Divider(
                    thickness: 1.2,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12.5),
                  TextField(
                    controller: _dateinput,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      fillColor: myProperties.fillColor,
                      hintText: 'Date Of Birth',
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
                          _dateinput.text = formattedDate;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 25),
                  buildTextField("Home Town", homeTownController, Icons.home),
                  buildTextField("Address", addressController, Icons.location_city),
                  Container(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.child_care),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 1),
                        labelText: "Marital Status",
                        labelStyle:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        hintText:
                            "${widget.profileUserModel!.maritalStatus.toString()}",
                        hintStyle: TextStyle(color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: maritalStatus
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 15),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValuess = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#0175C8'),
                    ),
                    onPressed: _isLoading ? null : submitForm,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  SizedBox(height: 35),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void submitForm() async {
    setState(() {
      _isLoading = true;
    });

    _snackBar();
    String imageUrl = widget.profileUserModel!.profileImage.toString();

    if (imageFile != null) {
      final storageResult = await storageRef
          .child('profile_images/${nameController.text}')
          .putFile(imageFile!);
      imageUrl = await storageResult.ref.getDownloadURL();
    }
    ImageModel imageModel =
        ImageModel(name: nameController.text, profilePicture: imageUrl);

    EditProfileService editProfileServices = EditProfileService();
    editProfileServices.imageService(imageModel);
    ProfileUserModel profileUserModel = ProfileUserModel(
      name: nameController.text,
      email: emailController.text,
      mobileNo: mobileNumberController.text,
      gender: _selectedGender,
      dateOfBirth: _dateinput.text,
      hometown: homeTownController.text,
      address: addressController.text,
      maritalStatus: dropdownValuess,
      userId: widget.profileUserModel!.userId,
      uniqueUserID: widget.profileUserModel!.uniqueUserID,
      profileImage: imageUrl,
      id: widget.profileUserModel!.id,
      password: widget.profileUserModel!.password,
      coverImage: "",
      createdOn: widget.profileUserModel!.createdOn,
      modifiedOn: "",
      status: widget.profileUserModel!.status,
      role: widget.profileUserModel!.role,
      enabled: widget.profileUserModel!.enabled,
      verificationToken: widget.profileUserModel!.verificationToken,
      otp: widget.profileUserModel!.otp,
    );

    EditProfileService editProfileService = EditProfileService();
    editProfileService.editProfile(profileUserModel);

    setState(() {
      _isLoading = false;
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar(index: 0,)));
  }

 Widget buildTextField(
      String labelText, TextEditingController controller, IconData? prefixIcon,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 1),
          labelText: labelText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
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
        enabled: enabled,
      ),
    );
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
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 10),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: imageFile == null
                    ? Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              widget.profileUserModel!.profileImage.toString()),
                        ),
                      )
                    : Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
              )),
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
                  color: Colors.green,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
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
                icon: Icon(Icons.image),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
