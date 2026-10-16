import 'package:dsl/core/auth/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_api.dart';

void main() {
  test('parses the recorded register response', () {
    final json = fixture('auth_register.json')! as Map<String, dynamic>;
    final session = AuthSession.fromJson(json['data']! as Map<String, dynamic>);

    expect(session.token, 'fixture-token');
    expect(session.user.id, '6ad26a04d1e164a0f973fd52');
    expect(session.user.isStudent, isTrue);
    expect(session.user.displayName, 'Sara Lee');
  });

  test('an unknown role parses as unknown, not a crash', () {
    final user = AppUser.fromJson({
      '_id': '1',
      'email': 'x@y.z',
      'role': 'superuser',
    });
    expect(user.role, UserRole.unknown);
    expect(user.isStudent, isFalse);
    expect(user.displayName, 'x@y.z');
  });
}
