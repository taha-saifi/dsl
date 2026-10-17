import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dsl/app.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/router/app_router.dart';
import 'package:dsl/core/router/routes.dart';
import 'package:dsl/core/widgets/dsl_bottom_nav.dart';
import 'package:dsl/core/widgets/dsl_button.dart';
import 'package:dsl/features/player/data/play_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/test_api.dart';

const _exercise = '6ad295274c24c8b9343a5c7f';
const _unit = '6ad28f21dcbfbc7ecf3f1a96';

Map<String, dynamic> _start() =>
    (fixture('learn_session_start.json')! as Map<String, dynamic>)['data']!
        as Map<String, dynamic>;
String get _sessionId =>
    (_start()['session']! as Map<String, dynamic>)['_id']! as String;
List<PlayQuestion> _questions() =>
    PlayPayload.fromJson(_start()['play']! as Map<String, dynamic>).questions;

/// Fake server: a recorded session, with a verdict fixture per question type.
class _Server {
  _Server({this.startStatus = 200, this.answersDown = false});

  int startStatus;
  bool answersDown;
  final answered = <Map<String, dynamic>>[];
  bool abandoned = false;
  bool completed = false;
  int myCoursesFetches = 0;
  int unitFetches = 0;

  late final Map<String, String> _verdictFor = {
    for (final q in _questions())
      q.id: switch (q) {
        ChoosePictureQuestion() => 'learn_answer_wrong_choice.json',
        ListeningTranscribeQuestion() => 'learn_answer_almost.json',
        MatchingQuestion() => 'learn_answer_wrong_matching.json',
        _ => 'learn_answer_correct.json',
      },
  };

  Future<ResponseBody> Function(RequestOptions) get handler => routes({
    'GET /auth/me': respondWith('auth_me.json'),
    'GET /learn/me/courses': (_) {
      myCoursesFetches++;
      return fixtureResponse('learn_me_courses_empty.json');
    },
    'GET /learn/units/$_unit': (_) {
      unitFetches++;
      return fixtureResponse('learn_unit.json');
    },
    'POST /learn/exercises/$_exercise/sessions': (_) => startStatus == 200
        ? fixtureResponse('learn_session_start.json', status: 201)
        : fixtureResponse('learn_play_not_enrolled.json', status: 403),
    'POST /learn/sessions/$_sessionId/answers': (o) {
      if (answersDown) networkDown(o);
      final body = jsonDecode(jsonEncode(o.data)) as Map<String, dynamic>;
      answered.add(body);
      return fixtureResponse(_verdictFor[body['questionId']]!);
    },
    'POST /learn/sessions/$_sessionId/complete': (_) {
      completed = true;
      return fixtureResponse('learn_session_complete.json');
    },
    'POST /learn/sessions/$_sessionId/abandon': (_) {
      abandoned = true;
      return FakeAdapter.json({
        'data': {'_id': _sessionId, 'status': 'abandoned'},
      });
    },
  });
}

Future<_Server> _openPlayer(WidgetTester tester, [_Server? server]) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);
  final s = server ?? _Server();
  final api = TestApi((o) => s.handler(o), token: 'stored');
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
  ignore(container.read(appRouterProvider).push(Routes.play(_exercise)));
  await tester.pumpAndSettle();
  return s;
}

void ignore(Future<Object?> _) {}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

Future<void> _check(WidgetTester tester) =>
    _tap(tester, find.text('Check Answer'));

