import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photofixer/app/router.dart';
import 'package:photofixer/core/theme/app_colors.dart';
import 'package:photofixer/core/theme/app_radius.dart';
import 'package:photofixer/core/theme/app_spacing.dart';
import 'package:photofixer/l10n/app_localizations.dart';
import 'package:photofixer/shared/models/process_photo_result.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final extra = GoRouterState.of(context).extra;
    final result = extra is ProcessPhotoResult ? extra : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: result == null
              ? Center(child: Text(l10n.resultPlaceholder))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.resultSuccess,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Expanded(
                      child: _BeforeAfterSlider(
                        beforePath: result.originalPath,
                        afterUrl: result.resultUrl,
                        beforeLabel: l10n.demoBefore,
                        afterLabel: l10n.demoAfter,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: Text(l10n.resultEnhanceAnother),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _BeforeAfterSlider extends StatefulWidget {
  const _BeforeAfterSlider({
    required this.beforePath,
    required this.afterUrl,
    required this.beforeLabel,
    required this.afterLabel,
  });

  final String beforePath;
  final String afterUrl;
  final String beforeLabel;
  final String afterLabel;

  @override
  State<_BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<_BeforeAfterSlider> {
  double _ratio = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final split = width * _ratio;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s16),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _ratio = (_ratio + details.delta.dx / width).clamp(0.05, 0.95);
                });
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.afterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _ratio,
                      child: SizedBox(
                        width: width,
                        child: Image.file(
                          File(widget.beforePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => ColoredBox(
                            color: AppColors.border,
                            child: Center(child: Text(widget.beforeLabel)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: split - 1,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 2, color: Colors.white),
                  ),
                  Positioned(
                    left: split - 18,
                    top: 0,
                    bottom: 0,
                    child: const Center(
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.compare_arrows, size: 18),
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.s12,
                    bottom: AppSpacing.s12,
                    child: _Badge(label: widget.beforeLabel),
                  ),
                  Positioned(
                    right: AppSpacing.s12,
                    bottom: AppSpacing.s12,
                    child: _Badge(label: widget.afterLabel),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s4,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
