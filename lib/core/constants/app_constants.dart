/// App-wide constants that are safe to hardcode (not prices, not secrets).
abstract final class AppConstants {
  static const String appName = 'Photo Fixer';
  static const String packageId = 'com.bennbatuu.photofixer';
  static const String minAppVersion = '1.0.0';

  /// Processing API base URL (override per flavor later).
  /// Android emulator → http://10.0.2.2:8787
  /// iOS simulator → http://localhost:8787
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8787',
  );
}
