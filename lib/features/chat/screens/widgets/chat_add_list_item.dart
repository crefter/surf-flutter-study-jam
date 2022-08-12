import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/adding/attach_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/chat/chat_bloc.dart';

class ChatAddListItem extends StatelessWidget {
  final List<String> buttons;
  final int index;
  const ChatAddListItem({Key? key, required this.buttons, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shape: const CircleBorder(side: BorderSide.none),
        ),
        onPressed: () {
          context
              .read<AttachBloc>()
              .add(const AttachEvent.pickGeolocation());
          context.read<ChatBloc>().add(const ChatEvent.back());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttons[index],
            ),
            const SizedBox(
              height: 4.0,
            ),
            const Icon(Icons.add_location_alt_outlined),
          ],
        ),
      ),
    );
  }
}
