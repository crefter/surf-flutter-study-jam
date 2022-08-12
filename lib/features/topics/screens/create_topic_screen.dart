import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/core/colors.dart';
import 'package:surf_practice_chat_flutter/core/consts.dart';
import 'package:surf_practice_chat_flutter/core/widgets/my_text_field.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/topics_bloc.dart';

/// Screen, that is used for creating new chat topics.
class CreateTopicScreen extends StatefulWidget {
  /// Constructor for [CreateTopicScreen].
  const CreateTopicScreen({Key? key}) : super(key: key);

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  late final TextEditingController _nameController;

  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<TopicsBloc>().state.maybeWhen(
            orElse: () => '',
            inProgress: (_, userName) => userName,
            loaded: (_, userName) => userName)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextField(
            controller: _nameController,
            icon: Icons.chat,
            label: 'Название',
          ),
          MyTextField(
            controller: _descriptionController,
            icon: Icons.description,
            label: 'Описание',
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TopicsBloc>().add(TopicsEvent.createNewChat(
                  _nameController.text, _descriptionController.text));

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  padding: EdgeInsets.zero,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: AppColors.tangoPink,
                        width: screenWidth / AppConsts.widthSnackBarFactor,
                        height: screenHeight / AppConsts.heightSnackBarFactor,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: AppConsts.padding8_0,
                          right: AppConsts.padding8_0,
                        ),
                        child: Icon(
                          Icons.check,
                          color: AppColors.tangoPink,
                        ),
                      ),
                      const Text('Новый топик добавлен!')
                    ],
                  ),
                ),
              );
            },
            child: const Text('Создать топик'),
          ),
        ],
      ),
    );
  }
}
