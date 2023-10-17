import 'package:famlynk/constants/constVariables.dart';
import 'package:famlynk/mvc/model/login_model/register_model.dart';
import 'package:famlynk/mvc/view/famlynkLogin/Password/custom.dart';
import 'package:famlynk/mvc/view/famlynkLogin/login/EmailLogin.dart';
import 'package:famlynk/mvc/view/famlynkLogin/otp/verifyOtp.dart';
import 'package:famlynk/services/login&registerService/register_service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  MyProperties myProperties = MyProperties();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phnController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _dateinput = TextEditingController();

  bool validateEmail(String value) {
    const emailRegex = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]";
    final RegExp regex = RegExp(emailRegex);
    return !regex.hasMatch(value);
  }

  bool validatePassword(String value) {
    const passwordRegex = '^[A-Za-z0-9@%*#?&]{8,16}';
    final RegExp regex = RegExp(passwordRegex);
    return !regex.hasMatch(value);
  }

  bool validatePhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^\+[1-9]{1}[0-9]{3,14}$');
    return regex.hasMatch(phoneNumber);
  }

  bool showErrorPopup = false;

  void showEmailExistsPopup() {
    setState(() {
      showErrorPopup = true;
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: "Register",
          content: "Email already exists",
          buttonText: "OK",
        ),
      );
    });
  }

  bool _isLoading = false;

  var profileBase64;
  bool isPasswordVisible = false;
  bool isConfirmPswdVisible = false;
  String _selectedGender = '';
  DateTime Date = DateTime.now();
  DateTime? startDate;
  String _password = '';
  String _confirmPassword = '';

  @override
  void initState() {
    _dateinput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyProperties myProperties = MyProperties();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: myProperties.backgroundColor,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Register your account",
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: const Color.fromARGB(255, 62, 141, 141)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: myProperties.fillColor,
                            filled: true,
                            hintText: 'Enter Your Name',
                            hintStyle: TextStyle(color: Colors.grey[500])),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                            return '*name is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_add,
                                  color: Colors.grey, size: 25),
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
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _dateinput,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            icon: Icon(Icons.calendar_month),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: myProperties.fillColor,
                            filled: true,
                            hintText: 'Date Of Birth',
                            hintStyle: TextStyle(color: Colors.grey[500])),
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '*dob is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                          controller: _phnController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.phone),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: myProperties.fillColor,
                              filled: true,
                              hintText: 'Mobile Number',
                              hintStyle: TextStyle(color: Colors.grey[500])),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "*mobile number is required";
                            }
                            if (value.length < 10) {
                              return "*mobile number must be 10";
                            }
                            if (value.length > 10) {
                              return "*mobile number must be 10";
                            }
                            return null;
                          }),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: myProperties.fillColor,
                            filled: true,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[500])),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "*email is required";
                          }
                          if (validateEmail(value)) {
                            return "*valid email is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: myProperties.fillColor,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _password = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '*password is required';
                          }
                          if (value.length < 8) {
                            return '*password should be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !isConfirmPswdVisible,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: myProperties.fillColor,
                          filled: true,
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isConfirmPswdVisible = !isConfirmPswdVisible;
                              });
                            },
                            child: Icon(
                              isConfirmPswdVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _confirmPassword = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '*confirm password is required';
                          }
                          if (value != _password) {
                            return '*confirm password not matching';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 35),
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#0175C8'),
                          ),
                          onPressed: _submitForm,
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
    );
  }

  Future alertDialogBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            
            content: Text("Otp send to your mail"),
          );
        });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      alertDialogBox();

      RegisterService registerService = RegisterService();

      RegisterModel registerModel = RegisterModel(
        id: "",
        uniqueUserID: "",
        userId: "",
        address: "",
        maritalStatus: "",
        hometown: "",
        otp: "",
        verificationToken: "",
        coverImage: "",
        name: _nameController.text,
        gender: _selectedGender,
        dateOfBirth: _dateinput.text,
        password: _passwordController.text,
        email: _emailController.text,
        mobileNo: _phnController.text,
        profileImage: profileBase64 ?? "",
      );

      final response = await registerService.addRegister(registerModel);

      if (response == "Email already exists") {
        setState(() {
          _isLoading = false;
        });
        showEmailExistsPopup();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OTPPage()),
        );
      }
    }
  }
}
