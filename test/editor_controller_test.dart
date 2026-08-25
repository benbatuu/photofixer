import 'package:flutter_test/flutter_test.dart';
import 'package:photofixer/features/editor/presentation/editor_controller.dart';
import 'package:photofixer/services/storage/app_image_picker.dart';
import 'package:photofixer/services/storage/image_prep_service.dart';
import 'package:photofixer/shared/models/photo_operation.dart';

void main() {
  test('EditorController blocks double submit while busy', () async {
    final controller = EditorController(
      operation: PhotoOperation.enhance,
      picker: AppImagePicker(),
      prepService: ImagePrepService(),
    );

    controller.state = controller.state.copyWith(
      phase: EditorPhase.selected,
      isBusy: true,
    );

    await controller.startProcessing();
    expect(controller.state.phase, EditorPhase.selected);

    controller.state = controller.state.copyWith(isBusy: false);
    await controller.startProcessing();
    expect(controller.state.phase, EditorPhase.selected);

    controller.dispose();
  });
}
