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
    apiKey: 'AIzaSyCYh0WuQALuAfHfYq4S2EZjN-zII_Zr1cw',
    appId: '1:755534131144:web:08288acd6345c092351afd',
    messagingSenderId: '755534131144',
    projectId: 'ago-taxi-9a0be',
    authDomain: 'ago-taxi-9a0be.firebaseapp.com',
    storageBucket: 'ago-taxi-9a0be.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTrYfrwt_ux0GneXC5oUuUN9dio3EcRQA',
    appId: '1:755534131144:android:a92de577afd7a6a8351afd',
    messagingSenderId: '755534131144',
    projectId: 'ago-taxi-9a0be',
    storageBucket: 'ago-taxi-9a0be.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMt5R5VtialAsMiCgkqmHNXA5E_BwZ9KE',
    appId: '1:755534131144:ios:9f63272849fde880351afd',
    messagingSenderId: '755534131144',
    projectId: 'ago-taxi-9a0be',
    storageBucket: 'ago-taxi-9a0be.appspot.com',
    iosBundleId: 'com.example.deliveryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMt5R5VtialAsMiCgkqmHNXA5E_BwZ9KE',
    appId: '1:755534131144:ios:9f63272849fde880351afd',
    messagingSenderId: '755534131144',
    projectId: 'ago-taxi-9a0be',
    storageBucket: 'ago-taxi-9a0be.appspot.com',
    iosBundleId: 'com.example.deliveryApp',
  );
}
