import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:surf_practice_chat_flutter/core/colors.dart';
import 'package:surf_practice_chat_flutter/core/consts.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/adding/attach_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/consts.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_location_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_mode.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_local_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/geolocation_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/widgets/chat_add_something.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/widgets/floating_action_button_widget.dart';
import 'package:surf_practice_chat_flutter/features/chat/service/user_color_service.dart';

/// Main screen of chat app, containing messages.
class ChatScreen extends StatefulWidget {
  /// Repository for chat functionality.
  final UserColorService colorService;

  /// Constructor for [ChatScreen].
  const ChatScreen({
    Key? key,
    required this.colorService,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _nameEditingController = TextEditingController();
  final _chatEditingController = TextEditingController();
  final _geolocationRepository = GeolocationRepository();
  late final ScrollController _scrollController;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset <
          _scrollController.position.maxScrollExtent - 1000) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      } else {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AttachBloc(_geolocationRepository),
        ),
      ],
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: _isVisible
              ? FloatingActionButtonWidget(scrollController: _scrollController)
              : null,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: colorScheme.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(ChatConsts.heightAppBar),
          child: _ChatAppBar(
            controller: _nameEditingController,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _ChatBody(
                userColorService: widget.colorService,
                scrollController: _scrollController,
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
              context.read<AttachBloc>().add(const AttachEvent.restore());
              return state is ChatMessage
                  ? _ChatTextField(
                      textEditingController: _chatEditingController,
                    )
                  : ChatAddSomething();
            }),
          ],
        ),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  final ScrollController _scrollController;
  final UserColorService _userColorService;

  const _ChatBody({
    Key? key,
    required ScrollController scrollController,
    required UserColorService userColorService,
  })  : _scrollController = scrollController,
        _userColorService = userColorService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return state.currentMessages.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                controller: _scrollController,
                itemCount: state.currentMessages.length,
                itemBuilder: (_, index) => _ChatMessage(
                  userColorService: _userColorService,
                  chatData: state.currentMessages.elementAt(index),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class _ChatTextField extends StatelessWidget {
  final TextEditingController _textEditingController;

  const _ChatTextField({
    Key? key,
    required TextEditingController textEditingController,
  })  : _textEditingController = textEditingController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: ChatConsts.elevationTextFiled,
      child: Padding(
        padding: EdgeInsets.only(
          top: ChatConsts.topTextFieldPadding,
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
                child: BlocConsumer<ChatBloc, ChatState>(
                  listenWhen: (prev, curr) => prev != curr,
                  listener: (context, state) {
                    if (state.message.isNotEmpty) {
                      _textEditingController.text = state.message;
                    }
                  },
                  builder: (context, state) => Stack(
                    children: [
                      TextField(
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
                      state.geolocationDto != ChatGeolocationDto.empty()
                          ? const Positioned(
                              top: AppConsts.one,
                              right: AppConsts.zero,
                              child: Icon(
                                Icons.location_on,
                                color: AppColors.green,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
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
                color: AppColors.green,
              ),
              color: colorScheme.onSurface,
            ),
            IconButton(
              onPressed: () {
                context
                    .read<ChatBloc>()
                    .add(ChatEvent.sendMessage(_textEditingController.text));
                _textEditingController.text = "";
              },
              icon: const Icon(
                Icons.send,
                color: AppColors.green,
              ),
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
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => context
                    .read<ChatBloc>()
                    .add(ChatEvent.update(state.chatId)),
                icon: const Icon(Icons.refresh),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final ChatMessageDto chatData;
  final UserColorService userColorService;

  const _ChatMessage({
    required this.chatData,
    Key? key,
    required this.userColorService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChatBubble(
      margin: const EdgeInsets.only(top: 20),
      alignment: chatData.chatUserDto is ChatUserLocalDto
          ? Alignment.topRight
          : Alignment.topLeft,
      clipper: chatData.chatUserDto is ChatUserLocalDto
          ? ChatBubbleClipper1(type: BubbleType.sendBubble)
          : ChatBubbleClipper1(type: BubbleType.receiverBubble),
      backGroundColor: chatData.chatUserDto is ChatUserLocalDto
          ? colorScheme.primary
          : AppColors.teal,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Padding(
          padding: const EdgeInsets.only(
            top: ChatConsts.chatMessagePadding,
            left: ChatConsts.chatMessagePadding,
            right: ChatConsts.chatMessagePadding,
            bottom: AppConsts.zero,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ChatAvatar(
                userData: chatData.chatUserDto,
                colorService: userColorService,
              ),
              const SizedBox(width: ChatConsts.gapBetweenUserAvatarAndMessage),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      chatData.chatUserDto.name ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppConsts.defaultGapBetweenWidgets),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(chatData.message ?? ''),
        const SizedBox(
          height: AppConsts.defaultGapBetweenWidgets,
        ),
        const Text("К этому сообщение приклеплена геометка:"),
        Text("Долгота: ${chatData.location.longitude.toStringAsFixed(2)}\n "
            "Широта: ${chatData.location.latitude.toStringAsFixed(2)}"),
        const SizedBox(
          height: AppConsts.defaultGapBetweenWidgets * 3,
        ),
        Stack(
          children: [
            SizedBox(
              height: ChatConsts.heightOpenMapButton,
              child: TextButton(
                onPressed: () {
                  context.read<ChatBloc>().add(ChatEvent.openMap(chatData));
                },
                child: Text(
                  "Открыть на карте",
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: AppColors.red),
                ),
              ),
            ),
            const Positioned(
              left: ChatConsts.offsetOpenMapPicture,
              child: Icon(
                Icons.zoom_out_map,
                color: AppColors.red,
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
  final UserColorService colorService;

  const _ChatAvatar({
    required this.userData,
    Key? key,
    required this.colorService,
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
        if (split.last.isNotEmpty && split.first != split.last) {
          secondLetter = split.last[0];
        }
      }
    }
    return SizedBox(
      width: _size,
      height: _size,
      child: FutureBuilder(
          future: colorService.getColorBy(userData.name ?? ''),
          builder: (context, snapshot) {
            List<int> color = [0, 0, 0];
            if (snapshot.hasData) {
              final str = snapshot.data as String;
              color = [
                int.parse(str.substring(0, 2), radix: 16),
                int.parse(str.substring(2, 4), radix: 16),
                int.parse(str.substring(4, 6), radix: 16),
              ];
              return Material(
                color: Color.fromARGB(255, color[0], color[1], color[2]),
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
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
