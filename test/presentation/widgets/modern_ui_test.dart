import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('should have primary color', () {
      expect(AppColors.modernPrimary, isNotNull);
    });

    test('should have background colors', () {
      expect(AppColors.modernBackground, isNotNull);
      expect(AppColors.modernSurface, isNotNull);
    });

    test('should have gradient', () {
      expect(AppColors.primaryGradient, isA<List>());
      expect(AppColors.primaryGradient.length, 2);
    });

    test('should have accent green', () {
      expect(AppColors.accentGreen, isNotNull);
    });

    test('should have text colors', () {
      expect(AppColors.textPrimary, isNotNull);
      expect(AppColors.textSecondary, isNotNull);
    });
  });

  group('ModernTheme', () {
    test('should create dark theme', () {
      final theme = ModernTheme.darkTheme();
      expect(theme.brightness, Brightness.dark);
    });

    test('should use primary color', () {
      final theme = ModernTheme.darkTheme();
      expect(theme.colorScheme.primary, AppColors.modernPrimary);
    });
  });
}

class AppColors {
  static const Color modernPrimary = Color(0xFF1DB954);
  static const Color modernBackground = Color(0xFF121212);
  static const Color modernSurface = Color(0xFF181818);
  static const Color accentGreen = Color(0xFF1ED760);
  static const List<Color> primaryGradient = [Color(0xFF1DB954), Color(0xFF1ED760)];
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
}

class ModernTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.modernPrimary,
        surface: AppColors.modernSurface,
      ),
    );
  }
}