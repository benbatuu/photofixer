import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photofixer/app/router.dart';
import 'package:photofixer/core/theme/app_colors.dart';
import 'package:photofixer/core/theme/app_radius.dart';
import 'package:photofixer/core/theme/app_spacing.dart';
import 'package:photofixer/features/editor/presentation/editor_controller.dart';
import 'package:photofixer/l10n/app_localizations.dart';
import 'package:photofixer/services/storage/app_image_picker.dart';
import 'package:photofixer/shared/models/photo_operation.dart';

class EditorScreen extends ConsumerWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final opName = GoRouterState.of(context).uri.queryParameters['op'];
    final operation = PhotoOperation.values.asNameMap()[opName] ??
        PhotoOperation.enhance;

    final state = ref.watch(editorControllerProvider(operation));
    final controller = ref.read(editorControllerProvider(operation).notifier);

    ref.listen<EditorState>(editorControllerProvider(operation), (prev, next) {
      if (next.phase == EditorPhase.completed) {
        context.push(AppRoutes.result);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(_operationLabel(l10n, state.operation))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.editorPermissionHint,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.s16),
              Expanded(child: _PreviewArea(state: state, l10n: l10n)),
              const SizedBox(height: AppSpacing.s16),
              if (state.phase == EditorPhase.idle ||
                  (state.phase == EditorPhase.error &&
                      state.originalPath == null)) ...[
                FilledButton.icon(
                  onPressed: state.isBusy
                      ? null
                      : () => controller.pick(ImagePickSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.editorPickGallery),
                ),
                const SizedBox(height: AppSpacing.s8),
                OutlinedButton.icon(
                  onPressed: state.isBusy
                      ? null
                      : () => controller.pick(ImagePickSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.editorPickCamera),
                ),
              ] else ...[
                if (state.phase == EditorPhase.error) ...[
                  Text(
                    _errorMessage(l10n, state.errorCode),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  FilledButton(
                    onPressed: controller.resetErrorToSelected,
                    child: Text(l10n.editorTryAgain),
                  ),
                ] else if (state.phase == EditorPhase.selected) ...[
                  FilledButton(
                    onPressed: state.isBusy ? null : controller.startProcessing,
                    child: Text(l10n.editorStartProcessing),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  TextButton(
                    onPressed: state.isBusy
                        ? null
                        : () => controller.pick(ImagePickSource.gallery),
                    child: Text(l10n.editorChangePhoto),
                  ),
                ] else if (state.isBusy) ...[
                  FilledButton(
                    onPressed: null,
                    child: Text(_busyLabel(l10n, state.phase)),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _operationLabel(AppLocalizations l10n, PhotoOperation op) {
    return switch (op) {
      PhotoOperation.enhance => l10n.operationEnhance,
      PhotoOperation.relight => l10n.operationRelight,
      PhotoOperation.unblur => l10n.operationUnblur,
      PhotoOperation.restore => l10n.operationRestore,
    };
  }

  String _busyLabel(AppLocalizations l10n, EditorPhase phase) {
    return switch (phase) {
      EditorPhase.preparing => l10n.editorPreparing,
      EditorPhase.uploading => l10n.editorUploading,
      EditorPhase.processing => l10n.editorProcessing,
      _ => l10n.editorPreparing,
    };
  }

  String _errorMessage(AppLocalizations l10n, String? code) {
    return switch (code) {
      'IMAGE_TOO_LARGE' => l10n.editorErrorTooLarge,
      'INVALID_IMAGE' => l10n.editorErrorInvalid,
      _ => l10n.editorErrorTitle,
    };
  }
}

class _PreviewArea extends StatelessWidget {
  const _PreviewArea({required this.state, required this.l10n});

  final EditorState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final path = state.prepared?.uploadFile.path ?? state.originalPath;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.s16),
        child: path == null
            ? Center(
                child: Text(
                  l10n.editorPickTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(path), fit: BoxFit.contain),
                  if (state.isBusy)
                    ColoredBox(
                      color: Colors.black.withValues(alpha: 0.35),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
