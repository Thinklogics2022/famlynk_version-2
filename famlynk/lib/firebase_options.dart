// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAa3LAKeurfSvGnbUgp42Y3l9kkJMZbH1c',
    appId: '1:181855696046:web:08f998320aab3c5206e93f',
    messagingSenderId: '181855696046',
    projectId: 'famlynk-17bda',
    authDomain: 'famlynk-17bda.firebaseapp.com',
    storageBucket: 'famlynk-17bda.appspot.com',
    measurementId: 'G-SR2CT21250',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxbebxMyXVplmfntmtFGSbPCjf2Jh5APY',
    appId: '1:181855696046:android:b05f5ec4c1dbb60f06e93f',
    messagingSenderId: '181855696046',
    projectId: 'famlynk-17bda',
    storageBucket: 'famlynk-17bda.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdCvNRY4Hg5D9MjsW056cp1QLHsRwiPKA',
    appId: '1:181855696046:ios:9f32496f64d2042806e93f',
    messagingSenderId: '181855696046',
    projectId: 'famlynk-17bda',
    storageBucket: 'famlynk-17bda.appspot.com',
    iosBundleId: 'com.example.famlynk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAdCvNRY4Hg5D9MjsW056cp1QLHsRwiPKA',
    appId: '1:181855696046:ios:1355844f178e5ce806e93f',
    messagingSenderId: '181855696046',
    projectId: 'famlynk-17bda',
    storageBucket: 'famlynk-17bda.appspot.com',
    iosBundleId: 'com.example.famlynk.RunnerTests',
  );
}
