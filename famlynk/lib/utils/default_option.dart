import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      apiKey: "AIzaSyBxOcfU_9W4eOfadSGGDFtlThAL57WMJXA",
      authDomain: "flutter-famlynk.firebaseapp.com",
      projectId: "flutter-famlynk",
      storageBucket: "flutter-famlynk.appspot.com",
      messagingSenderId: "704652533161",
      appId: "1:704652533161:web:9092f3e41545caa93278b8",
      measurementId: "G-9SFT57GNPS");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNFJ4ZcHq0c_UoaZOMnsxdjf64J8_bs2k',
    appId: '1:704652533161:android:cb6ded1356bb65e33278b8',
    messagingSenderId: '704652533161',
    projectId: "flutter-famlynk",
    storageBucket: "flutter-famlynk.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADAlJVsAlvX4yekAxgd84NuU1-ALF0Lm0',
    appId: '1:637905690799:ios:88f47a6f5de9318a6fb45a',
    messagingSenderId: '704652533161',
    projectId: 'authtutorial-de80c',
     storageBucket: "flutter-famlynk.appspot.com",
    iosClientId:
        '637905690799-9shnm980f8q6vjk9rbq6eih4tfp1l7jg.apps.googleusercontent.com',
    iosBundleId: 'com.example.modernlogintute',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADAlJVsAlvX4yekAxgd84NuU1-ALF0Lm0',
    appId: '1:637905690799:ios:88f47a6f5de9318a6fb45a',
    messagingSenderId: '637905690799',
    projectId: 'authtutorial-de80c',
    storageBucket: 'authtutorial-de80c.appspot.com',
    iosClientId:
        '637905690799-9shnm980f8q6vjk9rbq6eih4tfp1l7jg.apps.googleusercontent.com',
    iosBundleId: 'com.example.modernlogintute',
  );
}

