import 'play_models.dart';

/// What the student has entered for one question, before checking.
sealed class PlayerAnswer {
  const PlayerAnswer();

  /// Whether "Check" can be pressed for [question].
  bool isComplete(PlayQuestion question);

  /// The `answer` body for `POST /learn/sessions/:id/answers`.
  Map<String, Object> toJson();
}

/// choose_picture, multiple_choice, listening_select.
final class ChoiceAnswer extends PlayerAnswer {
  const ChoiceAnswer(this.optionId);

  final String optionId;

  @override
  bool isComplete(PlayQuestion question) => true;

  @override
  Map<String, Object> toJson() => {'optionId': optionId};
}

/// typing, listening_transcribe, fill_blank.
final class TextAnswer extends PlayerAnswer {
  const TextAnswer(this.text);

  final String text;

  @override
  bool isComplete(PlayQuestion question) => text.trim().isNotEmpty;

  @override
  Map<String, Object> toJson() => {'text': text};
}

/// arrange_sentence: block ids in the order placed. The bank has distractor
/// blocks, so the sentence is complete when at least one word is placed.
final class OrderAnswer extends PlayerAnswer {
  const OrderAnswer(this.blockIds);

  final List<String> blockIds;

  @override
  bool isComplete(PlayQuestion question) => blockIds.isNotEmpty;

  @override
  Map<String, Object> toJson() => {'blockIds': blockIds};
}

/// matching: left id → right id. Complete when every left card is paired.
final class PairsAnswer extends PlayerAnswer {
  const PairsAnswer(this.pairs);

  final Map<String, String> pairs;

  @override
  bool isComplete(PlayQuestion question) =>
      question is MatchingQuestion && pairs.length == question.left.length;

  @override
  Map<String, Object> toJson() => {
    'pairs': [
      for (final e in pairs.entries) {'leftId': e.key, 'rightId': e.value},
    ],
  };
}
