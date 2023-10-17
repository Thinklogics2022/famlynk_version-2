import 'dart:async';
import 'package:famlynk/mvc/model/login_model/verifyOtp_model.dart';
import 'package:famlynk/mvc/view/famlynkLogin/login/EmailLogin.dart';
import 'package:famlynk/services/login&registerService/verifyOtp_service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class OTPPage extends StatefulWidget {
  OTPPage({
    this.userId,
  });
  final String? userId;
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _otpController = TextEditingController();
  final OTPService _otpService = OTPService();
  Timer? _otpTimer;
  int _otpDuration = 120;
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _cancelOTPTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startOTPTimer();
  }

  void _startOTPTimer() {
    _cancelOTPTimer();
    _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _otpDuration--;
        if (_otpDuration <= 0) {
          _cancelOTPTimer();
        }
      });
    });
  }

  void _cancelOTPTimer() {
    if (_otpTimer != null && _otpTimer!.isActive) {
      _otpTimer!.cancel();
    }
  }

  void _verifyOTP() async {
    OTP otp = OTP(otp: _otpController.text);
    bool isVerified = await _otpService.verifyOTP(otp);
    if (isVerified) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('OTP verified successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('OTP verification failed.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _resendOTP(String userId) async {
    bool isResent = await _otpService.resendOTP(userId);
    if (isResent) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('OTP resent successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      setState(() {
        _otpDuration = 120;
      });
      _startOTPTimer();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to resend OTP.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      appBar: AppBar(
        backgroundColor: HexColor('#0175C8'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'OTP Verification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter OTP',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _otpController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    if (_otpDuration <= 0) {
                      _resendOTP(widget.userId.toString());
                    }
                  },
                  child: Text(
                    _otpDuration > 0
                        ? 'Resend OTP in $_otpDuration seconds'
                        : 'Resend OTP',
                    style: TextStyle(fontSize: 16, color: Colors.orange),
                  ),
                                  ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor('#0175C8'),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : Text("Verify OTP",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
            )

            // ElevatedButton(
            //   onPressed: () {
            //     print(_otpController.text);
            //     _verifyOTP();
            //   },
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            //   ),
            //   child: Text(
            //     "Verify",
            //     style: TextStyle(fontSize: 20, color: Colors.white),
            //   ),
            // ),
            // SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
