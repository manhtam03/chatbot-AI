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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyATMOt-G1g30QvVtDXD_6Vmo8I8RzeTxUc',
    appId: '1:176819446417:web:61bb478dfea94b63d31530',
    messagingSenderId: '176819446417',
    projectId: 'chatbot-app-d7242',
    authDomain: 'chatbot-app-d7242.firebaseapp.com',
    storageBucket: 'chatbot-app-d7242.firebasestorage.app',
    measurementId: 'G-M41969JVYC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCekYZGA6gtYZ_DcoJYmdGXZT4kDFIj78A',
    appId: '1:176819446417:android:ab5d43ad148ef7d7d31530',
    messagingSenderId: '176819446417',
    projectId: 'chatbot-app-d7242',
    storageBucket: 'chatbot-app-d7242.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-lM3-oRMD4DsPFNSP0cxsSjA53a89Vvg',
    appId: '1:176819446417:ios:03ae7ae930e6e3b6d31530',
    messagingSenderId: '176819446417',
    projectId: 'chatbot-app-d7242',
    storageBucket: 'chatbot-app-d7242.firebasestorage.app',
    iosBundleId: 'com.example.chatbot',
  );
}
