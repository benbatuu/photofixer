import 'package:photofixer/shared/models/photo_operation.dart';

class ProcessPhotoResult {
  const ProcessPhotoResult({
    required this.jobId,
    required this.operation,
    required this.resultUrl,
    required this.originalPath,
    required this.creditsCharged,
    required this.latencyMs,
    this.expiresInSeconds,
  });

  final String jobId;
  final PhotoOperation operation;
  final String resultUrl;
  final String originalPath;
  final int creditsCharged;
  final int latencyMs;
  final int? expiresInSeconds;
}
