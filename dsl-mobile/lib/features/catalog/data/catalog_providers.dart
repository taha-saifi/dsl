import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../learn/data/learn_models.dart';
import '../../learn/data/learn_repository.dart';

/// Catalog filters. Starts from the student's onboarding choices (domain
/// and language), as decided in feat-onboarding-and-preferences.
class CatalogFilter {
  const CatalogFilter({
    this.specializationId,
    this.targetLanguage,
    this.search = '',
  });

  final String? specializationId;
  final String? targetLanguage;
  final String search;
}

class CatalogFilterNotifier extends Notifier<CatalogFilter> {
  @override
  CatalogFilter build() {
    // Rebuilt for each signed-in student (so the next account on this
    // phone doesn't inherit filters), and once onboarding has saved
    // preferences; otherwise what the student picks here is kept.
    ref.watch(
      authControllerProvider.select(
        (auth) => auth is SignedIn
            ? (auth.user.id, auth.user.preferences == null)
            : null,
      ),
    );
    final auth = ref.read(authControllerProvider);
    final preferences = auth is SignedIn ? auth.user.preferences : null;
    return CatalogFilter(
      specializationId: preferences?.specializationId,
      targetLanguage: preferences?.targetLanguage,
    );
  }

  /// null = all domains. A new domain may not have the chosen language, so
  /// the language filter is cleared with it.
  void selectDomain(String? id) => state = CatalogFilter(
    specializationId: id,
    targetLanguage: id == state.specializationId ? state.targetLanguage : null,
    search: state.search,
  );

  /// null = all languages.
  void selectLanguage(String? code) => state = CatalogFilter(
    specializationId: state.specializationId,
    targetLanguage: code,
    search: state.search,
  );

  void search(String text) => state = CatalogFilter(
    specializationId: state.specializationId,
    targetLanguage: state.targetLanguage,
    search: text,
  );
}

final catalogFilterProvider =
    NotifierProvider<CatalogFilterNotifier, CatalogFilter>(
      CatalogFilterNotifier.new,
    );

/// Courses for the current filters. A preferred domain that no longer has
/// published courses (it isn't in the domain list) is ignored rather than
/// showing an empty catalog.
final catalogCoursesProvider = FutureProvider.autoDispose<List<CourseSummary>>((
  ref,
) async {
  final filter = ref.watch(catalogFilterProvider);
  final domains = await ref.watch(specializationsProvider.future);
  final domainId = domains.any((d) => d.id == filter.specializationId)
      ? filter.specializationId
      : null;
  return ref
      .watch(learnRepositoryProvider)
      .courses(
        specializationId: domainId,
        targetLanguage: filter.targetLanguage,
        search: filter.search,
      );
});

final courseDetailProvider = FutureProvider.autoDispose
    .family<CourseDetail, String>(
      (ref, id) => ref.watch(learnRepositoryProvider).course(id),
    );

final myCoursesProvider = FutureProvider.autoDispose<List<CourseSummary>>(
  (ref) => ref.watch(learnRepositoryProvider).myCourses(),
);

/// Enroll / leave, then refresh every list that shows enrollment.
class EnrollmentActions {
  const EnrollmentActions(this._ref);

  final Ref _ref;

  Future<void> enroll(String courseId) async {
    await _ref.read(learnRepositoryProvider).enroll(courseId);
    _refresh(courseId);
  }

  Future<void> unenroll(String courseId) async {
    await _ref.read(learnRepositoryProvider).unenroll(courseId);
    _refresh(courseId);
  }

  void _refresh(String courseId) => _ref
    ..invalidate(myCoursesProvider)
    ..invalidate(catalogCoursesProvider)
    ..invalidate(courseDetailProvider(courseId));
}

final enrollmentActionsProvider = Provider<EnrollmentActions>(
  EnrollmentActions.new,
);
