import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/core/colors.dart';
import 'package:surf_practice_chat_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/token_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';
import 'package:surf_practice_chat_flutter/features/auth/services/token_service.dart';
import 'package:surf_practice_chat_flutter/features/auth/storages/local_secure_storage.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/topics_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/user_repository.dart';
import 'package:surf_practice_chat_flutter/features/topics/screens/topics_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/services/user_serivce.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = TokenService(TokenRepository(LocalSecureStorage()));
  final client = await service.getClient();
  var userRepository = UserRepository();
  final userService = UserService(userRepository, client);
  final userName = await userService.getUserName();
  runApp(MyApp(
    client: client,
    userName: userName,
    tokenService: service,
    userRepository: userRepository,
  ));
}

/// App,s main widget.
class MyApp extends StatelessWidget {
  final StudyJamClient? client;
  final String userName;
  final TokenService tokenService;
  final UserRepository userRepository;

  /// Constructor for [MyApp].
  const MyApp(
      {Key? key,
      required this.client,
      required this.userName,
      required this.tokenService,
      required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TopicsBloc? topicsBloc;
    if (client != null) {
      topicsBloc = TopicsBloc(ChatTopicsRepository(client!));
    } else {
      topicsBloc = TopicsBloc(ChatTopicsRepository(StudyJamClient()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            AuthRepository(client ?? StudyJamClient()),
            TokenRepository(LocalSecureStorage()),
            tokenService,
            userRepository,
          ),
        ),
        BlocProvider.value(
          value: topicsBloc,
        ),
      ],
      child: MaterialApp(
        theme: Theme.of(context).copyWith(
            primaryColor: AppColors.green,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
        home: Builder(
          builder: (context) {
            if (client == null) {
              return const AuthScreen();
            } else {
              context.read<TopicsBloc>().add(TopicsEvent.open(userName));
              return TopicsScreen(
                client: client!,
              );
            }
          },
        ),
      ),
    );
  }
}
