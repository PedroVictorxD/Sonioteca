import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/presentation/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('AppColors should have primary color defined', () {
      expect(AppColors.primary, isNotNull);
    });

    test('AppColors should have background color defined', () {
      expect(AppColors.background, isNotNull);
    });

    test('AppColors should have surface color defined', () {
      expect(AppColors.surface, isNotNull);
    });

    test('AppTheme should return dark theme', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
    });

    test('darkTheme should use Material 3', () {
      final theme = AppTheme.darkTheme;
      expect(theme.useMaterial3, isTrue);
    });

    test('darkTheme should have correct colorScheme', () {
      final theme = AppTheme.darkTheme;
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.secondary);
    });

    test('AppColors should have onPrimary color', () {
      expect(AppColors.onPrimary, isNotNull);
    });

    test('AppColors should have error color', () {
      expect(AppColors.error, isNotNull);
    });
  });
}