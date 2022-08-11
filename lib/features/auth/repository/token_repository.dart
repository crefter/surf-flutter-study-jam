import 'package:surf_practice_chat_flutter/core/interfaces/read.dart';
import 'package:surf_practice_chat_flutter/core/interfaces/write.dart';
import 'package:surf_practice_chat_flutter/features/auth/storages/secure_storage.dart';

import '../models/token_dto.dart';

abstract class ITokenRepository implements IRead<TokenDto>, IWrite<TokenDto> {
  Future<void> delete();
}

class TokenRepository implements ITokenRepository {
  static const String key = 'Token';
  final ISecureStorage<String> _secureStorage;

  TokenRepository(this._secureStorage);

  @override
  Future<TokenDto> read() async {
    return TokenDto(token: await _secureStorage.read(key));
  }

  @override
  Future<void> write(TokenDto value) async {
    await _secureStorage.write(key, value.token);
  }

  @override
  Future<void> delete() async {
    await _secureStorage.delete(key);
  }
}
