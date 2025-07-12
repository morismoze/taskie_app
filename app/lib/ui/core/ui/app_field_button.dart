import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/colors.dart';
import '../theme/theme.dart';

/// This is a custom "field" which acts as a button and
/// invokes an action through provided [onTap] (e.g. onTap
/// can open a modal bottom sheet).
///
/// This is normally used to showcase custom widgets
/// inside the field, rather than plain text.
class AppFieldButton extends StatelessWidget {
  const AppFieldButton({
    super.key,
    required this.label,
    required this.isFieldFocused,
    required this.onTap,
    required this.child,
    this.trailingIcon,
  });

  final String label;
  final bool isFieldFocused;
  final Function() onTap;
  final Widget child;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    // This is attempt at imitating TextField's floating label placement
    final fieldFocusedlabelTopPosition =
        -(AppTheme.fieldInnerPadding +
            AppTheme.fieldUnfocusedLabelFontSize / 1.5);

    return Material(
      borderRadius: BorderRadius.circular(AppTheme.fieldBorderRadius),
      color: AppColors.fieldFillColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.fieldBorderRadius),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 56,
            minWidth: double.infinity,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.fieldInnerPadding),
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: child),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FaIcon(
                          trailingIcon,
                          color: AppColors.black1,
                          size: 15,
                        ),
                      ),
                    ],
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  top: isFieldFocused ? fieldFocusedlabelTopPosition : null,
                  child: IgnorePointer(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: isFieldFocused
                            ? Theme.of(context).textTheme.labelMedium!.color
                            : AppColors.fieldUnfocusedLabelColor,
                        fontSize: isFieldFocused
                            ? AppTheme.fieldUnfocusedLabelFontSize
                            : AppTheme.fieldLabelFontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
