import 'package:flutter/material.dart';
import 'color_manager.dart';

class ThemeManager {
  static final lightTheme = _buildTheme(
    brightness: Brightness.light,
    scaffoldBackground: ColorManager.background,
    surface: Colors.white,
    ink: ColorManager.ink,
    muted: ColorManager.muted,
    inputFill: ColorManager.ivory,
  );

  static final darkTheme = _buildTheme(
    brightness: Brightness.dark,
    scaffoldBackground: const Color(0xFF0B1220),
    surface: const Color(0xFF111827),
    ink: const Color(0xFFE5E7EB),
    muted: const Color(0xFF9CA3AF),
    inputFill: const Color(0xFF172033),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffoldBackground,
    required Color surface,
    required Color ink,
    required Color muted,
    required Color inputFill,
  }) {
    final isDark = brightness == Brightness.dark;
    final border = isDark ? const Color(0xFF263244) : ColorManager.borderColor;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'AvenirArabic',
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: ColorManager.teal,
        primary: ColorManager.teal,
        secondary: ColorManager.gold,
        surface: surface,
      ),
      scaffoldBackgroundColor: scaffoldBackground,
      cardColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: ink,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: ColorManager.teal,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: ink,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
        bodySmall: TextStyle(
          color: muted,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: ink,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        labelStyle: TextStyle(
          color: muted,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: const TextStyle(
          color: ColorManager.teal,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: TextStyle(
          color: muted,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(height: 0.5),
        filled: true,
        fillColor: inputFill,
        prefixIconColor: ColorManager.teal,
        suffixIconColor: muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: ColorManager.teal, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: ColorManager.teal),
        ),
      ),
    );
  }
}