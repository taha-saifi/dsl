import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// The 8 question types (docs/data-model/question-types.md). Labels match
/// the dashboard's `src/lib/questionTypes.ts`.
enum QuestionType {
  @JsonValue('choose_picture')
  choosePicture('Choose picture', Icons.image_outlined),
  @JsonValue('multiple_choice')
  multipleChoice('Multiple choice', Icons.checklist_rounded),
  @JsonValue('listening_select')
  listeningSelect('Listen and select', Icons.hearing_rounded),
  @JsonValue('typing')
  typing('Typing', Icons.keyboard_alt_outlined),
  @JsonValue('listening_transcribe')
  listeningTranscribe('Listen and type', Icons.headphones_rounded),
  @JsonValue('fill_blank')
  fillBlank('Fill in the blank', Icons.short_text_rounded),
  @JsonValue('arrange_sentence')
  arrangeSentence('Arrange sentence', Icons.reorder_rounded),
  @JsonValue('matching')
  matching('Matching pairs', Icons.compare_arrows_rounded),

  /// A type added to the API after this build.
  unknown('Other', Icons.help_outline_rounded);

  const QuestionType(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// "Multiple choice · Matching · +2": the first [shown] types, then a count.
String summarizeTypes(List<QuestionType> types, {int shown = 2}) {
  if (types.isEmpty) return '';
  final head = types.take(shown).map((t) => t.label);
  final rest = types.length - shown;
  return [...head, if (rest > 0) '+$rest'].join(' · ');
}
