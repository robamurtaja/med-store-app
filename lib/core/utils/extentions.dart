import 'package:flutter/material.dart';

extension UIThemeExtension on BuildContext {
  TextStyle get h1 => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get b1 => Theme.of(this).textTheme.bodySmall!;
  TextStyle get l1 => Theme.of(this).textTheme.labelSmall!;
}
