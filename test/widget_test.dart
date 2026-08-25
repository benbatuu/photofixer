import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photofixer/app/app.dart';
import 'package:photofixer/services/firebase/firebase_bootstrap.dart';
import 'package:photofixer/services/firebase/stub_firebase_bootstrap.dart';
import 'package:photofixer/services/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  SharedPreferences.setMockInitialValues({});

  testWidgets('first launch shows onboarding', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          firebaseBootstrapProvider.overrideWithValue(
            const StubFirebaseBootstrap(),
          ),
        ],
        child: const PhotoFixerApp(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Make every photo look better.'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('completed onboarding goes to home', (tester) async {
    SharedPreferences.setMockInitialValues({
      LocalKeys.onboardingCompleted: true,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          firebaseBootstrapProvider.overrideWithValue(
            const StubFirebaseBootstrap(),
          ),
        ],
        child: const PhotoFixerApp(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Make your photos look better.'), findsOneWidget);
    expect(find.text('Enhance a photo'), findsOneWidget);
  });
}
