import 'package:flutter/material.dart';

class AppTheme {
  static const Color _surfaceDark = Color(0xFF0F0F12);
  static const Color _surfaceLight = Color(0xFFF5F5F7);
  static const Color _blockBase = Color(0xFF6366F1);
  static const Color _blockHighlight = Color(0xFF818CF8);
  static const Color _gridLine = Color(0xFF27272A);
  static const Color _gridLineLight = Color(0xFFE4E4E7);

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _surfaceDark,
    colorScheme: ColorScheme.dark(
      surface: _surfaceDark,
      primary: _blockBase,
      secondary: _blockHighlight,
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _surfaceDark,
      elevation: 0,
      centerTitle: true,
    ),
  );

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _surfaceLight,
    colorScheme: ColorScheme.light(
      surface: _surfaceLight,
      primary: _blockBase,
      secondary: _blockHighlight,
      onSurface: Colors.black87,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _surfaceLight,
      elevation: 0,
      centerTitle: true,
    ),
  );

  static Color gridLineColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _gridLine : _gridLineLight;

  static Color blockColorForId(int id, BuildContext context) {
    if (id == 0) return Colors.transparent;
    const colors = [
      Color(0xFF6366F1), // indigo
      Color(0xFFEC4899), // pink
      Color(0xFF10B981), // emerald
      Color(0xFFF59E0B), // amber
      Color(0xFF8B5CF6), // violet
      Color(0xFF06B6D4), // cyan
      Color(0xFFEF4444), // red
      Color(0xFF84CC16), // lime
    ];
    return colors[(id - 1) % colors.length];
  }
}
