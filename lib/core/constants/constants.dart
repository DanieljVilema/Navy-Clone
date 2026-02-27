import 'package:flutter/material.dart';

// ── ArmadaFit Design System ──────────────────────────────────────────────────

/// Color Palette
class AppColors {
  // Primary
  static const Color primary = Color(0xFF0750F7);
  static const Color primaryDark = Color(0xFF0640D1);
  static const Color primaryLight = Color(0xFF2968F8);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBBF24);

  // Dark Mode (default)
  static const Color darkBg = Color(0xFF1C1C1E);
  static const Color darkCard = Color(0xFF2C2C2E);
  static const Color darkCardSec = Color(0xFF3A3A3C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextTertiary = Color(0xFF6B7280);
  static const Color darkBorder = Color(0xFF3A3A3C);
  static const Color darkInput = Color(0xFF2C2C2E);

  // Light Mode
  static const Color lightBg = Color(0xFFF5F5F7);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardSec = Color(0xFFF0F0F2);
  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightInput = Color(0xFFFFFFFF);

  // Legacy aliases (keep backward compat)
  static const Color navyPrimary = primary;
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF5E6B8);
}

/// Spacing (4px system)
class Spacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Border Radius
class Radii {
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double full = 9999;
}

/// Shadows
class AppShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: const Offset(0, 1),
          blurRadius: 3,
        ),
      ];
  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          offset: const Offset(0, 2),
          blurRadius: 8,
        ),
      ];
}

/// Level classification
class AppStrings {
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
