import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as concurrency;
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_location_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_mode.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/geolocation_repository.dart';

part 'chat_event.dart';

part 'chat_state.dart';

part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IChatRepository _chatRepository;
  final IGeolocationRepository _geolocationRepository;

  ChatBloc(
    this._chatRepository,
    this._geolocationRepository,
  ) : super(ChatState.message(
          [],
          ChatGeolocationDto.empty(),
          ChatMode.message(),
        )) {
    on<ChatEvent>(
      (event, emit) async {
        await event.when(
          pick: (mode) => _pick(mode, emit),
          back: () => _back(emit),
          update: () => _update(emit),
          sendMessage: (message) => _sendMessage(message, emit),
          openMap: (dto) => _openMap(dto, emit),
          attachGeolocation: (geolocation) =>
              _attachGeolocation(geolocation, emit),
        );
      },
      transformer: concurrency.droppable(),
    );
    add(const ChatEvent.update());
  }

  Future<void> _pick(ChatMode mode, Emitter<ChatState> emit) async {
    if (mode == ChatMode.choose()) {
      emit(ChatState.choose(
          state.currentMessages, state.geolocationDto, ChatMode.choose()));
    } else {
      emit(ChatState.message(
          state.currentMessages, state.geolocationDto, ChatMode.message()));
    }
  }

  Future<void> _back(Emitter<ChatState> emit) async {
    if (state is ChatChoose) {
      emit(ChatState.message(
          state.currentMessages, state.geolocationDto, ChatMode.message()));
    }
  }

  Future<void> _update(Emitter<ChatState> emit) async {
    final messages = await _chatRepository.getMessages();
    emit(ChatState.message(messages, state.geolocationDto, state.mode));
  }

  Future<void> _sendMessage(String message, Emitter<ChatState> emit) async {
    if (state.geolocationDto != ChatGeolocationDto.empty()) {
      final messages = await _chatRepository.sendGeolocationMessage(
        location: state.geolocationDto,
        message: message,
      );
      emit(ChatState.message(messages, ChatGeolocationDto.empty(), state.mode));
    } else {
      final messages = await _chatRepository.sendMessage(message);
      emit(ChatState.message(messages, state.geolocationDto, state.mode));
    }
  }

  Future<void> _openMap(
      ChatMessageGeolocationDto dto, Emitter<ChatState> emit) async {
    final hasChecked = await _geolocationRepository.checkPermission();
    if (hasChecked) {
      await _geolocationRepository.openMap(dto.location);
    }
  }

  Future<void> _attachGeolocation(
    ChatGeolocationDto geolocation,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatState.message(state.currentMessages, geolocation, state.mode));
  }
}
