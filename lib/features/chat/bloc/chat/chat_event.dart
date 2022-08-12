part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.pick(ChatMode mode) = ChatPick;

  const factory ChatEvent.back() = ChatBack;

  const factory ChatEvent.update(int chatId) = ChatUpdate;

  const factory ChatEvent.sendMessage(
    String message,
  ) = ChatSendMessage;

  const factory ChatEvent.attachGeolocation(
    ChatGeolocationDto geolocationDto,
  ) = ChatAttachGeolocation;

  const factory ChatEvent.openMap(ChatMessageGeolocationDto dto) = ChatOpenMap;
}
