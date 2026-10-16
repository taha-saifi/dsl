import 'package:dsl/core/auth/app_user.dart';
import 'package:dsl/core/auth/auth_controller.dart';
import 'package:dsl/core/router/auth_redirect.dart';
import 'package:dsl/core/router/routes.dart';
import 'package:flutter_test/flutter_test.dart';

AppUser _user(UserRole role, {bool onboarded = true}) => AppUser(
  id: '1',
  email: 'a@b.co',
  role: role,
  firstName: 'A',
  preferences: onboarded
      ? const LearningPreferences(goal: LearningGoal.academic)
      : null,
);

void main() {
  const restoring = AuthRestoring();
  const signedOut = SignedOut();
  const ended = SignedOut(sessionEnded: true);
  final student = SignedIn(_user(UserRole.student));
  final teacher = SignedIn(_user(UserRole.teacher, onboarded: false));
  final newStudent = SignedIn(_user(UserRole.student, onboarded: false));
  final offline = SessionUnverified(Exception('offline'));

  final cases = <(String, AuthState, String, String?)>[
    ('restoring holds on launch', restoring, Routes.home, Routes.launch),
    ('restoring stays on launch', restoring, Routes.launch, null),
    ('signed out → welcome', signedOut, Routes.home, Routes.welcome),
    (
      'signed out from launch → welcome',
      signedOut,
      Routes.launch,
      Routes.welcome,
    ),
    ('signed out may sign in', signedOut, Routes.signIn, null),
    ('signed out may sign up', signedOut, Routes.signUp, null),
    ('session ended → sign in', ended, Routes.profile, Routes.signIn),
    ('student leaves sign-in for home', student, Routes.signIn, Routes.home),
    ('student leaves launch for home', student, Routes.launch, Routes.home),
    ('student stays on a tab', student, Routes.courses, null),
    ('teacher → students only', teacher, Routes.home, Routes.studentsOnly),
    ('teacher stays on students only', teacher, Routes.studentsOnly, null),
    (
      'admin → students only',
      SignedIn(_user(UserRole.admin)),
      Routes.home,
      Routes.studentsOnly,
    ),
    (
      'unknown role → students only',
      SignedIn(_user(UserRole.unknown)),
      Routes.home,
      Routes.studentsOnly,
    ),
    (
      'new student → onboarding',
      newStudent,
      Routes.home,
      Routes.onboardingDomain,
    ),
    (
      'new student from sign-up → onboarding',
      newStudent,
      Routes.signUp,
      Routes.onboardingDomain,
    ),
    (
      'new student stays on a later step',
      newStudent,
      Routes.onboardingProfile,
      null,
    ),
    (
      'onboarded student leaves onboarding',
      student,
      Routes.onboardingLanguage,
      Routes.home,
    ),
    (
      'teacher never sees onboarding',
      teacher,
      Routes.onboardingDomain,
      Routes.studentsOnly,
    ),
    ('offline → reconnect', offline, Routes.home, Routes.reconnect),
    ('dev screens always open', signedOut, Routes.systemCheck, null),
  ];

  for (final (name, state, location, expected) in cases) {
    test(name, () => expect(authRedirect(state, location), expected));
  }
}
