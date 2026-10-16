import 'package:flutter/material.dart';

/// Figma "DS · Typography" (`52:39`): Inter, size/line-height pairs as drawn.
/// Colors are left unset so each style inherits from where it's used.
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.display,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.bodyLarge,
    required this.body,
    required this.caption,
    required this.label,
    required this.button,
  });

  static const fontFamily = 'Inter';

  static TextStyle _style(double size, double lineHeight, FontWeight weight) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        letterSpacing: 0,
      );

  static final dsl = AppTypography(
    display: _style(34, 42, FontWeight.w800),
    h1: _style(28, 36, FontWeight.w700),
    h2: _style(22, 30, FontWeight.w600),
    h3: _style(18, 26, FontWeight.w600),
    bodyLarge: _style(16, 24, FontWeight.w400),
    body: _style(14, 20, FontWeight.w400),
    caption: _style(12, 16, FontWeight.w400),
    // Form-field labels and type badges are uppercase in the designs; callers
    // uppercase the text, the style only sets the metrics.
    label: _style(11, 16, FontWeight.w600).copyWith(letterSpacing: 0.4),
    button: _style(16, 20, FontWeight.w600),
  );

  final TextStyle display;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle bodyLarge;
  final TextStyle body;
  final TextStyle caption;
  final TextStyle label;
  final TextStyle button;

  @override
  AppTypography copyWith({
    TextStyle? display,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? bodyLarge,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? label,
    TextStyle? button,
  }) {
    return AppTypography(
      display: display ?? this.display,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      label: label ?? this.label,
      button: button ?? this.button,
    );
  }

  @override
  AppTypography lerp(AppTypography? other, double t) {
    if (other == null) return this;
    TextStyle mix(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return AppTypography(
      display: mix(display, other.display),
      h1: mix(h1, other.h1),
      h2: mix(h2, other.h2),
      h3: mix(h3, other.h3),
      bodyLarge: mix(bodyLarge, other.bodyLarge),
      body: mix(body, other.body),
      caption: mix(caption, other.caption),
      label: mix(label, other.label),
      button: mix(button, other.button),
    );
  }
}
