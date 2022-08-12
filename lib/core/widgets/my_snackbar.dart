import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/core/colors.dart';

class MySnackbar extends StatelessWidget {
  final String text;

  const MySnackbar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: ColoredBox(
        color: AppColors.green,
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
