import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photofixer/app/router.dart';
import 'package:photofixer/core/theme/app_colors.dart';
import 'package:photofixer/core/theme/app_radius.dart';
import 'package:photofixer/core/theme/app_spacing.dart';
import 'package:photofixer/l10n/app_localizations.dart';
import 'package:photofixer/shared/models/photo_operation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s24,
            AppSpacing.s16,
            AppSpacing.s24,
            AppSpacing.s48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.homeGreeting,
                    style: textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  tooltip: l10n.settingsTitle,
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(l10n.homeHeadline, style: textTheme.headlineLarge),
            const SizedBox(height: AppSpacing.s24),
            _DemoBeforeAfter(
              beforeLabel: l10n.demoBefore,
              afterLabel: l10n.demoAfter,
            ),
            const SizedBox(height: AppSpacing.s16),
            FilledButton(
              onPressed: () => context.push(
                '${AppRoutes.editor}?op=${PhotoOperation.enhance.name}',
              ),
              child: Text(l10n.homePrimaryCta),
            ),
            const SizedBox(height: AppSpacing.s32),
            Text(l10n.homeChooseImprovement, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                _OperationChip(
                  label: l10n.operationEnhance,
                  icon: Icons.auto_awesome_outlined,
                  onTap: () => context.push(
                    '${AppRoutes.editor}?op=${PhotoOperation.enhance.name}',
                  ),
                ),
                _OperationChip(
                  label: l10n.operationRelight,
                  icon: Icons.wb_sunny_outlined,
                  onTap: () => context.push(
                    '${AppRoutes.editor}?op=${PhotoOperation.relight.name}',
                  ),
                ),
                _OperationChip(
                  label: l10n.operationUnblur,
                  icon: Icons.blur_off_outlined,
                  onTap: () => context.push(
                    '${AppRoutes.editor}?op=${PhotoOperation.unblur.name}',
                  ),
                ),
                _OperationChip(
                  label: l10n.operationRestore,
                  icon: Icons.history_edu_outlined,
                  onTap: () => context.push(
                    '${AppRoutes.editor}?op=${PhotoOperation.restore.name}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s32),
            Text(l10n.homeRecent, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s12),
            Text(l10n.homeRecentEmpty, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoBeforeAfter extends StatelessWidget {
  const _DemoBeforeAfter({
    required this.beforeLabel,
    required this.afterLabel,
  });

  final String beforeLabel;
  final String afterLabel;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: DecoratedBox(
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
      ),
    );
  }
}

class _OperationChip extends StatelessWidget {
  const _OperationChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.s8),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
