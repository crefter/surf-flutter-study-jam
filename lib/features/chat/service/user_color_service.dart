import 'dart:math';

import 'package:surf_practice_chat_flutter/features/chat/repository/user_color_repository.dart';

class UserColorService {
  final Map<String, String> map = {};
  final IUserColorRepository _userColorRepository;

  UserColorService(this._userColorRepository);

  Future<String> getColorBy(String name) async {
    if (map.containsKey(name)) return map[name]!;
    String color = await _userColorRepository.read(name);
    if (color == '') {
      color = _randomColor();
      await _userColorRepository.write(name, color);
    }
    map.putIfAbsent(name, () => color);
    return color;
  }

  String _randomColor() {
    int r = Random().nextInt(256);
    int g = Random().nextInt(256);
    int b = Random().nextInt(256);
    String rStr = r.toRadixString(16);
    String gStr = g.toRadixString(16);
    String bStr = b.toRadixString(16);
    if (rStr.length == 1) rStr = rStr.padLeft(2, '0');
    if (gStr.length == 1) gStr = gStr.padLeft(2, '0');
    if (bStr.length == 1) bStr = bStr.padLeft(2, '0');
    return '$rStr$gStr$bStr';
  }
}
