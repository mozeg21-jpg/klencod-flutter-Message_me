import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWvFBfGzhfCGAMalgzcRCRj_48L8m_CVk',
    appId: '1:590411182335:android:7dc604c158edaaea755cca',
    messagingSenderId: '590411182335',
    projectId: 'muslim-d9113',
    databaseURL: 'https://muslim-d9113-default-rtdb.firebaseio.com',
    storageBucket: 'muslim-d9113.firebasestorage.app',
  );
}
