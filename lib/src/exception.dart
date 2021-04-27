/// CodeScanner Exception
class CodeScannerException implements Exception {
  CodeScannerException(
    this.code,
    this.message,
  );

  /// error code
  final code;

  /// error message
  final message;
}
