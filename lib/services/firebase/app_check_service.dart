import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppCheckService {
  const AppCheckService();

  Future<void> activate() async {
    try {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
        providerApple: kDebugMode
            ? const AppleDebugProvider()
            : const AppleAppAttestProvider(),
      );

      if (kDebugMode) {
        // ignore: avoid_print
        print('[app_check] activated (debug provider)');
      }
    } catch (e) {
      // Don't block app launch if App Check isn't configured in Console yet.
      if (kDebugMode) {
        // ignore: avoid_print
        print('[app_check] skipped: $e');
      }
    }
  }
}

final appCheckServiceProvider = Provider<AppCheckService>((ref) {
  return const AppCheckService();
});
