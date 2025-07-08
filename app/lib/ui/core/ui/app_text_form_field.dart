import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/colors.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.required = true,
    this.maxLines = 1,
    this.minLines,
    this.hint,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.maxCharacterCount,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool required;
  final int? maxLines;
  final int? minLines;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final int? maxCharacterCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          obscuringCharacter: '●',
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxCharacterCount,
          textInputAction: textInputAction,
          cursorColor: AppColors.black1,
          cursorErrorColor: AppColors.black1,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            // Content padding is used to remove padding from the error message
            contentPadding: const EdgeInsets.only(
              left: 16,
              top: 16,
              bottom: 16,
            ),
            hintText: hint,
            labelText: required
                ? label
                : '$label (${context.localization.optional})',
            filled: true,
            floatingLabelStyle: const TextStyle(
              fontSize: 18,
              color: AppColors.grey2,
              fontWeight: FontWeight.bold,
            ),
            labelStyle: TextStyle(
              color: AppColors.grey2.withValues(alpha: 0.5),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            fillColor: AppColors.grey2.withValues(alpha: 0.075),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            counter: ListenableBuilder(
              listenable: controller,
              builder: (BuildContext builderContext, _) => Text(
                '${controller.text.length}/$maxCharacterCount',
                style: Theme.of(builderContext).textTheme.labelMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
