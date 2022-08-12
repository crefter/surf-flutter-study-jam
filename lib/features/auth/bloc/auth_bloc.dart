import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:surf_practice_chat_flutter/features/auth/exceptions/auth_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/exceptions/secure_storage_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/token_repository.dart';

import '../repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;
  final ITokenRepository _tokenRepository;

  AuthBloc(this._authRepository, this._tokenRepository)
      : super(const AuthState.notAuth()) {
    on<AuthEvent>((event, emit) async {
      await event.map<Future<void>>(
        logIn: (event) => _logIn(event, emit),
      );
    }, transformer: bloc_concurrency.droppable());
  }

  Future<void> _logIn(AuthEventLogIn event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthState.inProgress());
      final login = event.login;
      final password = event.password;
      final token =
          await _authRepository.signIn(login: login, password: password);
      _tokenRepository.write("", token);
      emit(AuthState.success(token));
    } on AuthException catch (e) {
      emit(AuthState.error(e.message));
    } on SecureStorageException catch (e) {
      emit(AuthState.error(e.message));
    }
  }
}
