part of 'topics_bloc.dart';

@freezed
class TopicsState with _$TopicsState {
  const factory TopicsState.initial() = TopicsInitial;

  const factory TopicsState.inProgress(
      List<ChatTopicDto> topics, String userName) = TopicsInProgress;

  const factory TopicsState.loaded(
      Iterable<ChatTopicDto> topics, String userName) = TopicsLoaded;

  const factory TopicsState.error(String userName, String messageException) =
      TopicsError;
}
