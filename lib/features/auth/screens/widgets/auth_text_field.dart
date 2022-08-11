import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/auth/consts.dart';
import '../colors.dart' as colors;

class AuthTextField extends StatefulWidget {
  final bool _isPassword;
  final String _label;
  final IconData _icon;
  final TextEditingController _controller;

  const AuthTextField(
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
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
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
        color: colors.Colors.green, fontSize: AuthConsts.labelFontSize);
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
          focusColor: colors.Colors.green,
          prefixIconColor: colors.Colors.green,
          prefixIcon: Icon(
            widget._icon,
            color: _focusNode.hasFocus ? colors.Colors.green : Colors.grey,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.Colors.green,
              width: 3,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(AuthConsts.textFormFieldBorderRadius)),
          ),
        ),
      ),
    );
  }
}
