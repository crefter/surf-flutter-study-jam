part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.message(
      final Iterable<ChatMessageDto> currentMessages,
      ChatGeolocationDto geolocationDto,
      ChatMode mode,
      int chatId,
      String message) = ChatMessage;

  const factory ChatState.choose(
    final Iterable<ChatMessageDto> currentMessages,
    ChatGeolocationDto geolocationDto,
    ChatMode mode,
    int chatId,
    String message,
  ) = ChatChoose;
}
