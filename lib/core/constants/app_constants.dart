/// App-wide constants that are safe to hardcode (not prices, not secrets).
abstract final class AppConstants {
  static const String appName = 'Photo Fixer';
  static const String packageId = 'com.bennbatuu.photofixer';
  static const String minAppVersion = '1.0.0';

  /// Override with `--dart-define=API_BASE_URL=https://...` for device/prod.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8787',
  );
}
