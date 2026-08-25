import 'package:flutter_test/flutter_test.dart';
import 'package:photofixer/core/errors/api_exception.dart';

void main() {
  test('maps API codes to friendly messages', () {
    expect(userMessageForApiCode('INSUFFICIENT_CREDITS'), contains('credits'));
    expect(userMessageForApiCode('GEMINI_BLOCKED'), contains("can't be processed"));
    expect(userMessageForApiCode('UNKNOWN_CODE'), contains('Try again'));
  });
}
