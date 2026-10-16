import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_providers.dart';
import 'learn_models.dart';

/// Student reads of published content: only `/learn/*`. The authoring
/// routes (`/courses`, `/units`…) are teacher-only and answer students 403.
/// Hidden or missing content fails with a 404 [ApiException]
/// (`COURSE_NOT_FOUND`, `UNIT_NOT_FOUND`).
class LearnRepository {
  const LearnRepository(this._client);

  final ApiClient _client;

  Future<List<SpecializationSummary>> specializations() => _client.get(
    '/learn/specializations',
    decode: (data) => _list(data, SpecializationSummary.fromJson),
  );

  Future<List<LanguageSummary>> languages({String? specializationId}) =>
      _client.get(
        '/learn/languages',
        query: {'specializationId': ?specializationId},
        decode: (data) => _list(data, LanguageSummary.fromJson),
      );

  /// Newest first. Blank [search] is not sent.
  Future<List<CourseSummary>> courses({
    String? specializationId,
    String? targetLanguage,
    String? search,
  }) {
    final query = search?.trim();
    return _client.get(
      '/learn/courses',
      query: {
        'specializationId': ?specializationId,
        'targetLanguage': ?targetLanguage,
        if (query != null && query.isNotEmpty) 'search': query,
      },
      decode: (data) => _list(data, CourseSummary.fromJson),
    );
  }

  Future<CourseDetail> course(String id) => _client.get(
    '/learn/courses/$id',
    decode: (data) => CourseDetail.fromJson(data! as Map<String, dynamic>),
  );

  Future<UnitDetail> unit(String id) => _client.get(
    '/learn/units/$id',
    decode: (data) => UnitDetail.fromJson(data! as Map<String, dynamic>),
  );

  /// Enrolled courses that are still published, most recently enrolled
  /// first (students only).
  Future<List<CourseSummary>> myCourses() => _client.get(
    '/learn/me/courses',
    decode: (data) => _list(data, CourseSummary.fromJson),
  );

  /// Idempotent. 404 if the course isn't published all the way down.
  Future<void> enroll(String courseId) =>
      _client.post('/learn/courses/$courseId/enroll', decode: (_) {});

  /// Idempotent.
  Future<void> unenroll(String courseId) =>
      _client.delete('/learn/courses/$courseId/enroll', decode: (_) {});

  static List<T> _list<T>(
    Object? data,
    T Function(Map<String, dynamic>) fromJson,
  ) => (data! as List<Object?>)
      .map((item) => fromJson(item! as Map<String, dynamic>))
      .toList();
}

final learnRepositoryProvider = Provider<LearnRepository>(
  (ref) => LearnRepository(ref.watch(apiClientProvider)),
);

final specializationsProvider =
    FutureProvider.autoDispose<List<SpecializationSummary>>(
      (ref) => ref.watch(learnRepositoryProvider).specializations(),
    );

/// Languages with visible courses, in one domain when [specializationId]
/// is given.
final languagesProvider = FutureProvider.autoDispose
    .family<List<LanguageSummary>, String?>(
      (ref, specializationId) => ref
          .watch(learnRepositoryProvider)
          .languages(specializationId: specializationId),
    );
