import 'package:flutter/material.dart';

/// Brand colors — managed only from this file (no magic Color literals in widgets).
abstract final class AppColors {
  static const Color background = Color(0xFFF7F7FA);
  static const Color backgroundDark = Color(0xFF121218);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C1C24);

  static const Color primary = Color(0xFF5B4DFF);
  static const Color primaryPressed = Color(0xFF4739E6);

  static const Color textPrimary = Color(0xFF111118);
  static const Color textPrimaryDark = Color(0xFFF2F2F7);
  static const Color textSecondary = Color(0xFF6B6B76);
  static const Color textSecondaryDark = Color(0xFFA0A0AB);

  static const Color border = Color(0xFFE4E4EA);
  static const Color borderDark = Color(0xFF2A2A34);

  static const Color success = Color(0xFF2F9E6B);
  static const Color error = Color(0xFFC4473A);
}
