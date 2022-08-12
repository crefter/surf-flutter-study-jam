import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/core/consts.dart';
import 'package:surf_practice_chat_flutter/features/auth/consts.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/colors.dart';

class MyTextField extends StatefulWidget {
  final bool _isPassword;
  final String _label;
  final IconData _icon;
  final TextEditingController _controller;

  const MyTextField(
      {Key? key,
        required String label,
        required IconData icon,
        required TextEditingController controller,
        bool? isPassword})
      : _label = label,
        _icon = icon,
        _controller = controller,
        _isPassword = isPassword ?? false,
        super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AuthColors.green, fontSize: AuthConsts.labelFontSize);
    return Padding(
      padding: const EdgeInsets.all(
        AuthConsts.defaultPadding,
      ),
      child: TextFormField(
        controller: widget._controller,
        enableSuggestions: false,
        focusNode: _focusNode,
        obscureText: widget._isPassword,
        decoration: InputDecoration(
          floatingLabelStyle: labelStyle,
          labelText: widget._label,
          focusColor: AuthColors.green,
          prefixIconColor: AuthColors.green,
          prefixIcon: Icon(
            widget._icon,
            color: _focusNode.hasFocus ? AuthColors.green : Colors.grey,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AuthColors.green,
              width: 3,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(AppConsts.textFormFieldBorderRadius)),
          ),
        ),
      ),
    );
  }
}
