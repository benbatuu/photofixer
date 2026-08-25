import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:photofixer/core/constants/image_limits.dart';

void main() {
  test('ImageLimits constants match MVP spec', () {
    expect(ImageLimits.maxInputBytes, 12 * 1024 * 1024);
    expect(ImageLimits.maxDimension, 4096);
    expect(ImageLimits.jpegQuality, 85);
  });

  test('long-edge resize math keeps aspect ratio under process max', () {
    final source = img.Image(width: 4000, height: 2000);
    img.fill(source, color: img.ColorRgb8(10, 20, 30));

    final longEdge =
        source.width > source.height ? source.width : source.height;
    expect(longEdge, greaterThan(ImageLimits.processMaxLongEdge));

    final resized = img.copyResize(
      source,
      width: ImageLimits.processMaxLongEdge,
      interpolation: img.Interpolation.linear,
    );

    expect(resized.width, ImageLimits.processMaxLongEdge);
    expect(resized.height, 1024);

    final jpg = Uint8List.fromList(
      img.encodeJpg(resized, quality: ImageLimits.jpegQuality),
    );
    expect(jpg, isNotEmpty);
  });
}
