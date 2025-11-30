import 'package:flutter/material.dart';

class AppDesign {
  // Couleurs principales
  static const Color primaryGradient1 = Color(0xFF6C63FF);
  static const Color primaryGradient2 = Color(0xFF9D84FF);
  static const Color accentGreen = Color(0xFF25D366);
  static const Color accentRed = Color(0xFFFF6B6B);
  static const Color accentOrange = Color(0xFFFFA500);
  static const Color accentBlue = Color(0xFF4A90E2);
  
  // Backgrounds
  static const Color bgLight = Color(0xFFF8F9FC);
  static const Color bgDark = Color(0xFF0F1419);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1A1F2E);
  
  // Espacement
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Ombres
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  // Gradients
  static LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradient1, primaryGradient2],
  );
  
  static LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGreen, const Color(0xFF1EBD63)],
  );
}
