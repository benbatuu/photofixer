import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photofixer/shared/models/user_profile.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Anonymous sign-in + ensure `users/{uid}` exists (no email/signup).
  Future<User> ensureAnonymousUser() async {
    final existing = _auth.currentUser;
    final user = existing ?? (await _auth.signInAnonymously()).user;
    if (user == null) {
      throw StateError('Anonymous sign-in returned null user');
    }

    await _ensureUserDocument(user);
    return user;
  }

  Future<void> _ensureUserDocument(User user) async {
    final ref = _firestore.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.set(
        {
          'lastActiveAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return;
    }

    final profile = UserProfile.newAnonymous(
      uid: user.uid,
      platform: _platformLabel(),
      locale: Platform.localeName,
    );

    await ref.set(profile.toCreateMap());
    if (kDebugMode) {
      // ignore: avoid_print
      print('[auth] created users/${user.uid}');
    }
  }

  String _platformLabel() {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'other';
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
