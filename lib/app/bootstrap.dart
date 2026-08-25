import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Ordered init stubs matching project.md §47.
/// Firebase / App Check / Auth / FCM / IAP will replace these stubs later.
class BootstrapController extends StateNotifier<BootstrapState> {
  BootstrapController(this._localStorage) : super(const BootstrapState.loading()) {
    run();
  }

  final LocalStorage _localStorage;

  Future<void> run() async {
    state = const BootstrapState.loading();
    try {
      await _step('firebase');
      await _step('app_check');
      await _step('auth');
      await _step('analytics');
      await _step('fcm');
      await _step('iap_listener');
      await _step('remote_config');
      await _step('min_version');
      state = BootstrapState.ready(
        onboardingCompleted: _localStorage.onboardingCompleted,
      );
    } catch (e) {
      state = BootstrapState.failed(e.toString());
    }
  }
}

Future<void> _step(String name) async {
  await Future<void>.delayed(const Duration(milliseconds: 80));
  assert(() {
    // ignore: avoid_print
    print('[bootstrap] $name ok (stub)');
    return true;
  }());
}

final bootstrapControllerProvider =
    StateNotifierProvider<BootstrapController, BootstrapState>(
  (ref) => BootstrapController(ref.watch(localStorageProvider)),
);
