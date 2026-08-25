import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photofixer/app/bootstrap.dart';
import 'package:photofixer/app/router.dart';
import 'package:photofixer/core/theme/app_spacing.dart';
import 'package:photofixer/l10n/app_localizations.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bootstrap = ref.watch(bootstrapControllerProvider);

    ref.listen<BootstrapState>(bootstrapControllerProvider, (previous, next) {
      if (next.status == BootstrapStatus.ready) {
        context.go(
          next.onboardingCompleted ? AppRoutes.home : AppRoutes.onboarding,
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: switch (bootstrap.status) {
            BootstrapStatus.failed => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.bootstrapFailedTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      l10n.bootstrapFailedMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    FilledButton(
                      onPressed: () =>
                          ref.read(bootstrapControllerProvider.notifier).run(),
                      child: Text(l10n.bootstrapRetry),
                    ),
                  ],
                ),
              ),
            _ => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.appName,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      l10n.splashLoading,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ],
                ),
              ),
          },
        ),
      ),
    );
  }
}
