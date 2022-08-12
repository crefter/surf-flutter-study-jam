import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final ScrollController _scrollController;

  const FloatingActionButtonWidget(
      {Key? key, required ScrollController scrollController})
      : _scrollController = scrollController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );
      },
      child: const Icon(Icons.arrow_downward),
    );
  }
}
