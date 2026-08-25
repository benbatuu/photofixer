import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photofixer/app/router.dart';
import 'package:photofixer/core/theme/app_colors.dart';
import 'package:photofixer/core/theme/app_radius.dart';
import 'package:photofixer/core/theme/app_spacing.dart';
import 'package:photofixer/l10n/app_localizations.dart';
import 'package:photofixer/services/storage/local_storage.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  var _index = 0;

  static const _pageCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(localStorageProvider).setOnboardingCompleted(true);
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  void _next() {
    if (_index >= _pageCount - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isLast = _index == _pageCount - 1;

    final pages = [
      _OnboardingPageData(
        title: l10n.onboardingPage1Title,
        body: l10n.onboardingPage1Body,
        visual: const _HeroVisual(),
      ),
      _OnboardingPageData(
        title: l10n.onboardingPage2Title,
        body: l10n.onboardingPage2Body,
        visual: _BeforeAfterVisual(
          beforeLabel: l10n.demoBefore,
          afterLabel: l10n.demoAfter,
        ),
      ),
      _OnboardingPageData(
        title: l10n.onboardingPage3Title,
        body: l10n.onboardingPage3Body,
        visual: const _CreditsVisual(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(l10n.onboardingSkip),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: page.visual),
                        const SizedBox(height: AppSpacing.s24),
                        Text(page.title, style: textTheme.headlineLarge),
                        const SizedBox(height: AppSpacing.s12),
                        Text(page.body, style: textTheme.bodyMedium),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pageCount, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: active ? 18 : 6,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.s24),
              FilledButton(
                onPressed: _next,
                child: Text(isLast ? l10n.onboardingStart : l10n.onboardingNext),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.body,
    required this.visual,
  });

  final String title;
  final String body;
  final Widget visual;
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.s16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.16),
            AppColors.background,
          ],
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          AppLocalizations.of(context).appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
              ),
        ),
      ),
    );
  }
}

class _BeforeAfterVisual extends StatelessWidget {
  const _BeforeAfterVisual({
    required this.beforeLabel,
    required this.afterLabel,
  });

  final String beforeLabel;
  final String afterLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.s16),
        child: Row(
          children: [
            Expanded(
              child: ColoredBox(
                color: const Color(0xFFE8E8EE),
                child: Center(
                  child: Text(
                    beforeLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: AppColors.primary.withValues(alpha: 0.12),
                child: Center(
                  child: Text(
                    afterLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditsVisual extends StatelessWidget {
  const _CreditsVisual();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          '3',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
