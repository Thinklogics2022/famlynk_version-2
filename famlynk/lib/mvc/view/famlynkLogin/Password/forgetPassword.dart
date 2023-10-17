import 'package:famlynk/mvc/view/famlynkLogin/Password/custom.dart';
import 'package:famlynk/mvc/view/famlynkLogin/Password/password.dart';
import 'package:famlynk/services/forgetPswdService.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController _emailController;
  late TextEditingController _otpController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _otpController = TextEditingController();
  }

  int _otpTimerSeconds = 120;
  Timer? _otpTimer;
  bool otpVisibility = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 40,
      textStyle: TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 241, 245),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#0175C8'),
        centerTitle: true,
        title: Text(
          "Forget Password",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 170,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.orange,
                              ),
                              labelStyle: TextStyle(fontSize: 10),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* Email is required";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: _submitForm,
                          child: Text(
                            "Send OTP",
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                if (otpVisibility)
                  Container(
                    height: 150,
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            child: Pinput(
                              controller: _otpController,
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration: defaultPinTheme.decoration!
                                    .copyWith(
                                        border: Border.all(color: Colors.blue)),
                              ),
                              onCompleted: (pin) => debugPrint(pin),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: _verifyOTP,
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "OTP will expire in $_otpTimerSeconds seconds",
                            style:
                                TextStyle(fontSize: 16, color: Colors.orange),
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
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      ForgetPasswordService forgetPasswordService = ForgetPasswordService();
      forgetPasswordService.getEmail(email);
      print(email);
      setState(() {
        otpVisibility = true;
      });

      startOTPTimer();
    }
  }

  void startOTPTimer() {
    const oneSecond = Duration(seconds: 1);
    _otpTimer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_otpTimerSeconds > 0) {
          _otpTimerSeconds--;
        } else {
          _otpTimer?.cancel();
          _otpTimerSeconds = 120;
          otpVisibility = false;
        }
      });
    });
  }

  void _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text;
      ForgetPasswordService forgetPasswordService = ForgetPasswordService();
      dynamic result = await forgetPasswordService.getOTP(otp);
      print(otp);

      if (result == "OTP is correct") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pswd(email: _emailController.text),
          ),
        );

        _otpTimer?.cancel();
        _otpTimerSeconds = 120;
      } else {
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Incorrect OTP",
            content: "Entered OTP is incorrect.",
            buttonText: "OK",
          ),
        );
      }

      setState(() {
        otpVisibility = true;
      });
    }
  }
}
