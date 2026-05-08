import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _mint = Color(0xFF42D7A5);
  static const _ink = Color(0xFF101416);
  static const _cream = Color(0xFFF8F4EC);
  static const _coral = Color(0xFFFF7D66);

  static ThemeData get light => _theme(
        brightness: Brightness.light,
        scaffold: const Color(0xFFFBFAF7),
        surface: Colors.white,
        text: _ink,
      );

  static ThemeData get dark => _theme(
        brightness: Brightness.dark,
        scaffold: const Color(0xFF0D1113),
        surface: const Color(0xFF171D20),
        text: _cream,
      );

  static ThemeData _theme({
    required Brightness brightness,
    required Color scaffold,
    required Color surface,
    required Color text,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _mint,
      brightness: brightness,
      primary: _mint,
      secondary: _coral,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: text,
        displayColor: text,
      ),
      cardTheme: CardTheme(
        color: surface.withOpacity(0.88),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
