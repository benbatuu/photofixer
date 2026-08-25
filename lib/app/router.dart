import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photofixer/features/editor/presentation/editor_screen.dart';
import 'package:photofixer/features/home/presentation/home_screen.dart';
import 'package:photofixer/features/onboarding/presentation/onboarding_screen.dart';
import 'package:photofixer/features/paywall/presentation/paywall_screen.dart';
import 'package:photofixer/features/result/presentation/result_screen.dart';
import 'package:photofixer/features/settings/presentation/settings_screen.dart';
import 'package:photofixer/features/splash/presentation/splash_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const onboarding = '/onboarding';
  static const editor = '/editor';
  static const result = '/result';
  static const paywall = '/paywall';
  static const settings = '/settings';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.editor,
        builder: (context, state) => const EditorScreen(),
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: AppRoutes.paywall,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter();
  ref.onDispose(router.dispose);
  return router;
});
