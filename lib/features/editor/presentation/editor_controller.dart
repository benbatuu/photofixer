import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photofixer/services/storage/app_image_picker.dart';
import 'package:photofixer/services/storage/image_prep_service.dart';
import 'package:photofixer/shared/models/photo_operation.dart';

/// Photo processing UI state machine (project.md §18).
enum EditorPhase {
  idle,
  selected,
  preparing,
  uploading,
  processing,
  completed,
  error,
}

class EditorState {
  const EditorState({
    required this.phase,
    required this.operation,
    this.originalPath,
    this.prepared,
    this.errorCode,
    this.errorMessage,
    this.isBusy = false,
  });

  factory EditorState.initial(PhotoOperation operation) => EditorState(
        phase: EditorPhase.idle,
        operation: operation,
      );

  final EditorPhase phase;
  final PhotoOperation operation;
  final String? originalPath;
  final PreparedImage? prepared;
  final String? errorCode;
  final String? errorMessage;
  final bool isBusy;

  EditorState copyWith({
    EditorPhase? phase,
    PhotoOperation? operation,
    String? originalPath,
    PreparedImage? prepared,
    String? errorCode,
    String? errorMessage,
    bool? isBusy,
    bool clearError = false,
    bool clearPrepared = false,
  }) {
    return EditorState(
      phase: phase ?? this.phase,
      operation: operation ?? this.operation,
      originalPath: originalPath ?? this.originalPath,
      prepared: clearPrepared ? null : (prepared ?? this.prepared),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isBusy: isBusy ?? this.isBusy,
    );
  }
}

class EditorController extends StateNotifier<EditorState> {
  EditorController({
    required PhotoOperation operation,
    required this._picker,
    required this._prepService,
  }) : super(EditorState.initial(operation));

  final AppImagePicker _picker;
  final ImagePrepService _prepService;

  void setOperation(PhotoOperation operation) {
    if (state.isBusy) return;
    state = state.copyWith(operation: operation);
  }

  Future<void> pick(ImagePickSource source) async {
    if (state.isBusy) return;

    try {
      final file = await _picker.pick(source);
      if (file == null) return;

      state = state.copyWith(
        phase: EditorPhase.preparing,
        isBusy: true,
        originalPath: file.path,
        clearError: true,
        clearPrepared: true,
      );

      final prepared = await _prepService.prepareForUpload(File(file.path));

      state = state.copyWith(
        phase: EditorPhase.selected,
        prepared: prepared,
        isBusy: false,
      );
    } on ImagePreparationException catch (e) {
      state = state.copyWith(
        phase: EditorPhase.error,
        isBusy: false,
        errorCode: e.code,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        phase: EditorPhase.error,
        isBusy: false,
        errorCode: 'INVALID_IMAGE',
        errorMessage: 'Could not read this photo',
      );
    }
  }

  /// Backend wiring comes in Epic 5 — stub advances through phases safely.
  Future<void> startProcessing() async {
    if (state.isBusy || state.prepared == null) return;
    if (state.phase != EditorPhase.selected &&
        state.phase != EditorPhase.error) {
      return;
    }

    state = state.copyWith(
      phase: EditorPhase.uploading,
      isBusy: true,
      clearError: true,
    );

    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    state = state.copyWith(phase: EditorPhase.processing);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // Stub success until Gemini Cloud Function exists.
    state = state.copyWith(
      phase: EditorPhase.completed,
      isBusy: false,
    );
  }

  void resetErrorToSelected() {
    if (state.prepared == null) {
      state = EditorState.initial(state.operation);
      return;
    }
    state = state.copyWith(
      phase: EditorPhase.selected,
      clearError: true,
      isBusy: false,
    );
  }
}

final appImagePickerProvider = Provider<AppImagePicker>((ref) {
  return AppImagePicker();
});

final imagePrepServiceProvider = Provider<ImagePrepService>((ref) {
  return ImagePrepService();
});

final editorControllerProvider = StateNotifierProvider.autoDispose
    .family<EditorController, EditorState, PhotoOperation>((ref, operation) {
  return EditorController(
    operation: operation,
    picker: ref.watch(appImagePickerProvider),
    prepService: ref.watch(imagePrepServiceProvider),
  );
});
