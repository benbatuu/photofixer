import 'package:cloud_firestore/cloud_firestore.dart';

/// `users/{uid}` document model (project.md §12).
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.platform,
    required this.locale,
    required this.credits,
    required this.onboardingCompleted,
    required this.notificationsEnabled,
  });

  factory UserProfile.newAnonymous({
    required String uid,
    required String platform,
    required String locale,
  }) {
    return UserProfile(
      uid: uid,
      platform: platform,
      locale: locale,
      credits: 3, // free allowance; rules lock later mutation by client
      onboardingCompleted: false,
      notificationsEnabled: false,
    );
  }

  final String uid;
  final String platform;
  final String locale;
  final int credits;
  final bool onboardingCompleted;
  final bool notificationsEnabled;

  Map<String, Object?> toCreateMap() {
    return {
      'platform': platform,
      'locale': locale,
      'credits': credits,
      'onboardingCompleted': onboardingCompleted,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    };
  }
}

/// App-wide remote config document `config/app`.
class AppConfig {
  const AppConfig({
    required this.freeCredits,
    required this.maxImageSizeMb,
    required this.maintenanceMode,
    required this.minAppVersionAndroid,
    required this.minAppVersionIos,
  });

  factory AppConfig.defaults() => const AppConfig(
        freeCredits: 3,
        maxImageSizeMb: 12,
        maintenanceMode: false,
        minAppVersionAndroid: '1.0.0',
        minAppVersionIos: '1.0.0',
      );

  factory AppConfig.fromMap(Map<String, dynamic>? data) {
    if (data == null) return AppConfig.defaults();
    return AppConfig(
      freeCredits: (data['freeCredits'] as num?)?.toInt() ?? 3,
      maxImageSizeMb: (data['maxImageSizeMb'] as num?)?.toInt() ?? 12,
      maintenanceMode: data['maintenanceMode'] as bool? ?? false,
      minAppVersionAndroid:
          data['minAppVersionAndroid'] as String? ?? '1.0.0',
      minAppVersionIos: data['minAppVersionIos'] as String? ?? '1.0.0',
    );
  }

  final int freeCredits;
  final int maxImageSizeMb;
  final bool maintenanceMode;
  final String minAppVersionAndroid;
  final String minAppVersionIos;
}
