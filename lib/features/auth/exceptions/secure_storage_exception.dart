import 'package:flutter/foundation.dart';

@immutable
class SecureStorageException implements Exception {
  final String message;

  const SecureStorageException(this.message);

  @override
  String toString() {
    return 'SecureStorageException{message: $message}';
  }
}