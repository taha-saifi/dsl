import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Figma "DS · Inputs" (`52:164`) with the uppercase label the auth screens
/// put above each field ("EMAIL ADDRESS"). Borders, fill and focus/error
/// states come from the theme's `inputDecorationTheme`.
class DslTextField extends StatelessWidget {
  const DslTextField({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.suffix,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: type.label.copyWith(
            color: hasError ? colors.error : colors.muted,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          style: type.body.copyWith(fontSize: 15, color: colors.white),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helperText,
            helperStyle: type.caption.copyWith(color: colors.muted),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
