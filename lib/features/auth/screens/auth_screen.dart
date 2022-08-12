import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/core/consts.dart';
import 'package:surf_practice_chat_flutter/features/auth/consts.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/widgets/auth_text_field.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/user_color_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/chat/service/user_color_service.dart';
import 'package:surf_study_jam/surf_study_jam.dart';
import '../bloc/auth_bloc.dart';
import 'colors.dart' as colors;

/// Screen for authorization process.
class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late double _screenHeight;
  late double _screenWidth;
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Size size = MediaQuery.of(context).size;
    _screenHeight = size.height;
    _screenWidth = size.width;
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: colors.Colors.white,
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (prev, curr) =>
              curr is AuthStateError || curr is AuthStateSuccess,
          listener: (context, state) {
            state.when(
                notAuth: () => null,
                error: (message) {
                  final theme = Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: colors.Colors.white);
                  return ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      padding: EdgeInsets.zero,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: colors.Colors.tangoPink,
                            width:
                                _screenWidth / AuthConsts.widthSnackBarFactor,
                            height:
                                _screenHeight / AuthConsts.heightSnackBarFactor,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: AppConsts.padding8_0,
                              right: AppConsts.padding8_0,
                            ),
                            child: Icon(
                              Icons.error,
                              color: colors.Colors.tangoPink,
                            ),
                          ),
                          Text(
                            state.when<String>(
                                notAuth: () => "",
                                error: (message) => message,
                                inProgress: () => "",
                                success: (_) => ""),
                            style: theme,
                          )
                        ],
                      ),
                    ),
                  );
                },
                inProgress: () => null,
                success: (token) {
                  _pushToChat(context, token);
                });
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTextField(
                  label: "Логин",
                  icon: Icons.account_circle_outlined,
                  controller: _loginController,
                ),
                AuthTextField(
                  label: "Пароль",
                  icon: Icons.lock,
                  isPassword: true,
                  controller: _passwordController,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AuthConsts.defaultPadding,
                    right: AuthConsts.defaultPadding,
                  ),
                  child: _ButtonNext(
                      screenWidth: _screenWidth,
                      loginController: _loginController,
                      passwordController: _passwordController),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _pushToChat(BuildContext context, TokenDto token) {
    Navigator.push<ChatScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChatScreen(
            colorService: UserColorService(UserColorRepository()),
            chatRepository: ChatRepository(
              StudyJamClient().getAuthorizedClient(token.token),
            ),
          );
        },
      ),
    );
  }
}

class _ButtonNext extends StatelessWidget {
  const _ButtonNext({
    Key? key,
    required double screenWidth,
    required TextEditingController loginController,
    required TextEditingController passwordController,
  })  : _screenWidth = screenWidth,
        _loginController = loginController,
        _passwordController = passwordController,
        super(key: key);

  final double _screenWidth;
  final TextEditingController _loginController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _screenWidth,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(colors.Colors.green),
          ),
          onPressed: () {
            context.read<AuthBloc>().add(
                  AuthEvent.logIn(
                    _loginController.text,
                    _passwordController.text,
                  ),
                );
          },
          child: const Text("ДАЛЕЕ")),
    );
  }
}
