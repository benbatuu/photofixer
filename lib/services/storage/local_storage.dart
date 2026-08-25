import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class LocalKeys {
  static const onboardingCompleted = 'onboarding_completed';
  static const theme = 'theme';
  static const lastSelectedOperation = 'last_selected_operation';
  static const notificationPromptSeen = 'notification_prompt_seen';
}

class LocalStorage {
  LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  bool get onboardingCompleted =>
      _prefs.getBool(LocalKeys.onboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) =>
      _prefs.setBool(LocalKeys.onboardingCompleted, value);
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage(ref.watch(sharedPreferencesProvider));
});
