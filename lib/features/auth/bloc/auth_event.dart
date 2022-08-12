part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.logIn(final String login, final String password) =
      AuthEventLogIn;

  const factory AuthEvent.logOut() = AuthEventLogOut;
}
