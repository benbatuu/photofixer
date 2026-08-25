import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photofixer/services/firebase/auth_service.dart';
import 'package:photofixer/services/firebase/firebase_bootstrap.dart';
import 'package:photofixer/services/storage/local_storage.dart';

/// Boot pipeline status for splash → onboarding/home.
enum BootstrapStatus { idle, loading, ready, failed }

class BootstrapState {
  const BootstrapState({
    required this.status,
    this.errorMessage,
    this.onboardingCompleted = false,
  });

  const BootstrapState.loading()
      : status = BootstrapStatus.loading,
        errorMessage = null,
        onboardingCompleted = false;

  const BootstrapState.ready({required this.onboardingCompleted})
      : status = BootstrapStatus.ready,
        errorMessage = null;

  const BootstrapState.failed(this.errorMessage)
      : status = BootstrapStatus.failed,
        onboardingCompleted = false;

  final BootstrapStatus status;
  final String? errorMessage;
  final bool onboardingCompleted;
}

/// Ordered init matching project.md §47.
class BootstrapController extends StateNotifier<BootstrapState> {
  BootstrapController({
    required this._localStorage,
    required this._firebaseBootstrap,
    required this._hooks,
  }) : super(const BootstrapState.loading()) {
    run();
  }

  final LocalStorage _localStorage;
  final FirebaseBootstrap _firebaseBootstrap;
  final BootstrapHooks _hooks;

  Future<void> run() async {
    state = const BootstrapState.loading();
    try {
      await _firebaseBootstrap.initialize();
      await _hooks.initializeAppCheck();
      await _hooks.ensureAuthenticated();
      await _hooks.initializeAnalytics();
      await _hooks.initializeMessaging();
      await _hooks.startPurchaseListener();
      await _hooks.fetchRemoteConfig();
      await _hooks.checkMinimumVersion();

      state = BootstrapState.ready(
        onboardingCompleted: _localStorage.onboardingCompleted,
      );
    } catch (e) {
      state = BootstrapState.failed(e.toString());
    }
  }
}

/// Boot steps — Auth is live; remaining steps fill in across Day 3–11.
class BootstrapHooks {
  const BootstrapHooks({this.authService});

  final AuthService? authService;

  Future<void> initializeAppCheck() async {}

  Future<void> ensureAuthenticated() async {
    final auth = authService;
    if (auth == null) return;
    await auth.ensureAnonymousUser();
  }

  Future<void> initializeAnalytics() async {}
  Future<void> initializeMessaging() async {}
  Future<void> startPurchaseListener() async {}
  Future<void> fetchRemoteConfig() async {}
  Future<void> checkMinimumVersion() async {}
}

final bootstrapHooksProvider = Provider<BootstrapHooks>((ref) {
  return BootstrapHooks(authService: ref.watch(authServiceProvider));
});

final bootstrapControllerProvider =
    StateNotifierProvider<BootstrapController, BootstrapState>(
  (ref) => BootstrapController(
    localStorage: ref.watch(localStorageProvider),
    firebaseBootstrap: ref.watch(firebaseBootstrapProvider),
    hooks: ref.watch(bootstrapHooksProvider),
  ),
);
