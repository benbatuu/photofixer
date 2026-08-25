import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:photofixer/core/constants/app_constants.dart';
import 'package:photofixer/core/errors/api_exception.dart';
import 'package:photofixer/shared/models/photo_operation.dart';
import 'package:photofixer/shared/models/process_photo_result.dart';
import 'package:uuid/uuid.dart';

abstract class PhotoProcessingService {
  Future<ProcessPhotoResult> process({
    required File image,
    required PhotoOperation operation,
  });
}

class HttpPhotoProcessingService implements PhotoProcessingService {
  HttpPhotoProcessingService({
    required this.baseUrl,
    FirebaseAuth? auth,
    http.Client? client,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _client = client ?? http.Client();

  final String baseUrl;
  final FirebaseAuth _auth;
  final http.Client _client;
  final _uuid = const Uuid();

  @override
  Future<ProcessPhotoResult> process({
    required File image,
    required PhotoOperation operation,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ApiException(
        code: 'UNAUTHENTICATED',
        message: 'Not signed in',
      );
    }

    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw const ApiException(
        code: 'UNAUTHENTICATED',
        message: 'Missing ID token',
      );
    }

    final bytes = await image.readAsBytes();
    final jobId = _uuid.v4();
    final uri = Uri.parse('$baseUrl/v1/process');

    final response = await _client
        .post(
          uri,
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'jobId': jobId,
            'operation': operation.name,
            'imageBase64': base64Encode(bytes),
            'mimeType': 'image/jpeg',
          }),
        )
        .timeout(const Duration(seconds: 120));

    final body = _tryDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final code = body?['code'] as String? ?? 'INTERNAL_ERROR';
      final message = body?['message'] as String? ?? 'Request failed';
      final retryable = body?['retryable'] as bool? ?? false;
      throw ApiException(
        code: code,
        message: message,
        retryable: retryable,
        statusCode: response.statusCode,
      );
    }

    final resultUrl = body?['resultUrl'] as String?;
    if (resultUrl == null || resultUrl.isEmpty) {
      throw const ApiException(
        code: 'INTERNAL_ERROR',
        message: 'Missing result URL',
      );
    }

    return ProcessPhotoResult(
      jobId: body?['jobId'] as String? ?? jobId,
      operation: operation,
      resultUrl: resultUrl,
      originalPath: image.path,
      creditsCharged: (body?['creditsCharged'] as num?)?.toInt() ?? 1,
      latencyMs: (body?['latencyMs'] as num?)?.toInt() ?? 0,
      expiresInSeconds: (body?['expiresInSeconds'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic>? _tryDecode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }
}

String resolveApiBaseUrl() {
  const fromEnv = String.fromEnvironment('API_BASE_URL');
  if (fromEnv.isNotEmpty) return fromEnv;

  if (kIsWeb) return AppConstants.apiBaseUrl;
  if (Platform.isAndroid) {
    // Android emulator loopback to host machine.
    return 'http://10.0.2.2:8787';
  }
  return 'http://localhost:8787';
}

final photoProcessingServiceProvider = Provider<PhotoProcessingService>((ref) {
  return HttpPhotoProcessingService(baseUrl: resolveApiBaseUrl());
});
