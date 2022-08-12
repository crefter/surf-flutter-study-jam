import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/core/consts.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/topics_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';

class ListTopicsWidget extends StatelessWidget {
  final ScrollController _scrollController;
  final void Function(int) callback;

  const ListTopicsWidget(
      {Key? key,
      required this.callback,
      required ScrollController scrollController})
      : _scrollController = scrollController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicsBloc, TopicsState>(builder: (context, state) {
      final List<ChatTopicDto> topics = state.maybeWhen(
        orElse: () => [],
        loaded: (topics, _) => topics.toList(),
      );
      return ListView.separated(
        controller: _scrollController,
        itemCount: topics.length,
        padding: const EdgeInsets.only(top: AppConsts.defaultGapBetweenWidgets),
        itemBuilder: (context, index) {
          var topic = topics[index];
          return InkWell(
            onTap: () => callback(topic.id),
            child: SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(topic.name ?? ''),
                  const SizedBox(height: AppConsts.defaultGapBetweenWidgets),
                  Text(topic.description ?? ''),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    });
  }
}
