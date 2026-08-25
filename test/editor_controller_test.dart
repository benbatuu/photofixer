import 'package:flutter_test/flutter_test.dart';
import 'package:photofixer/features/editor/presentation/editor_controller.dart';
import 'package:photofixer/services/network/photo_processing_service.dart';
import 'package:photofixer/services/storage/app_image_picker.dart';
import 'package:photofixer/services/storage/image_prep_service.dart';
import 'package:photofixer/shared/models/photo_operation.dart';
import 'package:photofixer/shared/models/process_photo_result.dart';
import 'dart:io';

class _FakeProcessing implements PhotoProcessingService {
  @override
  Future<ProcessPhotoResult> process({
    required File image,
    required PhotoOperation operation,
  }) async {
    throw StateError('should not be called while busy');
  }
}

void main() {
  test('EditorController blocks double submit while busy', () async {
    final controller = EditorController(
      operation: PhotoOperation.enhance,
      picker: AppImagePicker(),
      prepService: ImagePrepService(),
      processingService: _FakeProcessing(),
    );

    controller.state = controller.state.copyWith(
      phase: EditorPhase.selected,
      isBusy: true,
    );

    await controller.startProcessing();
    expect(controller.state.phase, EditorPhase.selected);

    controller.dispose();
  });
}
