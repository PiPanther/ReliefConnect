// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyARb_d6Tq-RlbIwzy49cZEme8DgLzrrzIA',
    appId: '1:724626241427:web:0e58ffb67387ab02645a66',
    messagingSenderId: '724626241427',
    projectId: 'florel-b75ff',
    authDomain: 'florel-b75ff.firebaseapp.com',
    storageBucket: 'florel-b75ff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5vT9PiT6ThnJdqIfFLW3KaUU9m2rffPg',
    appId: '1:724626241427:android:3b42cebb74e0b772645a66',
    messagingSenderId: '724626241427',
    projectId: 'florel-b75ff',
    storageBucket: 'florel-b75ff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAyxnSzePvHKog8QbaQv6IdRBg-d2ad04',
    appId: '1:724626241427:ios:5ae690e51b68435e645a66',
    messagingSenderId: '724626241427',
    projectId: 'florel-b75ff',
    storageBucket: 'florel-b75ff.appspot.com',
    iosBundleId: 'com.example.frs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAAyxnSzePvHKog8QbaQv6IdRBg-d2ad04',
    appId: '1:724626241427:ios:5ae690e51b68435e645a66',
    messagingSenderId: '724626241427',
    projectId: 'florel-b75ff',
    storageBucket: 'florel-b75ff.appspot.com',
    iosBundleId: 'com.example.frs',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyARb_d6Tq-RlbIwzy49cZEme8DgLzrrzIA',
    appId: '1:724626241427:web:2f1fdabf968f8b17645a66',
    messagingSenderId: '724626241427',
    projectId: 'florel-b75ff',
    authDomain: 'florel-b75ff.firebaseapp.com',
    storageBucket: 'florel-b75ff.appspot.com',
  );
}
