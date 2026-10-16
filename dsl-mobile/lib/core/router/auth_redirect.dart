import '../auth/auth_controller.dart';
import 'routes.dart';

const _signedOutRoutes = {Routes.welcome, Routes.signIn, Routes.signUp};
const _sessionRoutes = {
  Routes.launch,
  Routes.reconnect,
  Routes.studentsOnly,
  ..._signedOutRoutes,
};

/// The one auth guard (docs/decisions/mobile-architecture.md, "Routing").
/// Returns where to go instead of [location], or null to stay.
String? authRedirect(AuthState auth, String location) {
  // Developer screens work in any state (e.g. System check while offline).
  if (location.startsWith('/dev/')) return null;

  final target = switch (auth) {
    AuthRestoring() => Routes.launch,
    SessionUnverified() => Routes.reconnect,
    SignedOut(:final sessionEnded) =>
      _signedOutRoutes.contains(location)
          ? location
          : (sessionEnded ? Routes.signIn : Routes.welcome),
    SignedIn(:final user) when !user.isStudent => Routes.studentsOnly,
    SignedIn() => _sessionRoutes.contains(location) ? Routes.home : location,
  };
  return target == location ? null : target;
}
