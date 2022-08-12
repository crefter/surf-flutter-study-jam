import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:surf_practice_chat_flutter/features/auth/exceptions/auth_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/exceptions/secure_storage_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/token_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/services/token_service.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/user_repository.dart';
import 'package:surf_practice_chat_flutter/features/topics/services/user_serivce.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

import '../repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  final ITokenRepository _tokenRepository;
  final TokenService _tokenService;
  final IUserRepository _userRepository;

  AuthBloc(
    this.authRepository,
    this._tokenRepository,
    this._tokenService,
    this._userRepository,
  ) : super(const AuthState.notAuth()) {
    on<AuthEvent>((event, emit) async {
      await event.map<Future<void>>(
        logIn: (event) => _logIn(event, emit),
        logOut: (event) => _logOut(event, emit),
      );
    }, transformer: bloc_concurrency.droppable());
  }

  Future<void> _logIn(AuthEventLogIn event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthState.inProgress());
      final login = event.login;
      final password = event.password;
      final token =
          await authRepository.signIn(login: login, password: password);
      await _tokenRepository.write("", token);
      final client = await _tokenService.getClient();
      final userName = await UserService(_userRepository, client).getUserName();
      emit(AuthState.success(token, userName, client!));
    } on AuthException catch (e) {
      emit(AuthState.error(e.message));
    } on SecureStorageException catch (e) {
      emit(AuthState.error(e.message));
    }
  }

  Future<void> _logOut(AuthEventLogOut event, Emitter<AuthState> emit) async {
    await _tokenRepository.delete();
    emit(const AuthState.notAuth());
  }
}
