import 'package:flutter/material.dart';
import '../utils/color_manager.dart';

class SecondaryButtonWidget extends StatelessWidget {
  const SecondaryButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
  });
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: ColorManager.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ColorManager.borderColor),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: ColorManager.teal,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
