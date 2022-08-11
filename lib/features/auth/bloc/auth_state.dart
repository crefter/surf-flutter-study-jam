part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.notAuth() = AuthStateNotAuth;

  const factory AuthState.error(final String message) = AuthStateError;

  const factory AuthState.inProgress() = AuthStateInProgress;

  const factory AuthState.success(final TokenDto token) = AuthStateSuccess;
}
