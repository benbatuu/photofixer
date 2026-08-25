import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photofixer/core/constants/image_limits.dart';

class PreparedImage {
  const PreparedImage({
    required this.originalPath,
    required this.uploadFile,
    required this.width,
    required this.height,
    required this.byteLength,
  });

  final String originalPath;
  final File uploadFile;
  final int width;
  final int height;
  final int byteLength;
}

class ImagePreparationException implements Exception {
  ImagePreparationException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'ImagePreparationException($code): $message';
}

/// Compress / resize for API upload while keeping the original on device.
class ImagePrepService {
  Future<PreparedImage> prepareForUpload(File original) async {
    if (!await original.exists()) {
      throw ImagePreparationException('INVALID_IMAGE', 'File not found');
    }

    final originalSize = await original.length();
    if (originalSize > ImageLimits.maxInputBytes) {
      throw ImagePreparationException(
        'IMAGE_TOO_LARGE',
        'Image exceeds ${ImageLimits.maxInputBytes ~/ (1024 * 1024)} MB',
      );
    }

    final bytes = await original.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw ImagePreparationException('INVALID_IMAGE', 'Unsupported image');
    }

    // decodeImage applies EXIF orientation when present.
    final oriented = img.bakeOrientation(decoded);

    if (oriented.width > ImageLimits.maxDimension ||
        oriented.height > ImageLimits.maxDimension) {
      throw ImagePreparationException(
        'IMAGE_TOO_LARGE',
        'Image exceeds ${ImageLimits.maxDimension}px',
      );
    }

    final resized = _resizeLongEdge(oriented, ImageLimits.processMaxLongEdge);

    final tempDir = await getTemporaryDirectory();
    final outPath = p.join(
      tempDir.path,
      'pf_upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    Uint8List? compressed = await FlutterImageCompress.compressWithList(
      Uint8List.fromList(img.encodeJpg(resized, quality: 95)),
      quality: ImageLimits.jpegQuality,
      format: CompressFormat.jpeg,
      keepExif: false,
    );

    if (compressed.isEmpty) {
      compressed = Uint8List.fromList(
        img.encodeJpg(resized, quality: ImageLimits.jpegQuality),
      );
    }

    final outFile = File(outPath);
    await outFile.writeAsBytes(compressed, flush: true);

    return PreparedImage(
      originalPath: original.path,
      uploadFile: outFile,
      width: resized.width,
      height: resized.height,
      byteLength: compressed.length,
    );
  }

  img.Image _resizeLongEdge(img.Image source, int maxLongEdge) {
    final longEdge = source.width > source.height ? source.width : source.height;
    if (longEdge <= maxLongEdge) return source;

    if (source.width >= source.height) {
      return img.copyResize(
        source,
        width: maxLongEdge,
        interpolation: img.Interpolation.linear,
      );
    }
    return img.copyResize(
      source,
      height: maxLongEdge,
      interpolation: img.Interpolation.linear,
    );
  }
}
