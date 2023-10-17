import 'dart:async';
import 'dart:convert';
import 'package:famlynk/mvc/view/famlynkLogin/register/register.dart';
import 'package:famlynk/mvc/view/navigationBar/navBar.dart';
import 'package:famlynk/services/firebase/loginservices.dart';
import 'package:famlynk/mvc/model/login_model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class FamLogin extends StatefulWidget {
  const FamLogin({
    super.key,
  });

  @override
  _FamLoginState createState() => _FamLoginState();
}

class _FamLoginState extends State<FamLogin> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController uuidController = TextEditingController();

  LoginServices uidObj = LoginServices();

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  bool otpVisibility = false;
  User? user;
  String verificationID = "";
  late Timer _timer;
  int _start = 60;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size * 2;
    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            height: screenSize.height,
            width: screenSize.width,
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [
            //       Color.fromARGB(255, 255, 255, 255),
            //       Color.fromARGB(255, 255, 255, 255)
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            // ),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 20)),
                Container(
                  width: 150,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color.fromARGB(255, 61, 60, 60),
                        width: .02),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/FL01.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const Column(
                  children: [
                    // Text(
                    //   "Join Our Famlynk!",
                    //   style: TextStyle(
                    //     fontSize: 28,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color.fromARGB(255, 0, 0, 0),
                    //   ),
                    // ),
                    // Center(
                    //   child: Text(
                    //     '',
                    //     style: TextStyle(
                    //         color: Color.fromARGB(255, 0, 0, 0),
                    //         fontSize: 28,
                    //         fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        'A family bond is priceless!',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 77, 209),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 129, 129, 129)
                            .withOpacity(0.5),
                        spreadRadius: 6,
                        blurRadius: 5,
                        offset: Offset(0, 9),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.fromLTRB(40, 100, 40, 30),
                  child: Column(
                    children: [
                      const Text(
                        "FAMLYNK",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      IntlPhoneField(
                        controller: phoneController,
                        initialCountryCode: 'IN',
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      Visibility(
                        visible: otpVisibility,
                        child: Column(
                          children: [
                            TextField(
                              controller: otpController,
                              decoration: const InputDecoration(
                                hintText: 'OTP',
                                prefix: Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Text(''),
                                ),
                              ),
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "start timings: 00 : $_start",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (otpVisibility) {
                            verifyOTP();
                          } else {
                            startTimer();
                            loginWithPhone();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 0, 77, 209)),
                        ),
                        child: Text(
                          otpVisibility ? "Verify" : "Get OTP ",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Create an account?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 77, 209),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 77, 209)),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {});
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          otpVisibility = true;

          setState(() {
            verificationID = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verificationID = verificationID;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NavBar(index: 0,))
            // uuid: user!.uid,
            );
        if (user != null) {
          try {
            LoginModel loginModel =
                LoginModel(phoneNumber: user!.phoneNumber, uuid: user!.uid);
            final res = await uidObj.UuidPostMethod(loginModel);
            Map<String, dynamic> respMap = json.decode(res);
            if (respMap["message"] == "Login Successful") {
              Fluttertoast.showToast(
                msg: "You are logged in successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                backgroundColor: Colors.blue,
                fontSize: 16.0,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavBar(index: 0,
                      // uuid: user!.uid,
                      ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: "your login is failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              // Navigator.pop(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>  FamLogin(
              //         users: user!.uid,
              //         ),
              //   ),
              // );
            }
          } catch (e) {
            print(e);
          }
        } else {
          Fluttertoast.showToast(
            msg: "your login is failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
    );
  }
}
