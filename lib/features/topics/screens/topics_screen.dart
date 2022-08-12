import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/core/consts.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/geolocation_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/user_color_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/chat/service/user_color_service.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/topics_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/screens/create_topic_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/screens/widgets/list_topics_widget.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Screen with different chat topics to go to.
class TopicsScreen extends StatefulWidget {
  /// Constructor for [TopicsScreen].
  final StudyJamClient _client;

  const TopicsScreen({
    Key? key,
    required StudyJamClient client,
  })  : _client = client,
        super(key: key);

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _pushToCreateTopic(context);
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.watch<TopicsBloc>().state.maybeWhen(
            orElse: () => '',
            inProgress: (_, userName) => userName,
            loaded: (_, userName) => userName)),
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            _pushToAuthScreen(context);
          },
        ),
      ),
      body: BlocConsumer<TopicsBloc, TopicsState>(
        listenWhen: (prev, curr) => curr is TopicsError,
        listener: (context, state) {
          if (state is TopicsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: SizedBox(
                  height: height / AppConsts.heightSnackBarFactor,
                  child: Center(
                    child: Text(
                      state.when(
                        initial: () => '',
                        inProgress: (_, __) => '',
                        loaded: (_, __) => '',
                        error: (_, message) => message,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            inProgress: (topics, userName) =>
                const Center(child: CircularProgressIndicator()),
            loaded: (topics, _) => ListTopicsWidget(
              scrollController: _scrollController,
              callback: (chatId) {
                _pushToChatScreen(context, chatId);
              },
            ),
            error: (_, __) => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  _pushToCreateTopic(BuildContext context) {
    Navigator.push<CreateTopicScreen>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const CreateTopicScreen();
        },
      ),
    );
  }

  _pushToAuthScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<AuthScreen>(builder: (context) {
        return const AuthScreen();
      }),
    );
  }

  _pushToChatScreen(BuildContext context, int chatId) {
    Navigator.push(
      context,
      MaterialPageRoute<AuthScreen>(builder: (context) {
        return BlocProvider(
          create: (_) => ChatBloc(
            ChatRepository(widget._client),
            GeolocationRepository(),
          ),
          child: Builder(builder: (context) {
            context.read<ChatBloc>().add(ChatEvent.update(chatId));
            return ChatScreen(
              colorService: UserColorService(UserColorRepository()),
            );
          }),
        );
      }),
    );
  }
}
