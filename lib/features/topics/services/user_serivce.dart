import 'package:surf_practice_chat_flutter/features/topics/repository/user_repository.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class UserService {
  final IUserRepository _userRepository;
  final StudyJamClient? _client;

  UserService(this._userRepository, this._client);

  Future<String> getUserName() async {
    if (_client == null) return '';
    final userName = await _userRepository.read('');
    try {
      if (userName == '') {
        final user = await _client?.getUser();
        final username = user?.username ?? '';
        await _userRepository.write('', username);
        return username;
      } else {
        final user = await _client?.getUser();
        final username = user?.username ?? '';
        if (username != userName) {
          await _userRepository.write('', username);
        }
        return username;
      }
    } catch (_) {
      return '';
    }
  }
}