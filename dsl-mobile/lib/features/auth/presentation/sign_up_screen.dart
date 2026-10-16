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

/// Figma 02-C "Sign Up" (`55:68`), with first and last name as two fields
/// (feat-student-accounts, Q2). Confirm password and the terms box are
/// checked here only; the API records `termsAcceptedAt`. The "Step 1 of 4"
/// bar arrives with onboarding in slice 2.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscured = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final fieldsValid = _formKey.currentState!.validate();
    setState(() => _showTermsError = !_acceptedTerms);
    if (_submitting || !fieldsValid || !_acceptedTerms) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .register(
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
          );
    } on Object catch (error) {
      if (mounted) setState(() => _error = describeError(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(Routes.welcome),
        ),
      ),
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: AuthScrollBody(
            children: [
              const Center(child: AuthLogo(size: 84)),
              const SizedBox(height: AppSpacing.lg),
              const AuthHeading(
                title: 'Create Account',
                subtitle: 'Start mastering your domain today',
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DslTextField(
                      label: 'First name',
                      hint: 'Ahmed',
                      controller: _firstName,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.givenName],
                      validator: (v) =>
                          FormValidators.required(v, 'first name'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DslTextField(
                      label: 'Last name',
                      hint: 'Benali',
                      controller: _lastName,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.familyName],
                      validator: (v) => FormValidators.required(v, 'last name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
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
                hint: 'Minimum 8 characters',
                controller: _password,
                obscureText: _obscured,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: FormValidators.newPassword,
                suffix: PasswordVisibilityToggle(
                  obscured: _obscured,
                  onToggle: () => setState(() => _obscured = !_obscured),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              DslTextField(
                label: 'Confirm password',
                hint: 'Re-enter your password',
                controller: _confirm,
                obscureText: _obscured,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (v) =>
                    v != _password.text ? "The passwords don't match." : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              _TermsCheckbox(
                value: _acceptedTerms,
                showError: _showTermsError,
                onChanged: (value) => setState(() {
                  _acceptedTerms = value;
                  if (value) _showTermsError = false;
                }),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (_error != null) ...[
                FormErrorBanner(message: _error!),
                const SizedBox(height: AppSpacing.lg),
              ],
              DslButton(
                label: 'Create Account',
                loading: _submitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.md),
              AuthSwitchLink(
                prompt: 'Already have an account?',
                action: 'Sign In',
                onTap: () => context.go(Routes.signIn),
              ),
              Text(
                'Teachers: your account is created by an admin. Sign in on '
                'the web dashboard.',
                textAlign: TextAlign.center,
                style: type.caption.copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({
    required this.value,
    required this.showError,
    required this.onChanged,
  });

  final bool value;
  final bool showError;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MergeSemantics(
          child: InkWell(
            onTap: () => onChanged(!value),
            borderRadius: BorderRadius.circular(AppRadii.input),
            child: Row(
              children: [
                Checkbox(
                  value: value,
                  onChanged: (v) => onChanged(v ?? false),
                  activeColor: colors.cyan,
                  side: BorderSide(
                    color: showError ? colors.error : colors.inkBorder,
                    width: 1.5,
                  ),
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms of Service & Privacy Policy',
                    style: type.body.copyWith(color: colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            child: Text(
              'Accept the terms to create your account.',
              style: type.caption.copyWith(color: colors.error),
            ),
          ),
      ],
    );
  }
}
