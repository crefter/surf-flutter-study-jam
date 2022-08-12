import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/core/interfaces/read.dart';
import 'package:surf_practice_chat_flutter/core/interfaces/write.dart';

abstract class IUserColorRepository implements IRead<String>, IWrite<String>{
}

class UserColorRepository implements IUserColorRepository {
  late SharedPreferences sharedPref;

  @override
  Future<String> read(String key) async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(key) ?? '';
  }

  @override
  Future<void> write(String key, String value) async {
    sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(key, value);
  }
}