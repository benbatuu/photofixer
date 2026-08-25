class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.retryable = false,
    this.statusCode,
  });

  final String code;
  final String message;
  final bool retryable;
  final int? statusCode;

  @override
  String toString() => 'ApiException($code): $message';
}

/// Maps API error codes to user-facing copy keys / fallback English.
String userMessageForApiCode(String code) {
  switch (code) {
    case 'UNAUTHENTICATED':
      return 'Please restart the app and try again.';
    case 'INVALID_IMAGE':
      return 'This image can\'t be processed. Try another one.';
    case 'IMAGE_TOO_LARGE':
      return 'This photo is too large. Try another one.';
    case 'INSUFFICIENT_CREDITS':
      return 'You\'re out of photo credits.';
    case 'GEMINI_TIMEOUT':
      return 'Processing took too long. Please try again.';
    case 'GEMINI_BLOCKED':
      return 'This image can\'t be processed.';
    case 'GEMINI_ERROR':
      return 'We couldn\'t process this photo. Try again.';
    case 'RATE_LIMITED':
      return 'Too many requests. Please wait a bit and try again.';
    case 'INTERNAL_ERROR':
      return 'Something went wrong. Please try again.';
    default:
      return 'We couldn\'t process this photo. Try again.';
  }
}
