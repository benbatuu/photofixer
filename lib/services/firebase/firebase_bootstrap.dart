import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Thin Firebase Core wrapper so bootstrap/tests can swap implementations.
class FirebaseBootstrap {
  const FirebaseBootstrap();

  Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) return;
    await Firebase.initializeApp();
    if (kDebugMode) {
      // ignore: avoid_print
      print('[firebase] initialized (${Firebase.app().name})');
    }
  }
}

final firebaseBootstrapProvider = Provider<FirebaseBootstrap>((ref) {
  return const FirebaseBootstrap();
});
