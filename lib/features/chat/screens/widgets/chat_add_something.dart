import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/widgets/chat_add_list_item.dart';

class ChatAddSomething extends StatelessWidget {
  final List<String> buttons = ['Геометка'];

  ChatAddSomething({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pinkAccent, Colors.blue, Colors.amber],
        ),
      ),
      height: 100,
      child: Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return ChatAddListItem(
                buttons: buttons,
                index: index,
              );
            },
          ),
          Positioned(
            top: 25,
            left: width - 90,
            child: ElevatedButton(
              onPressed: () {
                context.read<ChatBloc>().add(const ChatEvent.back());
              },
              child: const Icon(
                Icons.arrow_forward,
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
