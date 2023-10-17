import 'package:famlynk/mvc/view/famlynkLogin/login/EmailLogin.dart';
import 'package:famlynk/services/login&registerService/resetPasswordService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool isPasswordVisible = false;
  bool isConfirmPswdVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 223, 228, 237),
      appBar: AppBar(
        backgroundColor: HexColor('#0175C8'),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Image.asset(
                  //   "assets/images/lock.jpg",
                  //   height: 120,
                  // ),
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage(
                    "assets/images/img1.jpg",
                    ),
                  ),
                  SizedBox(height: 25),
                  emailField(),
                  const SizedBox(height: 20),
                  newPasswordField(),
                  SizedBox(height: 20),
                  confirmPasswordField(),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.email,
             color: Color.fromARGB(255, 121, 174, 220),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: 'Email',
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "* Email is required";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget newPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
          icon: const Icon(
            Icons.lock,
             color: Color.fromARGB(255, 121, 174, 220),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: 'New Password',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            child: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color.fromARGB(255, 121, 174, 220),
            ),
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return '* New password is required';
        }
        if (value.length < 8) {
          return '* Password should be at least 8 characters';
        }
        return null;
      },
    );
  }

  Widget confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !isConfirmPswdVisible,
      decoration: InputDecoration(
          icon: const Icon(
            Icons.lock,
            color: Color.fromARGB(255, 121, 174, 220),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: 'Confirm Password',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isConfirmPswdVisible = !isConfirmPswdVisible;
              });
            },
            child: Icon(
              isConfirmPswdVisible ? Icons.visibility : Icons.visibility_off,
               color: Color.fromARGB(255, 121, 174, 220),
            ),
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return '* Confirm password is required';
        }
        if (value != _newPasswordController.text) {
          return '* Passwords do not match';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final newPassword = _newPasswordController.text;
      ResetPasswordService.resetPassword(email, newPassword);
      _flutterToast();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void _flutterToast() {
    Fluttertoast.showToast(
      msg: 'Password reset successfully!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
    );
  }
}
