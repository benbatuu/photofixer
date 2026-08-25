import 'package:flutter_test/flutter_test.dart';
import 'package:photofixer/shared/models/user_profile.dart';

void main() {
  test('new anonymous user gets 3 free credits', () {
    final profile = UserProfile.newAnonymous(
      uid: 'uid-1',
      platform: 'ios',
      locale: 'en_US',
    );

    expect(profile.credits, 3);
    final map = profile.toCreateMap();
    expect(map['credits'], 3);
    expect(map['platform'], 'ios');
    expect(map.containsKey('createdAt'), isTrue);
  });

  test('AppConfig falls back to defaults', () {
    final config = AppConfig.fromMap(null);
    expect(config.freeCredits, 3);
    expect(config.maxImageSizeMb, 12);
    expect(config.maintenanceMode, isFalse);
  });
}
