/// Route paths in one place, so screens never hard-code strings.
abstract final class Routes {
  static const home = '/home';
  static const courses = '/courses';
  static const certificates = '/certificates';
  static const profile = '/profile';

  // Debug-only developer screens.
  static const systemCheck = '/dev/system-check';
  static const designSystem = '/dev/design-system';
}
