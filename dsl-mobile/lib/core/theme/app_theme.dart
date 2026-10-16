import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Figma "DS · Spacing" (`52:67`): 4px base unit.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// "DS · Grid" (`52:113`): 16px side margins on a 393px screen.
  static const double screenMargin = 16;
}

abstract final class AppRadii {
  static const double button = 14; // DS · Buttons
  static const double input = 12; // DS · Inputs
  static const double card = 16;
  static const double pill = 999;
}

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppTypography get type => Theme.of(this).extension<AppTypography>()!;
}

/// The app is drawn on Midnight Ink like the DS boards. Lesson screens
/// switch to a Soft Gray surface locally (slice 6), not through this theme.
abstract final class AppTheme {
  static ThemeData dsl() {
    const colors = AppColors.dsl;
    final type = AppTypography.dsl;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: colors.cyan,
          brightness: Brightness.dark,
        ).copyWith(
          primary: colors.cyan,
          onPrimary: colors.white,
          secondary: colors.amber,
          onSecondary: colors.ink,
          error: colors.error,
          onError: colors.white,
          surface: colors.ink,
          onSurface: colors.white,
          onSurfaceVariant: colors.muted,
          surfaceContainer: colors.inkSurface,
          surfaceContainerHigh: colors.inkSurface,
          outline: colors.inkBorder,
          outlineVariant: colors.inkBorder,
        );

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: colors.ink,
      extensions: [colors, type],
      textTheme: TextTheme(
        displaySmall: type.display,
        headlineMedium: type.h1,
        headlineSmall: type.h2,
        titleLarge: type.h3,
        bodyLarge: type.bodyLarge,
        bodyMedium: type.body,
        bodySmall: type.caption,
        labelSmall: type.label,
        labelLarge: type.button,
      ).apply(bodyColor: colors.white, displayColor: colors.white),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.ink,
        foregroundColor: colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: type.h3.copyWith(color: colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 18,
        ),
        hintStyle: type.body.copyWith(fontSize: 15, color: colors.muted),
        errorStyle: type.caption.copyWith(color: colors.error),
        border: border(colors.inkBorder),
        enabledBorder: border(colors.inkBorder),
        focusedBorder: border(colors.cyan, 2),
        errorBorder: border(colors.error),
        focusedErrorBorder: border(colors.error, 2),
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: colors.cyan),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.cyan),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.inkSurface,
        contentTextStyle: type.body.copyWith(color: colors.white),
      ),
    );
  }
}
