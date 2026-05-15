import 'package:flutter/material.dart';

class ColorManager {
  static const Color navy = Color(0xFF102033);
  static const Color ink = Color(0xFF1E293B);
  static const Color muted = Color(0xFF64748B);
  static const Color grey = Color(0xFF778087);
  static const Color borderColor = Color(0xFFE5EAF0);
  static const Color green = Color(0xFF16A085);
  static const Color blue = Color(0xFF2563EB);
  static const Color teal = Color(0xFF0F766E);
  static const Color gold = Color(0xFFC9A24D);
  static const Color ivory = Color(0xFFF8FAFC);
  static const Color background = Color(0xFFF3F6F8);
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [navy, Color(0xFF174E63), teal],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}
