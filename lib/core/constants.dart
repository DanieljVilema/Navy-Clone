import 'package:flutter/material.dart';

class AppColors {
  static const Color navyPrimary = Color(0xFF001F5B);
  static const Color navyDark = Color(0xFF00133D);
  static const Color goldAccent = Color(0xFFC5A44E);
  static const Color lightGold = Color(0xFFE8D5A0);
  static const Color surfaceWhite = Color(0xFFF5F6FA);
  static const Color navyAppBar = Color(0xFF1B2A4A);

  // Performance level colors
  static const Color outstanding = Color(0xFF4CAF50);
  static const Color excellent = Color(0xFF2196F3);
  static const Color good = Color(0xFF03A9F4);
  static const Color satisfactory = Color(0xFFFFC107);
  static const Color failure = Color(0xFFF44336);

  static Color colorForLevel(String level) {
    switch (level.toUpperCase()) {
      case 'SOBRESALIENTE':
        return outstanding;
      case 'EXCELENTE':
        return excellent;
      case 'BUENO':
        return good;
      case 'SATISFACTORIO':
        return satisfactory;
      default:
        return failure;
    }
  }

  static IconData iconForLevel(String level) {
    switch (level.toUpperCase()) {
      case 'SOBRESALIENTE':
        return Icons.emoji_events_rounded;
      case 'EXCELENTE':
        return Icons.star_rounded;
      case 'BUENO':
        return Icons.thumb_up_rounded;
      case 'SATISFACTORIO':
        return Icons.warning_rounded;
      default:
        return Icons.dangerous_rounded;
    }
  }
}

class AppStrings {
  static const String appTitle = 'Evaluación Física Armada Ecuador';
  static const String appVersion = '3.0.29';
  static const String drawerTitle = 'Evaluación Física Armada';

  // Performance levels
  static const String levelSobresaliente = 'SOBRESALIENTE';
  static const String levelExcelente = 'EXCELENTE';
  static const String levelBueno = 'BUENO';
  static const String levelSatisfactorio = 'SATISFACTORIO';
  static const String levelNoAprobado = 'NO APROBADO';

  static String levelForScore(double score) {
    if (score >= 90) return levelSobresaliente;
    if (score >= 75) return levelExcelente;
    if (score >= 60) return levelBueno;
    if (score >= 45) return levelSatisfactorio;
    return levelNoAprobado;
  }
}
