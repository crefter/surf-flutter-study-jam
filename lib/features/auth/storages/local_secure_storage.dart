import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:surf_practice_chat_flutter/features/auth/exceptions/secure_storage_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/storages/secure_storage.dart';

class LocalSecureStorage implements ISecureStorage<String> {
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions);
  }

  @override
  Future<String> read(String key) async {
    String? result =
        await _secureStorage.read(key: key, aOptions: _getAndroidOptions);
    if (result == null) {
      throw const SecureStorageException("Cannot read");
    } else {
      return result;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(
        key: key, value: value, aOptions: _getAndroidOptions);
  }

  AndroidOptions get _getAndroidOptions => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
