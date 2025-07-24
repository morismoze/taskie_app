import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n_extensions.dart';
import '../../theme/colors.dart';
import '../../theme/theme.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.readOnly = false,
    this.obscureText = false,
    this.required = true,
    this.maxLines = 1,
    this.minLines,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.maxCharacterCount,
    this.suffixIcon,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool readOnly;
  final bool required;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final int? maxCharacterCount;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      enableInteractiveSelection: !readOnly,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      obscuringCharacter: '●',
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxCharacterCount,
      textInputAction: textInputAction,
      cursorColor: Theme.of(context).colorScheme.secondary,
      cursorErrorColor: Theme.of(context).colorScheme.secondary,
      style: TextStyle(
        fontSize: 16,
        color: readOnly
            ? Theme.of(context).disabledColor
            : Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(AppTheme.fieldInnerPadding),
        // This is used for the sole purpose of error text not
        // directly changing field height.
        helperText: '',
        hintText: hintText,
        labelText: required
            ? label
            : '$label (${context.localization.misc_optional})',
        filled: true,

        // This is some hacky way to
        // 1. correctly position the icon widget
        // 2. take minimum space - otherwise, for some reason, it covers
        // the entire field horizontally.
        //
        // Not using `suffix` property because it's shown out-of-the-box for
        // disabled/read only fields, but for enabled fields it is show only
        // when the field is focused (possibly due to the floating label functionality).
        suffixIcon: suffixIcon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [suffixIcon!],
              )
            : null,
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
        disabledBorder: OutlineInputBorder(
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
      ),
    );
  }
}
