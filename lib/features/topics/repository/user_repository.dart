import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/core/interfaces/read.dart';
import 'package:surf_practice_chat_flutter/core/interfaces/write.dart';

abstract class IUserRepository implements IRead<String>, IWrite<String> {}

class UserRepository implements IUserRepository {
  late SharedPreferences sharedPref;
  final String key = 'user_name';

  @override
  Future<String> read(_) async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(key) ?? '';
  }

  @override
  Future<void> write(_, String value) async {
    sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(key, value);
  }
}
