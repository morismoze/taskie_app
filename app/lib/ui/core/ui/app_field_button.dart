import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/colors.dart';
import '../theme/theme.dart';

/// This is a custom "field" which acts as a button and
/// invokes an action through provided [onTap] (e.g. onTap
/// can open a modal bottom sheet).
///
/// This class is normally used to showcase custom widgets
/// inside the field, rather than plain text.
class AppFieldButton extends StatelessWidget {
  const AppFieldButton({
    super.key,
    required this.label,
    required this.isFieldFocused,
    required this.onTap,
    required this.child,
    this.required = true,
    this.trailing,
  });

  final String label;
  final bool isFieldFocused;
  final Function() onTap;
  final Widget child;
  final bool required;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    // This is attempt at imitating TextField's floating label placement
    final fieldFocusedlabelTopPosition =
        -(AppTheme.fieldInnerPadding +
            AppTheme.fieldUnfocusedLabelFontSize / 1.5);
    final mappedLabel = required
        ? label
        : '$label (${context.localization.misc_optional})';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.fieldBorderRadius),
        color: AppColors.fieldFillColor,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: AppTheme.fieldHeight,
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
                    if (trailing != null) ...[
                      const SizedBox(width: 4),
                      Align(alignment: Alignment.centerRight, child: trailing),
                    ],
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  top: isFieldFocused ? fieldFocusedlabelTopPosition : 1,
                  child: IgnorePointer(
                    child: Text(
                      mappedLabel,
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
