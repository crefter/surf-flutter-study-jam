import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/core/colors.dart';
import 'package:surf_practice_chat_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/features/auth/exceptions/secure_storage_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/token_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';
import 'package:surf_practice_chat_flutter/features/auth/storages/local_secure_storage.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late final TokenDto? token;
  late final StudyJamClient? client;
  try {
    token = await TokenRepository(LocalSecureStorage()).read();
  } on SecureStorageException {
    token = null;
  }
  if (token != null) {
    client = StudyJamClient().getAuthorizedClient(token.token);
  } else {
    client = null;
  }

  runApp(MyApp(
    client: client,
  ));
}

/// App,s main widget.
class MyApp extends StatelessWidget {
  final StudyJamClient? client;

  /// Constructor for [MyApp].
  const MyApp({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        AuthRepository(client ?? StudyJamClient()),
        TokenRepository(LocalSecureStorage()),
      ),
      child: MaterialApp(
        theme: Theme.of(context).copyWith(
            primaryColor: AppColors.green,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
        home: client == null
            ? const AuthScreen()
            : ChatScreen(chatRepository: ChatRepository(client!)),
      ),
    );
  }
}
