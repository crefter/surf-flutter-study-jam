part of 'attach_bloc.dart';

@freezed
class AttachEvent with _$AttachEvent {
  const factory AttachEvent.pickGeolocation() = AttachPickGeolocation;
  const factory AttachEvent.restore() = AttachRestore;
}
