import 'package:flutter/material.dart';

/// Brand tokens from Figma "DS · Color Tokens" (`52:5`), plus surface tones
/// sampled from the DS boards (docs/mobile/figma-question-screens.md).
/// Widgets read these via `context.colors`, never raw hex.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.ink,
    required this.inkSurface,
    required this.inkBorder,
    required this.inkTrack,
    required this.inkDisabled,
    required this.cyan,
    required this.amber,
    required this.violet,
    required this.softGray,
    required this.success,
    required this.error,
    required this.white,
    required this.muted,
    required this.lessonSelected,
    required this.lessonSelectedBorder,
  });

  /// The DSL palette. One instance: the app has no dark/light switch.
  static const dsl = AppColors(
    ink: Color(0xFF1E1B4B), // Midnight Ink: app background
    inkSurface: Color(0xFF262261), // cards and input fill on ink (sampled)
    inkBorder: Color(0xFF393370), // card/input outline on ink (sampled)
    inkTrack: Color(0xFF332E66), // progress-bar track on ink (sampled)
    inkDisabled: Color(0xFF332E59), // disabled button fill (sampled)
    cyan: Color(0xFF06B8D4), // Electric Cyan: CTA, progress, selection
    amber: Color(0xFFF5B02A), // Gold Amber: XP, rewards
    violet: Color(0xFF8B5CF6), // listening / MC badge (sampled)
    softGray: Color(0xFFF4F4F5), // lesson (question) screen background
    success: Color(0xFF22C55E),
    error: Color(0xFFEF4444),
    white: Color(0xFFFFFFFF),
    muted: Color(0xFF94A3B8),
    lessonSelected: Color(0xFFD7ECF0), // selected option on soft gray (sampled)
    lessonSelectedBorder: Color(0xFF3AC3DB),
  );

  final Color ink;
  final Color inkSurface;
  final Color inkBorder;
  final Color inkTrack;
  final Color inkDisabled;
  final Color cyan;
  final Color amber;
  final Color violet;
  final Color softGray;
  final Color success;
  final Color error;
  final Color white;
  final Color muted;
  final Color lessonSelected;
  final Color lessonSelectedBorder;

  @override
  AppColors copyWith({
    Color? ink,
    Color? inkSurface,
    Color? inkBorder,
    Color? inkTrack,
    Color? inkDisabled,
    Color? cyan,
    Color? amber,
    Color? violet,
    Color? softGray,
    Color? success,
    Color? error,
    Color? white,
    Color? muted,
    Color? lessonSelected,
    Color? lessonSelectedBorder,
  }) {
    return AppColors(
      ink: ink ?? this.ink,
      inkSurface: inkSurface ?? this.inkSurface,
      inkBorder: inkBorder ?? this.inkBorder,
      inkTrack: inkTrack ?? this.inkTrack,
      inkDisabled: inkDisabled ?? this.inkDisabled,
      cyan: cyan ?? this.cyan,
      amber: amber ?? this.amber,
      violet: violet ?? this.violet,
      softGray: softGray ?? this.softGray,
      success: success ?? this.success,
      error: error ?? this.error,
      white: white ?? this.white,
      muted: muted ?? this.muted,
      lessonSelected: lessonSelected ?? this.lessonSelected,
      lessonSelectedBorder: lessonSelectedBorder ?? this.lessonSelectedBorder,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      ink: mix(ink, other.ink),
      inkSurface: mix(inkSurface, other.inkSurface),
      inkBorder: mix(inkBorder, other.inkBorder),
      inkTrack: mix(inkTrack, other.inkTrack),
      inkDisabled: mix(inkDisabled, other.inkDisabled),
      cyan: mix(cyan, other.cyan),
      amber: mix(amber, other.amber),
      violet: mix(violet, other.violet),
      softGray: mix(softGray, other.softGray),
      success: mix(success, other.success),
      error: mix(error, other.error),
      white: mix(white, other.white),
      muted: mix(muted, other.muted),
      lessonSelected: mix(lessonSelected, other.lessonSelected),
      lessonSelectedBorder: mix(
        lessonSelectedBorder,
        other.lessonSelectedBorder,
      ),
    );
  }
}
