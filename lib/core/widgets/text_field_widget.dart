import 'package:flutter/material.dart';
import '../utils/color_manager.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.controller,
    this.keyboardType,
    this.keyField,
    this.isPassword = false,
  });
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final Key? keyField;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.keyField,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? isVisible : false,
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      decoration: InputDecoration(
        labelText: widget.hintText,
        alignLabelWithHint: false,
        prefixIcon: Icon(widget.prefixIcon, size: 22),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 54,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                color: ColorManager.muted,
                icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}
