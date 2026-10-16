/// Client-side checks that only save a round trip. The backend validates
/// everything again and its message is what the student sees on failure.
abstract final class FormValidators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Mirrors `PASSWORD_MIN_LENGTH` in `dsl-backend/src/services/userAccount.service.ts`.
  static const passwordMinLength = 8;

  static String? required(String? value, String field) =>
      (value == null || value.trim().isEmpty) ? 'Enter your $field.' : null;

  static String? email(String? value) {
    final missing = required(value, 'email address');
    if (missing != null) return missing;
    return _email.hasMatch(value!.trim())
        ? null
        : 'Enter a valid email address.';
  }

  static String? newPassword(String? value) {
    final missing = required(value, 'password');
    if (missing != null) return missing;
    return value!.trim().length < passwordMinLength
        ? 'Use at least $passwordMinLength characters.'
        : null;
  }
}
