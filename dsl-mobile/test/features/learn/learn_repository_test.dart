import 'package:dsl/core/api/api_client.dart';
import 'package:dsl/core/api/api_exception.dart';
import 'package:dsl/features/learn/data/learn_repository.dart';
import 'package:dsl/features/learn/data/question_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_adapter.dart';
import '../../helpers/test_api.dart';

/// Repository + real ApiClient over recorded `/learn` responses.
(LearnRepository, FakeAdapter) _repo(String fixtureName, {int status = 200}) {
  final storage = MemoryTokenStorage('stored');
  final dio = createDio(
    baseUrl: testConfig.apiBaseUrl,
    tokenStorage: storage,
    onUnauthorized: () {},
  );
  final adapter = FakeAdapter(
    (_) async => fixtureResponse(fixtureName, status: status),
  );
  dio.httpClientAdapter = adapter;
  return (LearnRepository(ApiClient(dio)), adapter);
}

void main() {
  group('courses', () {
    test('parses the recorded list, thumbnail URL included', () async {
      final (repo, _) = _repo('learn_courses.json');
      final courses = await repo.courses();

      expect(courses, hasLength(1));
      final course = courses.single;
      expect(course.name, 'S3 Full Course 4zjs');
      expect(course.targetLanguage, 'fr');
      expect(course.unitCount, 1);
      expect(course.exerciseCount, 3);
      expect(course.thumbnailUrl, startsWith('http://localhost:9000/'));
    });

    test('sends the filters, trims search and drops a blank one', () async {
      final (repo, adapter) = _repo('learn_courses.json');

      await repo.courses(
        specializationId: 'spec',
        targetLanguage: 'fr',
        search: '  anatomy ',
      );
      expect(adapter.requests.last.path, '/learn/courses');
      expect(adapter.requests.last.queryParameters, {
        'specializationId': 'spec',
        'targetLanguage': 'fr',
        'search': 'anatomy',
      });

      await repo.courses(search: '   ');
      expect(adapter.requests.last.queryParameters, isEmpty);
    });
  });

  test(
    'course detail splits the flat response into course and units',
    () async {
      final (repo, adapter) = _repo('learn_course.json');
      final detail = await repo.course('6ad28f21dcbfbc7ecf3f1a95');

      expect(
        adapter.requests.single.path,
        '/learn/courses/6ad28f21dcbfbc7ecf3f1a95',
      );
      expect(detail.course.name, 'S3 Full Course 4zjs');
      expect(detail.course.description, 'S3 Full Course 4zjs description');
      expect(detail.units.single.name, 'A1 Published unit');
      expect(detail.units.single.exerciseCount, 3);
    },
  );

  test('unit detail lists playable exercises in order', () async {
    final (repo, adapter) = _repo('learn_unit.json');
    final unit = await repo.unit('6ad28f21dcbfbc7ecf3f1a96');

    expect(
      adapter.requests.single.path,
      '/learn/units/6ad28f21dcbfbc7ecf3f1a96',
    );
    expect(unit.courseName, 'S3 Full Course 4zjs');
    expect(unit.exercises.map((e) => (e.name, e.questionCount)), [
      ('A1 ex 1 (published)', 2),
      ('A1 ex 2 (published)', 1),
      ('Organs: mixed practice', 8),
    ]);
    expect(unit.exercises.last.questionTypes, [
      QuestionType.choosePicture,
      QuestionType.multipleChoice,
      QuestionType.listeningTranscribe,
      QuestionType.listeningSelect,
      QuestionType.typing,
      QuestionType.fillBlank,
      QuestionType.arrangeSentence,
      QuestionType.matching,
    ]);
  });

  test('hidden content is a 404 with the server code', () async {
    final (repo, _) = _repo('learn_course_not_found.json', status: 404);

    await expectLater(
      repo.course('draft'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.status, 'status', 404)
            .having((e) => e.code, 'code', 'COURSE_NOT_FOUND')
            .having((e) => e.isUnauthorized, 'isUnauthorized', isFalse),
      ),
    );
  });

  test('specializations and languages parse their fixtures', () async {
    final (specRepo, _) = _repo('learn_specializations.json');
    final domains = await specRepo.specializations();
    expect(domains.map((d) => (d.name, d.publishedCourseCount)), [
      ('E2E Languages', 1),
      ('S3 Medical 4zjs', 1),
    ]);

    final (langRepo, adapter) = _repo('learn_languages.json');
    final languages = await langRepo.languages(specializationId: 'spec');
    expect(languages.single.code, 'fr');
    expect(adapter.requests.single.queryParameters, {
      'specializationId': 'spec',
    });
  });

  test('my courses parse with enrollment fields', () async {
    final (repo, adapter) = _repo('learn_me_courses.json');
    final courses = await repo.myCourses();

    expect(adapter.requests.single.path, '/learn/me/courses');
    expect(courses.single.isEnrolled, isTrue);
    expect(courses.single.enrolledAt, isNotNull);
    expect(courses.single.specializationName, 'S3 Medical 4zjs');
  });

  test('enroll and unenroll call the enrollment route', () async {
    final (repo, adapter) = _repo('learn_enroll.json');
    await repo.enroll('c1');
    await repo.unenroll('c1');

    expect(adapter.requests.map((r) => '${r.method} ${r.path}'), [
      'POST /learn/courses/c1/enroll',
      'DELETE /learn/courses/c1/enroll',
    ]);
  });
}