void main() {
  testWidgets('plays all 8 types against server verdicts to the results', (
    tester,
  ) async {
    final server = await _openPlayer(tester);
    final q = _questions();

    // 1. choose_picture → wrong; the right picture is marked; Try Again.
    expect(find.text('1/8'), findsOneWidget);
    expect(find.text('Answer to continue'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(RegExp('^Picture 2')));
    await _check(tester);
    expect(find.text('Incorrect'), findsOneWidget);
    expect(find.text('The right picture is marked in green.'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('correct answer')), findsOneWidget);
    // Buttons in the feedback panel are their own accessibility nodes, so
    // TalkBack can focus them (they used to merge into the panel).
    expect(find.bySemanticsLabel('Try Again'), findsOneWidget);
    expect(find.bySemanticsLabel('Skip & Continue'), findsOneWidget);
    await _tap(tester, find.text('Try Again'));
    expect(find.text('Incorrect'), findsNothing);
    expect(find.text('Answer to continue'), findsOneWidget); // input cleared
    await _tap(tester, find.bySemanticsLabel(RegExp('^Picture 1')));
    await _check(tester);
    expect(find.text('Incorrect'), findsOneWidget);
    await _tap(tester, find.text('Skip & Continue'));

    // 2. multiple_choice → correct → Continue.
    expect(find.text('2/8'), findsOneWidget);
    await _tap(
      tester,
      find.text((q[1] as MultipleChoiceQuestion).options.first.text!),
    );
    await _check(tester);
    expect(find.text('Correct!'), findsOneWidget);
    await _tap(tester, find.text('Continue'));

    // 3. listening_transcribe → almost, with the exact spelling.
    await tester.enterText(find.byType(TextField), 'coeur');
    await tester.pumpAndSettle();
    await _check(tester);
    expect(find.text('Almost!'), findsOneWidget);
    expect(
      find.text('Watch the accents: “cœur”. This still counts as right.'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Continue'));

    // 4–7: correct.
    await _tap(
      tester,
      find.text((q[3] as ListeningSelectQuestion).options.last.text!),
    );
    await _check(tester);
    await _tap(tester, find.text('Continue'));
    await tester.enterText(find.byType(TextField), 'lungs');
    await tester.pumpAndSettle();
    await _check(tester);
    await _tap(tester, find.text('Continue'));
    await tester.enterText(find.byType(TextField), 'sang');
    await tester.pumpAndSettle();
    await _check(tester);
    await _tap(tester, find.text('Continue'));
    final bank = (q[6] as ArrangeSentenceQuestion).bank;
    await _tap(tester, find.bySemanticsLabel('Add ${bank.first.text}'));
    await _check(tester);
    await _tap(tester, find.text('Continue'));

    // 8. matching → wrong, the pairs are listed; skip to the results.
    final matching = q[7] as MatchingQuestion;
    for (var i = 0; i < matching.left.length; i++) {
      await _tap(tester, find.text(matching.left[i].text!));
      await _tap(tester, find.text(matching.right[i].text!));
    }
    await _check(tester);
    expect(find.textContaining('The pairs are:'), findsOneWidget);
    expect(find.textContaining('cœur → heart'), findsOneWidget);
    final homeFetchesBefore = server.myCoursesFetches;
    await _tap(tester, find.text('Skip & see results'));

    // Exercise Complete from the server's numbers (25 of 85 = 29%).
    expect(server.completed, isTrue);
    expect(server.unitFetches, greaterThan(0));
    expect(find.text('Exercise Complete!'), findsOneWidget);
    expect(find.text('29%'), findsOneWidget);
    expect(find.text('Score 25 / 85'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget); // accuracy
    expect(find.text('2/8'), findsOneWidget);
    expect(find.text('Back to the unit'), findsOneWidget);

    // The answer bodies the app sent, one shape per type.
    final shapes = server.answered
        .map((a) => (a['answer']! as Map<String, dynamic>).keys.single)
        .toList();
    expect(shapes, [
      'optionId',
      'optionId',
      'optionId',
      'text',
      'optionId',
      'text',
      'text',
      'blockIds',
      'pairs',
    ]);
    expect(server.answered.every((a) => a['timeTakenMs'] is int), isTrue);
    final pairs = (server.answered.last['answer']! as Map)['pairs'] as List;
    expect(pairs, hasLength(matching.left.length));

    await _tap(tester, find.text('Back to the unit'));
    expect(find.text('Unit Details'), findsOneWidget);

    // Progress comes from the server: Home refetches when it's shown again
    // (Riverpod pauses providers of screens that aren't visible).
    await _tap(
      tester,
      find.descendant(
        of: find.byType(DslBottomNav),
        matching: find.bySemanticsLabel('Home'),
      ),
    );
    expect(server.myCoursesFetches, greaterThan(homeFetchesBefore));
  });

  testWidgets('Quit from Pause abandons the session', (tester) async {
    final server = await _openPlayer(tester);
    await tester.tap(find.byTooltip('Pause'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quit'));
    await tester.pumpAndSettle();

    expect(server.abandoned, isTrue);
    expect(find.text('1/8'), findsNothing);
  });

  testWidgets('a failed check keeps the answer and can be sent again', (
    tester,
  ) async {
    final server = await _openPlayer(tester, _Server(answersDown: true));
    await _tap(tester, find.bySemanticsLabel(RegExp('^Picture 2')));
    await _check(tester);

    expect(find.textContaining("Can't reach the server"), findsOneWidget);
    expect(find.text('Incorrect'), findsNothing);
    server.answersDown = false;
    await _check(tester);
    expect(find.text('Incorrect'), findsOneWidget);
  });

  testWidgets('not enrolled: the server message, and a way back', (
    tester,
  ) async {
    await _openPlayer(tester, _Server(startStatus: 403));

    expect(find.text("Couldn't open this exercise"), findsOneWidget);
    expect(
      find.text('Enroll in this course to play its exercises.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Sara'), findsOneWidget);
  });

  testWidgets('the Check button stays disabled until there is an answer', (
    tester,
  ) async {
    await _openPlayer(tester);
    final cta = tester.widget<DslButton>(find.byType(DslButton).last);
    expect(cta.onPressed, isNull);
    expect(cta.label, 'Answer to continue');
  });
}
