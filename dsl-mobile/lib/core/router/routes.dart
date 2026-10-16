/// Route paths in one place, so screens never hard-code strings.
abstract final class Routes {
  // Session states (see auth_redirect.dart).
  static const launch = '/';
  static const reconnect = '/reconnect';
  static const studentsOnly = '/students-only';

  // Signed out.
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';

  // Students without preferences (nested, so the draft survives Back).
  static const onboardingDomain = '/onboarding';
  static const onboardingLanguage = '/onboarding/language';
  static const onboardingProfile = '/onboarding/language/profile';

  // Signed-in tabs.
  static const home = '/home';
  static const courses = '/courses';
  static const certificates = '/certificates';
  static const profile = '/profile';

  /// Course Details, inside the Courses tab.
  static String course(String id) => '$courses/$id';

  /// Unit Details and Exercise Intro, nested under their course.
  static String unit(String courseId, String unitId) =>
      '${course(courseId)}/units/$unitId';

  static String exerciseIntro(
    String courseId,
    String unitId,
    String exerciseId,
  ) => '${unit(courseId, unitId)}/exercises/$exerciseId';

  /// The exercise player: full screen, above the tabs.
  static String play(String exerciseId) => '/play/$exerciseId';

  // Debug-only developer screens.
  static const systemCheck = '/dev/system-check';
  static const designSystem = '/dev/design-system';
}
