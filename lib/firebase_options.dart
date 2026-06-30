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
      default:
        throw UnsupportedError(
          'Firebase is not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCRU4Xfod4m2FHDlcWzyzrkxATh4ymFgG0',
    appId: '1:756278166038:web:16e03c7df54ebdec12eb37',
    messagingSenderId: '756278166038',
    projectId: 'waby-3a3b5',
    authDomain: 'waby-3a3b5.firebaseapp.com',
    databaseURL:
        'https://waby-3a3b5-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'waby-3a3b5.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnB4gPZ3PypFHYNF6KIUNJ4F8gxp5yAFg',
    appId: '1:756278166038:android:e5315224c84443ae12eb37',
    messagingSenderId: '756278166038',
    projectId: 'waby-3a3b5',
    databaseURL:
        'https://waby-3a3b5-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'waby-3a3b5.firebasestorage.app',
  );
}