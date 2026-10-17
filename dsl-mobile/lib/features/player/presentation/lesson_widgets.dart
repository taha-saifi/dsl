import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/app_theme.dart';
import '../data/session_models.dart';

/// Question screens use the light Soft Gray surface with ink text
/// (docs/mobile/figma-question-screens.md), unlike the rest of the app.
class LessonTheme extends StatelessWidget {
  const LessonTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.input),
      borderSide: BorderSide(color: colors.lessonSelectedBorder, width: 2),
    );
    return Theme(
      data: base.copyWith(
        scaffoldBackgroundColor: colors.softGray,
        textSelectionTheme: TextSelectionThemeData(cursorColor: colors.cyan),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colors.white,
          hintStyle: context.type.bodyLarge.copyWith(color: colors.muted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          enabledBorder: border.copyWith(
            borderSide: BorderSide(color: colors.muted.withValues(alpha: 0.4)),
          ),
          focusedBorder: border,
          border: border,
        ),
      ),
      child: child,
    );
  }
}

/// White rounded card on the Soft Gray surface.
class LessonCard extends StatelessWidget {
  const LessonCard({required this.child, super.key, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: context.colors.white,
      borderRadius: BorderRadius.circular(AppRadii.card),
    ),
    child: child,
  );
}

/// A small caption above a lesson block ("Type in English:").
class LessonLabel extends StatelessWidget {
  const LessonLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      text,
      style: context.type.body.copyWith(color: context.colors.muted),
    ),
  );
}

/// A tappable white card that turns cyan-tinted when [selected]
/// (Figma `6:54`, selected option ≈ `#D7ECF0` with a `#3AC3DB` border).
class SelectableLessonCard extends StatelessWidget {
  const SelectableLessonCard({
    required this.selected,
    required this.onTap,
    required this.child,
    super.key,
    this.semanticsLabel,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderColor,
    this.fillColor,
  });

  final bool selected;
  final VoidCallback? onTap;
  final Widget child;
  final String? semanticsLabel;
  final EdgeInsetsGeometry padding;

  /// Overrides for states other than plain selection (e.g. matched pairs).
  final Color? borderColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticsLabel,
      child: Material(
        color: fillColor ?? (selected ? colors.lessonSelected : colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color:
                borderColor ??
                (selected ? colors.lessonSelectedBorder : Colors.transparent),
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Plays a question's audio once when it appears; tap to replay.
class AudioPromptCard extends StatefulWidget {
  const AudioPromptCard({required this.url, super.key});

  final String url;

  @override
  State<AudioPromptCard> createState() => _AudioPromptCardState();
}

class _AudioPromptCardState extends State<AudioPromptCard> {
  final _player = AudioPlayer();
  StreamSubscription<PlayerState>? _sub;
  bool _playing = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _sub = _player.playerStateStream.listen((state) {
      final playing =
          state.playing && state.processingState != ProcessingState.completed;
      if (mounted && playing != _playing) setState(() => _playing = playing);
    }, onError: (_) => _fail());
    unawaited(_play());
  }

  @override
  void didUpdateWidget(AudioPromptCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _failed = false;
      unawaited(_play());
    }
  }

  void _fail() {
    if (mounted) setState(() => _failed = true);
  }

  Future<void> _play() async {
    try {
      if (_player.audioSource == null || _failed) {
        await _player.setUrl(widget.url);
        if (mounted) setState(() => _failed = false);
      }
      await _player.seek(Duration.zero);
      await _player.play();
    } on Object {
      _fail();
    }
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Semantics(
      button: true,
      label: _failed ? 'Audio unavailable. Try again' : 'Replay audio',
      excludeSemantics: true,
      child: Material(
        color: colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color: colors.lessonSelectedBorder.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.card),
          onTap: _play,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.lessonSelected,
                    border: Border.all(
                      color: colors.lessonSelectedBorder,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _failed
                        ? Icons.refresh_rounded
                        : (_playing
                              ? Icons.graphic_eq_rounded
                              : Icons.volume_up_rounded),
                    color: colors.cyan,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(
                    _failed
                        ? "Couldn't play the audio. Tap to try again."
                        : (_playing ? 'Playing…' : 'Tap to replay audio'),
                    style: type.body.copyWith(
                      color: _failed ? colors.error : colors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The text answer field used by typing, listening_transcribe and fill_blank.
class AnswerField extends StatefulWidget {
  const AnswerField({
    required this.questionId,
    required this.hint,
    required this.initial,
    required this.onChanged,
    super.key,
    this.feedback,
  });

  /// After checking the field is read-only and outlined by the verdict.
  final AnswerResult? feedback;

  /// A new question gets a fresh field.
  final String questionId;
  final String hint;
  final String initial;
  final ValueChanged<String> onChanged;

  @override
  State<AnswerField> createState() => _AnswerFieldState();
}

class _AnswerFieldState extends State<AnswerField> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnswerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Try Again clears the answer.
    if (widget.initial.isEmpty &&
        _controller.text.isNotEmpty &&
        widget.feedback == null) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final verdictColor = switch (widget.feedback?.verdict) {
      null => null,
      Verdict.wrong => colors.error,
      Verdict.almost => colors.amber,
      Verdict.correct => colors.success,
    };
    final verdictBorder = verdictColor == null
        ? null
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.input),
            borderSide: BorderSide(color: verdictColor, width: 2),
          );
    return TextField(
      key: ValueKey('answer-${widget.questionId}'),
      controller: _controller,
      readOnly: widget.feedback != null,
      onChanged: widget.onChanged,
      autocorrect: false,
      enableSuggestions: false,
      textCapitalization: TextCapitalization.none,
      style: context.type.bodyLarge.copyWith(color: context.colors.ink),
      decoration: InputDecoration(
        hintText: widget.hint,
        enabledBorder: verdictBorder,
        focusedBorder: verdictBorder,
      ),
    );
  }
}

/// Network image with a quiet placeholder while loading or if it fails.
class LessonImage extends StatelessWidget {
  const LessonImage({required this.url, super.key, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget placeholder(IconData icon) => ColoredBox(
      color: colors.softGray,
      child: Center(child: Icon(icon, color: colors.muted)),
    );
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : placeholder(Icons.image_outlined),
      errorBuilder: (_, _, _) => placeholder(Icons.broken_image_outlined),
    );
  }
}

/// After checking: the right choice turns green, a wrong pick red
/// (Figma `87:218` / `87:262`). Before checking: null (normal selection).
({Color border, Color fill})? revealColors(
  BuildContext context, {
  required AnswerResult? feedback,
  required String choiceId,
  required bool picked,
}) {
  if (feedback == null) return null;
  final colors = context.colors;
  if (choiceId == feedback.correctOptionId) {
    return (
      border: colors.success,
      fill: colors.success.withValues(alpha: 0.12),
    );
  }
  if (picked) {
    return (border: colors.error, fill: colors.error.withValues(alpha: 0.10));
  }
  return null;
}
