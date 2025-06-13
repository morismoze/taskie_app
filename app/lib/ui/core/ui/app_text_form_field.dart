import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.hint,
    this.keyboardType,
    this.validator,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.black1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          obscuringCharacter: '●',
          maxLines: maxLines,
          minLines: minLines,
          textInputAction: textInputAction,
          onTapOutside: (e) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            // Content padding is used to remove padding from the error message
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 15,
            ),
            // Prefix is used as a hack to add prefix padding to
            // the field, because content padding moves both content
            // and error message at the same time
            prefix: const Padding(padding: EdgeInsets.only(left: 12)),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            hintText: hint,
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            prefixIconColor: Theme.of(context).colorScheme.primary,
            suffixIconColor: Theme.of(context).colorScheme.primary,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
