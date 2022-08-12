import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_send_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';

part 'topics_event.dart';

part 'topics_state.dart';

part 'topics_bloc.freezed.dart';

class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  IChatTopicsRepository _topicsRepository;

  TopicsBloc(this._topicsRepository) : super(const TopicsState.initial()) {
    on<TopicsEvent>((event, emit) async {
      await event.map<Future<void>>(
        open: (event) => _open(event, emit),
        update: (event) => _update(event, emit),
        createNewChat: (event) => _createNewChat(event, emit),
      );
    });
  }

  Future<void> _open(TopicsOpen event, Emitter<TopicsState> emit) async {
    try {
      emit(TopicsState.inProgress([], event.userName));
      final topics = await _topicsRepository.getTopics(
          topicsStartDate: DateTime.now().subtract(const Duration(days: 1)));
      emit(TopicsState.loaded(topics, event.userName));
    } catch (e) {
      emit(TopicsState.error(event.userName, 'Error'));
      add(TopicsEvent.update(event.userName));
    }
  }

  Future<void> _update(TopicsUpdate event, Emitter<TopicsState> emit) async {
    try {
      emit(TopicsState.inProgress([], event.userName));
      final topics = await _topicsRepository.getTopics(
          topicsStartDate: DateTime.now().subtract(const Duration(days: 1)));
      emit(TopicsState.loaded(topics, event.userName));
    } catch (e) {
      emit(TopicsState.error(event.userName, 'Error'));
    }
  }

  Future<void> _createNewChat(
      TopicsCreateNewChat event, Emitter<TopicsState> emit) async {
    await _topicsRepository.createTopic(
        ChatTopicSendDto(name: event.name, description: event.description));
    add(TopicsEvent.update(state.when(
        initial: () => '',
        inProgress: (_, userName) => userName,
        loaded: (_, userName) => userName,
        error: (_, userName) => userName)));
  }
}
