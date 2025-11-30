import 'package:flutter/material.dart';
import 'dart:ui';

class AppStyles {
  // Spacing constants
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;

  // Border radius constants
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 24;

  // Get header decoration with gradient
  static BoxDecoration getHeaderDecoration({required bool isDark}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF6C63FF), // secondary
          const Color(0xFFFF6B6B), // primary
          const Color(0xFF1A1A2E), // dark
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radiusL),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Get card decoration
  static BoxDecoration getCardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? Colors.grey[800] : Colors.white,
      borderRadius: BorderRadius.circular(radiusM),
      border: Border.all(
        color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Get divider color
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.withValues(alpha: 0.2)
        : Colors.grey.withValues(alpha: 0.15);
  }

  // Get primary button style
  static ButtonStyle getPrimaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6C63FF),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      elevation: 2,
    );
  }

  // Get secondary button style
  static ButtonStyle getSecondaryButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFFF6B6B),
      side: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
    );
  }

  // Glass card container
  static Widget glassCard({required Widget child, double radius = radiusM}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xB31A1A2E),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}
