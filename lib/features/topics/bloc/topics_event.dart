part of 'topics_bloc.dart';

@freezed
class TopicsEvent with _$TopicsEvent {
  const factory TopicsEvent.open(String userName) = TopicsOpen;

  const factory TopicsEvent.update(String userName) = TopicsUpdate;

  const factory TopicsEvent.createNewChat(String name, String description) =
      TopicsCreateNewChat;
}
