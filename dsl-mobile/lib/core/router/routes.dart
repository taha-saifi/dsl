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

  // Signed-in tabs.
  static const home = '/home';
  static const courses = '/courses';
  static const certificates = '/certificates';
  static const profile = '/profile';

  // Debug-only developer screens.
  static const systemCheck = '/dev/system-check';
  static const designSystem = '/dev/design-system';
}
