import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'auth_widgets.dart';

/// Shown while the stored token is checked. It continues the native splash
/// (same Ink background and logo), with a spinner in case the API is slow.
class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AuthLogo(size: 104),
            const SizedBox(height: AppSpacing.xxxl),
            Semantics(
              label: 'Signing you in',
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: context.colors.cyan,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
