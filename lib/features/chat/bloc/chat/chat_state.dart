part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.message(
      final Iterable<ChatMessageDto> currentMessages,
      ChatGeolocationDto geolocationDto,
      ChatMode mode) = ChatMessage;

  const factory ChatState.choose(final Iterable<ChatMessageDto> currentMessages,
      ChatGeolocationDto geolocationDto, ChatMode mode) = ChatChoose;
}
