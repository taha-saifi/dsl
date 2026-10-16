import 'package:dsl/app.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/router/app_router.dart';
import 'package:dsl/core/router/routes.dart';
import 'package:dsl/core/widgets/dsl_button.dart';
import 'package:dsl/features/player/data/play_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/test_api.dart';

const _exercise = '6ad295274c24c8b9343a5c7f';

PlayPayload _payload() => PlayPayload.fromJson(
  (fixture('learn_play.json')! as Map<String, dynamic>)['data']!
      as Map<String, dynamic>,
);

Future<void> _openPlayer(WidgetTester tester, Responder play) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);
  final api = TestApi(
    routes({
      'GET /auth/me': respondWith('auth_me.json'),
      'GET /learn/me/courses': respondWith('learn_me_courses_empty.json'),
      'GET /learn/exercises/$_exercise/play': play,
    }),
    token: 'stored',
  );
  await tester.pumpWidget(
    ProviderScope(
      retry: noAutomaticRetry,
      overrides: api.overrides,
      child: const DslApp(),
    ),
  );
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(DslApp)),
  );
  unawaitedPush(container.read(appRouterProvider).push(Routes.play(_exercise)));
  await tester.pumpAndSettle();
}

void unawaitedPush(Future<Object?> _) {}

DslButton _cta(WidgetTester tester) =>
    tester.widget<DslButton>(find.byType(DslButton).last);

Future<void> _next(WidgetTester tester) async {
  expect(_cta(tester).onPressed, isNotNull, reason: 'answer should enable it');
  await tester.tap(find.byType(DslButton).last);
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('plays all 8 question types to the end', (tester) async {
    final payload = _payload();
    final q = payload.questions;
    await _openPlayer(tester, respondWith('learn_play.json'));

    // 1. choose_picture: nothing to submit until a picture is picked.
    expect(find.text('1/8'), findsOneWidget);
    expect(find.text('CHOOSE PICTURE'), findsOneWidget);
    expect(_cta(tester).onPressed, isNull);
    expect(find.text('Answer to continue'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Picture 2'));
    await tester.pumpAndSettle();
    await _next(tester);

    // 2. multiple_choice
    expect(find.text('MULTIPLE CHOICE'), findsOneWidget);
    expect(find.text((q[1] as MultipleChoiceQuestion).prompt), findsOneWidget);
    await _tapText(
      tester,
      (q[1] as MultipleChoiceQuestion).options.first.text!,
    );
    await _next(tester);

    // 3. listening_transcribe: audio card + field.
    expect(find.text('LISTEN AND TYPE'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('audio', caseSensitive: false)),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), 'coeur');
    await tester.pumpAndSettle();
    await _next(tester);

    // 4. listening_select
    expect(find.text('LISTEN AND SELECT'), findsOneWidget);
    await _tapText(
      tester,
      (q[3] as ListeningSelectQuestion).options.last.text!,
    );
    await _next(tester);

    // 5. typing: whitespace alone doesn't count.
    expect(find.text((q[4] as TypingQuestion).prompt), findsOneWidget);
    await tester.enterText(find.byType(TextField), '   ');
    await tester.pumpAndSettle();
    expect(_cta(tester).onPressed, isNull);
    await tester.enterText(find.byType(TextField), 'lungs');
    await tester.pumpAndSettle();
    await _next(tester);

    // 6. fill_blank: the typed word shows inside the sentence.
    expect(find.text('FILL IN THE BLANK'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'sang');
    await tester.pumpAndSettle();
    expect(find.text('sang'), findsWidgets);
    await _next(tester);

    // 7. arrange_sentence: tap a word to place it, tap again to remove.
    final bank = (q[6] as ArrangeSentenceQuestion).bank;
    expect(find.text('0 of ${bank.length} words placed'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Add ${bank.first.text}'));
    await tester.pumpAndSettle();
    expect(find.text('1 of ${bank.length} words placed'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Remove ${bank.first.text}'));
    await tester.pumpAndSettle();
    expect(_cta(tester).onPressed, isNull);
    await tester.tap(find.bySemanticsLabel('Add ${bank.first.text}'));
    await tester.pumpAndSettle();
    await _next(tester);

    // 8. matching: pair every left card, then Finish.
    final matching = q[7] as MatchingQuestion;
    expect(find.text('8/8'), findsOneWidget);
    for (var i = 0; i < matching.left.length; i++) {
      await _tapText(tester, matching.left[i].text!);
      await _tapText(tester, matching.right[i].text!);
    }
    expect(
      find.text('Paired: ${matching.left.length} of ${matching.left.length}'),
      findsOneWidget,
    );
    expect(find.text('Finish'), findsOneWidget);
    await _next(tester);

    expect(find.text('End of Organs: mixed practice'), findsOneWidget);
    expect(find.text('You answered all 8 questions.'), findsOneWidget);
  });

  testWidgets('close opens Pause; Keep going stays, Quit leaves', (
    tester,
  ) async {
    await _openPlayer(tester, respondWith('learn_play.json'));

    await tester.tap(find.byTooltip('Pause'));
    await tester.pumpAndSettle();
    expect(find.text('Paused'), findsOneWidget);
    await tester.tap(find.text('Keep going'));
    await tester.pumpAndSettle();
    expect(find.text('1/8'), findsOneWidget);

    await tester.tap(find.byTooltip('Pause'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quit'));
    await tester.pumpAndSettle();
    expect(find.text('1/8'), findsNothing);
    expect(find.text('Hello, Sara'), findsOneWidget);
  });

  testWidgets('not enrolled: the server message, and a way back', (
    tester,
  ) async {
    await _openPlayer(
      tester,
      respondWith('learn_play_not_enrolled.json', status: 403),
    );

    expect(find.text("Couldn't open this exercise"), findsOneWidget);
    expect(
      find.text('Enroll in this course to play its exercises.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Sara'), findsOneWidget);
  });

  testWidgets('an empty exercise says so', (tester) async {
    final body = fixture('learn_play.json')! as Map<String, dynamic>;
    (body['data']! as Map<String, dynamic>)['questions'] = <Object>[];
    await _openPlayer(tester, (_) => FakeAdapter.json(body));

    expect(find.text('Nothing to play yet'), findsOneWidget);
  });
}
