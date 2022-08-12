import 'package:surf_practice_chat_flutter/features/auth/exceptions/secure_storage_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/token_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/storages/local_secure_storage.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class TokenService {
  final ITokenRepository tokenRepository;

  TokenService(this.tokenRepository);

  Future<StudyJamClient?> getClient() async {
    TokenDto? token;
    StudyJamClient? client;
    try {
      token = await TokenRepository(LocalSecureStorage()).read('');
    } on SecureStorageException {
      token = null;
    }
    if (token != null) {
      client = StudyJamClient().getAuthorizedClient(token.token);
    } else {
      client = null;
    }
    return client;
  }
}