import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/geolocation_repository.dart';

part 'attach_event.dart';

part 'attach_state.dart';

part 'attach_bloc.freezed.dart';

class AttachBloc extends Bloc<AttachEvent, AttachState> {
  final IGeolocationRepository _geolocationRepository;

  AttachBloc(this._geolocationRepository) : super(const AttachState.initial()) {
    on<AttachEvent>((event, emit) async {
      await event.map<Future<void>>(
        pickGeolocation: (event) => _pickGeolocation(event, emit),
        restore: (event) => _restore(event, emit),
      );
    });
  }

  Future<void> _pickGeolocation(
      AttachPickGeolocation event, Emitter<AttachState> emit) async {
    final hasPermission = await _geolocationRepository.checkPermission();
    if (hasPermission) {
      final position = await _geolocationRepository.getDevicePosition();
      emit(AttachState.pickedGeolocation(position));
    }
  }

  Future<void> _restore(AttachRestore event, Emitter<AttachState> emit) async {
    emit(const AttachState.initial());
  }
}
