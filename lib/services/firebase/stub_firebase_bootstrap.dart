import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photofixer/services/firebase/firebase_bootstrap.dart';

/// No-op Firebase init for widget/unit tests (no native Firebase in test VM).
class StubFirebaseBootstrap extends FirebaseBootstrap {
  const StubFirebaseBootstrap();

  @override
  Future<void> initialize() async {}
}

final stubFirebaseBootstrapProvider = Provider<FirebaseBootstrap>((ref) {
  return const StubFirebaseBootstrap();
});
