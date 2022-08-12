import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/core/colors.dart';
import 'package:surf_practice_chat_flutter/core/consts.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/adding/attach_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/consts.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_location_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_mode.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_local_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/geolocation_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/widgets/chat_add_something.dart';

/// Main screen of chat app, containing messages.
class ChatScreen extends StatefulWidget {
  /// Repository for chat functionality.
  final IChatRepository chatRepository;

  /// Constructor for [ChatScreen].
  const ChatScreen({
    required this.chatRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _nameEditingController = TextEditingController();
  final _geolocationRepository = GeolocationRepository();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ChatBloc(widget.chatRepository, _geolocationRepository),
        ),
        BlocProvider(
          create: (context) => AttachBloc(_geolocationRepository),
        ),
      ],
      child: Scaffold(
          backgroundColor: colorScheme.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(ChatConsts.heightAppBar),
            child: _ChatAppBar(
              controller: _nameEditingController,
            ),
          ),
          body: Builder(builder: (ctx) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ChatBody(
                    messages: ctx.watch<ChatBloc>().state.currentMessages,
                  ),
                ),
                BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
                  context.read<AttachBloc>().add(const AttachEvent.restore());
                  return state is ChatMessage
                      ? _ChatTextField()
                      : ChatAddSomething();
                }),
              ],
            );
          })),
    );
  }
}

class _ChatBody extends StatelessWidget {
  final Iterable<ChatMessageDto> messages;

  const _ChatBody({
    required this.messages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (_, index) => _ChatMessage(
        chatData: messages.elementAt(index),
      ),
    );
  }
}

class _ChatTextField extends StatelessWidget {
  final _textEditingController = TextEditingController();

  _ChatTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: ChatConsts.elevationTextFiled,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.padding.bottom + ChatConsts.bottomTextFieldPadding,
          left: ChatConsts.leftTextFieldPadding,
        ),
        child: Row(
          children: [
            Expanded(
              child: BlocListener<AttachBloc, AttachState>(
                listenWhen: (prev, curr) => curr is! AttachInitial,
                listener: (context, state) {
                  if (state is AttachPickedGeolocation) {
                    context.read<ChatBloc>().add(
                          ChatEvent.attachGeolocation(state.geolocationDto),
                        );
                  }
                },
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(
                        AppConsts.textFormFieldBorderRadius,
                      ),
                    ),
                    hintText: 'Сообщение',
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<ChatBloc>().add(ChatEvent.pick(ChatMode.choose()));
              },
              icon: const Icon(
                Icons.attach_file,
              ),
              color: colorScheme.onSurface,
            ),
            IconButton(
              onPressed: () {
                context
                    .read<ChatBloc>()
                    .add(ChatEvent.sendMessage(_textEditingController.text));
              },
              icon: const Icon(Icons.send),
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final TextEditingController controller;

  const _ChatAppBar({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () =>
                context.read<ChatBloc>().add(const ChatEvent.update()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final ChatMessageDto chatData;

  const _ChatMessage({
    required this.chatData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: chatData.chatUserDto is ChatUserLocalDto
          ? colorScheme.primary.withOpacity(.1)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ChatConsts.chatMessagePadding,
          vertical: ChatConsts.chatMessagePadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChatAvatar(userData: chatData.chatUserDto),
            const SizedBox(width: ChatConsts.gapBetweenUserAvatarAndMessage),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    chatData.chatUserDto.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: ChatConsts.defaultGapBetweenWidgets),
                  chatData is ChatMessageGeolocationDto
                      ? _MessageAndGeolocation(
                          chatData: chatData as ChatMessageGeolocationDto)
                      : _OnlyMessage(chatData: chatData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageAndGeolocation extends StatelessWidget {
  final ChatMessageGeolocationDto chatData;

  const _MessageAndGeolocation({Key? key, required this.chatData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(chatData.message ?? ''),
        const SizedBox(
          height: ChatConsts.defaultGapBetweenWidgets,
        ),
        const Text("К этому сообщение приклеплена геометка:"),
        Text("Долгота: ${chatData.location.longitude.toStringAsFixed(2)}\n "
            "Широта: ${chatData.location.latitude.toStringAsFixed(2)}"),
        const SizedBox(
          height: ChatConsts.defaultGapBetweenWidgets,
        ),
        Stack(
          children: [
            SizedBox(
              height: ChatConsts.heightOpenMapButton,
              child: TextButton(
                onPressed: () {
                  context.read<ChatBloc>().add(ChatEvent.openMap(chatData));
                },
                child: const Text("Открыть на карте"),
              ),
            ),
            const Positioned(
              left: ChatConsts.offsetOpenMapPicture,
              child: Icon(
                Icons.zoom_out_map,
                color: AppColors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OnlyMessage extends StatelessWidget {
  const _OnlyMessage({
    Key? key,
    required this.chatData,
  }) : super(key: key);

  final ChatMessageDto chatData;

  @override
  Widget build(BuildContext context) {
    return Text(chatData.message ?? '');
  }
}

class _ChatAvatar extends StatelessWidget {
  static const double _size = 42;

  final ChatUserDto userData;

  const _ChatAvatar({
    required this.userData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String firstLetter = '';
    String secondLetter = '';
    if (userData.name != null) {
      if (userData.name!.isNotEmpty) {
        final split = userData.name?.split(' ');
        firstLetter = split!.first[0];
        if (split.last.isNotEmpty && split.first != split.last)
          secondLetter = split.last[0];
      }
    }
    return SizedBox(
      width: _size,
      height: _size,
      child: Material(
        color: colorScheme.primary,
        shape: const CircleBorder(),
        child: Center(
          child: Text(
            "$firstLetter$secondLetter",
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: ChatConsts.fontSizeInAvatar,
            ),
          ),
        ),
      ),
    );
  }
}
