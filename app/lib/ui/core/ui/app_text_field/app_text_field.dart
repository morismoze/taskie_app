import 'package:flutter/material.dart';

import '../../l10n/l10n_extensions.dart';
import '../../theme/colors.dart';
import '../../theme/theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.required = true,
    this.maxLines = 1,
    this.readOnly = false,
    this.minLines,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.maxCharacterCount,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool required;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxCharacterCount;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      keyboardType: keyboardType,
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
        contentPadding: EdgeInsets.all(AppTheme.fieldInnerPadding),
        // This is used for the sole purpose of error text not
        // directly changing field height.
        helperText: '',
        hintText: hint,
        labelText: required
            ? label
            : '$label (${context.localization.misc_optional})',
        filled: true,
        floatingLabelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
          fontSize:
              AppTheme.fieldUnfocusedLabelFontSize +
              (AppTheme.fieldUnfocusedLabelFontSize * 0.25).round(),
        ),
        labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: AppColors.fieldUnfocusedLabelColor,
          fontSize: AppTheme.fieldLabelFontSize,
        ),
        fillColor: AppColors.fieldFillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.fieldBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.fieldBorderRadius),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.fieldBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.fieldBorderRadius),
          borderSide: BorderSide.none,
        ),
        counter: maxCharacterCount != null
            ? ListenableBuilder(
                listenable: controller,
                builder: (BuildContext builderContext, _) => Text(
                  '${controller.text.length}/$maxCharacterCount',
                  style: Theme.of(builderContext).textTheme.labelMedium,
                ),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [suffixIcon!],
              )
            : null,
      ),
    );
  }
}
