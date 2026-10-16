import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/error_messages.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_text_field.dart';
import 'auth_widgets.dart';
import 'form_validators.dart';
import 'password_visibility_toggle.dart';

/// Figma 02-B "Login" (`55:40`). "Forgot Password?" and "Continue with
/// Google" are left out until their slices (feat-password-reset,
/// feat-google-sign-in). On success the router leaves this screen.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscured = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(email: _email.text.trim(), password: _password.text);
    } on Object catch (error) {
      if (mounted) setState(() => _error = describeError(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final sessionEnded = auth is SignedOut && auth.sessionEnded;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: AuthScrollBody(
            children: [
              const SizedBox(height: AppSpacing.xl),
              const Center(child: AuthLogo()),
              const SizedBox(height: AppSpacing.lg),
              const AuthHeading(
                title: 'Welcome Back!',
                subtitle: 'Continue your domain journey',
              ),
              const SizedBox(height: AppSpacing.xxl),
              if (sessionEnded && _error == null) ...[
                const FormErrorBanner(
                  message: 'Your session has ended. Sign in again.',
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              DslTextField(
                label: 'Email address',
                hint: 'your@email.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: FormValidators.email,
              ),
              const SizedBox(height: AppSpacing.xl),
              DslTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _password,
                obscureText: _obscured,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onSubmitted: (_) => _submit(),
                validator: (v) => FormValidators.required(v, 'password'),
                suffix: PasswordVisibilityToggle(
                  obscured: _obscured,
                  onToggle: () => setState(() => _obscured = !_obscured),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              if (_error != null) ...[
                FormErrorBanner(message: _error!),
                const SizedBox(height: AppSpacing.lg),
              ],
              DslButton(
                label: 'Sign In',
                loading: _submitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.lg),
              AuthSwitchLink(
                prompt: "Don't have an account?",
                action: 'Sign Up',
                onTap: () => context.go(Routes.signUp),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
