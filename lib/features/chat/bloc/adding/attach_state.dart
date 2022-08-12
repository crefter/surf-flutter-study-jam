part of 'attach_bloc.dart';

@freezed
class AttachState with _$AttachState {
  const factory AttachState.initial() = AttachInitial;

  const factory AttachState.pickedGeolocation(
      final ChatGeolocationDto geolocationDto) = AttachPickedGeolocation;
}
