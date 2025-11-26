import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF6B86D4);
  static const Color background = Color(0xFFF6F8FC);
  static const Color accent = Color(0xFFE9EEFF);
  static const Color text = Color(0xFF1C1C1C);
  static const Color softText = Color(0xFF6B7280);
  static const Color card = Colors.white;
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radius12 = BorderRadius.all(Radius.circular(12));

  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: text),
        bodySmall: TextStyle(fontSize: 12, color: softText),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: text,
        centerTitle: false,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
      ).copyWith(background: background),
    );
  }
}
