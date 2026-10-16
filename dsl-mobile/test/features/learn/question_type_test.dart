import 'package:dsl/features/learn/data/learn_models.dart';
import 'package:dsl/features/learn/data/question_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('summarizes a mixed exercise as two labels and a count', () {
    expect(
      summarizeTypes([
        QuestionType.multipleChoice,
        QuestionType.matching,
        QuestionType.typing,
        QuestionType.fillBlank,
      ]),
      'Multiple choice · Matching pairs · +2',
    );
    expect(summarizeTypes([QuestionType.typing]), 'Typing');
    expect(summarizeTypes([]), '');
  });

  test('a type from a newer API parses as unknown, not a crash', () {
    final exercise = ExerciseSummary.fromJson({
      '_id': 'e',
      'name': 'New',
      'orderIndex': 0,
      'questionCount': 2,
      'questionTypes': ['typing', 'speaking'],
    });
    expect(exercise.questionTypes, [QuestionType.typing, QuestionType.unknown]);
  });
}
