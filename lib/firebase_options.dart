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
    apiKey: 'AIzaSyBC3yAz6E8dMEDtKsOeJJju5OfGe5wZBxo',
    appId: '1:224199405058:web:5dbad28acf8c980deb411b',
    messagingSenderId: '224199405058',
    projectId: 'koperasi-yamaha',
    authDomain: 'koperasi-yamaha.firebaseapp.com',
    storageBucket: 'koperasi-yamaha.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqoy-bs-uAUsQfeLEgjpATvM9lZ3OSdHg',
    appId: '1:224199405058:android:3834f499293b2e85eb411b',
    messagingSenderId: '224199405058',
    projectId: 'koperasi-yamaha',
    storageBucket: 'koperasi-yamaha.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9SKBSTW1LR9Tlfd5wFQNB6_acyQWksyI',
    appId: '1:224199405058:ios:b4ed57251474ed59eb411b',
    messagingSenderId: '224199405058',
    projectId: 'koperasi-yamaha',
    storageBucket: 'koperasi-yamaha.appspot.com',
    androidClientId: '224199405058-1in8g856jc8oamc44oq420q13o31lgp7.apps.googleusercontent.com',
    iosClientId: '224199405058-jr08dco3qd55ch181ofb0jmnflt81ne2.apps.googleusercontent.com',
    iosBundleId: 'com.inovatif78.hp3ki',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB9SKBSTW1LR9Tlfd5wFQNB6_acyQWksyI',
    appId: '1:224199405058:ios:b4ed57251474ed59eb411b',
    messagingSenderId: '224199405058',
    projectId: 'koperasi-yamaha',
    storageBucket: 'koperasi-yamaha.appspot.com',
    androidClientId: '224199405058-1in8g856jc8oamc44oq420q13o31lgp7.apps.googleusercontent.com',
    iosClientId: '224199405058-jr08dco3qd55ch181ofb0jmnflt81ne2.apps.googleusercontent.com',
    iosBundleId: 'com.inovatif78.hp3ki',
  );
}
