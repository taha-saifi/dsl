import 'package:dsl/features/player/data/play_models.dart';
import 'package:dsl/features/player/data/player_answer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_api.dart';

PlayPayload _payload() => PlayPayload.fromJson(
  (fixture('learn_play.json')! as Map<String, dynamic>)['data']!
      as Map<String, dynamic>,
);

void main() {
  test('the recorded payload parses into the 8 typed questions', () {
    final payload = _payload();
    expect(payload.exercise.name, 'Organs: mixed practice');
    expect(payload.questions.map((q) => q.runtimeType.toString()), [
      'ChoosePictureQuestion',
      'MultipleChoiceQuestion',
      'ListeningTranscribeQuestion',
      'ListeningSelectQuestion',
      'TypingQuestion',
      'FillBlankQuestion',
      'ArrangeSentenceQuestion',
      'MatchingQuestion',
    ]);
    final picture = payload.questions.first as ChoosePictureQuestion;
    expect(picture.options.every((o) => o.imageUrl != null), isTrue);
    final blank = payload.questions[5] as FillBlankQuestion;
    expect(blank.before, 'Le ');
  });

  test('a type from a newer API becomes UnknownQuestion', () {
    final q = PlayQuestion.fromJson({
      'id': 'q',
      'type': 'speaking',
      'displayText': 'Say it',
      'points': 10,
    });
    expect(q, isA<UnknownQuestion>());
  });

  test('answers are complete only when they can be checked', () {
    final questions = _payload().questions;
    final matching = questions.last as MatchingQuestion;

    expect(const TextAnswer('  ').isComplete(questions[4]), isFalse);
    expect(const TextAnswer(' lungs ').isComplete(questions[4]), isTrue);
    expect(const OrderAnswer([]).isComplete(questions[6]), isFalse);
    expect(const OrderAnswer(['a']).isComplete(questions[6]), isTrue);
    final onePair = {matching.left.first.id: matching.right.first.id};
    expect(PairsAnswer(onePair).isComplete(matching), isFalse);
    final allPairs = {
      for (var i = 0; i < matching.left.length; i++)
        matching.left[i].id: matching.right[i].id,
    };
    expect(PairsAnswer(allPairs).isComplete(matching), isTrue);
  });
}
