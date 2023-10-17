// ignore_for_file: unused_field

import 'package:famlynk/firebase_options.dart';
import 'package:famlynk/mvc/view/famlynkLogin/splashScree/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hexcolor/hexcolor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _primaryColor = HexColor('#0175C8');
  Color _accentColor = HexColor('#FF6F20');
  String _errorMessage = "";
  bool _isConnected = true;
  Future<void> _checkConnectivity() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _isConnected = false;
          _errorMessage = "No Network Connection";
        });
      } else {
        setState(() {
          _isConnected = true;
          _errorMessage = "";
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _isConnected = false;
        _errorMessage = "Network Error: ${e.message}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: _primaryColor,
        hintColor: _accentColor,
        scaffoldBackgroundColor : Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
      // home: FutureBuilder<bool>(
      //   future: isLoggedIn(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     } else {
      //       final bool isLoggedIn = snapshot.data ?? true;
      //       return isLoggedIn ? NavBar() : LoginPage();
      //     }
      //   },
      // ),
    );
  }
}

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}
