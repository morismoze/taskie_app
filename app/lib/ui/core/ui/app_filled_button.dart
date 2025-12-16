import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'activity_indicator.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.onPress,
    required this.label,
    this.loading = false,
    this.disabled = false,
    this.shrinkWrap = false,
    this.backgroundColor,
    this.leadingIcon,
    this.trailingIcon,
    this.fontSize,
  });

  final void Function() onPress;
  final String label;
  final bool loading;
  final bool disabled;
  final bool shrinkWrap;
  final Color? backgroundColor;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize =
        fontSize ?? Theme.of(context).textTheme.titleSmall!.fontSize;
    final effectiveBackgroundColor =
        backgroundColor ?? Theme.of(context).colorScheme.primary;

    return FilledButton(
      onPressed: loading || disabled ? null : onPress,
      style: ButtonStyle(
        padding: shrinkWrap
            ? const WidgetStateProperty<EdgeInsetsGeometry>.fromMap({
                WidgetState.any: EdgeInsets.symmetric(horizontal: 10),
              })
            : null, // Default styles
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Color.lerp(effectiveBackgroundColor, Colors.white, 0.85)!;
          }
          return effectiveBackgroundColor;
        }),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: !loading,
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
              children: [
                if (leadingIcon != null) ...[
                  FaIcon(
                    leadingIcon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: effectiveFontSize,
                  ),
                  const SizedBox(width: 8),
                ],
                Padding(
                  padding: EdgeInsets.symmetric(vertical: shrinkWrap ? 2 : 12),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: effectiveFontSize,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  FaIcon(
                    trailingIcon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: effectiveFontSize,
                  ),
                ],
              ],
            ),
          ),
          Visibility(
            visible: loading,
            child: ActivityIndicator(
              radius: 11,
              color: effectiveBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
