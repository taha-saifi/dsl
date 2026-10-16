import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  const PasswordVisibilityToggle({
    required this.obscured,
    required this.onToggle,
    super.key,
  });

  final bool obscured;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    // Out of focus traversal, so the keyboard's Next goes to the next field
    // instead of landing on this button.
    return ExcludeFocus(
      child: IconButton(
        onPressed: onToggle,
        tooltip: obscured ? 'Show password' : 'Hide password',
        icon: Icon(
          obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: context.colors.muted,
        ),
      ),
    );
  }
}
