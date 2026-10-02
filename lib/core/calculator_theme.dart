import 'package:flutter/material.dart';

class CalculatorTheme {
  // Midnight Blue with Deep Indigo/Violets
  static const Color background = Color(0xFF0A0F1F);
  static const Color indigoGlow = Color(0xFF1E1B4B);
  static const Color violetGlow = Color(0xFF311042);

  // Glassmorphism
  static const Color glassSurface = Color(0xE60F172A);
  static const Color glassBorder = Color(0x4038BDF8); // Cyan soft stroke
  static const Color glassBorderHighlight = Color(0x80FFFFFF);

  // Neumorphic Key Colors & Shadows
  static const Color keyBase = Color(0xFF111827);
  static const Color keyScientific = Color(0xFF162032);
  static const Color scientificText = Color(0xFF38BDF8); // Bright Cyan
  static const Color scientificAltText = Color(0xFFFBBF24); // Gold for Shift

  static const Color keyNumber = Color(0xFF0F172A);
  static const Color numberText = Color(0xFFF8FAFC);

  static const Color keyOperator = Color(0xFF131D31);
  static const Color operatorText = Color(0xFFF472B6); // Soft Pink/Amber

  static const Color keyUtility = Color(0xFF2E101B);
  static const Color utilityText = Color(0xFFFB7185);

  static const List<Color> equalsGradient = [
    Color(0xFF38BDF8),
    Color(0xFF818CF8),
  ];

  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          surface: glassSurface,
        ),
        fontFamily: 'monospace',
      );
}
