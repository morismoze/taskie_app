import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'activity_indicator.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.onPress,
    required this.label,
    this.isLoading = false,
    this.isDisabled = false,
    this.shrinkWrap = false,
    this.backgroundColor,
    this.leadingIcon,
    this.trailingIcon,
    this.fontSize,
  });

  final void Function() onPress;
  final String label;
  final bool isLoading;
  final bool isDisabled;
  final bool shrinkWrap;
  final Color? backgroundColor;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize =
        fontSize ?? Theme.of(context).textTheme.titleMedium!.fontSize;

    return FilledButton(
      onPressed: isLoading || isDisabled ? () {} : onPress,
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
        padding: shrinkWrap
            ? const WidgetStateProperty<EdgeInsetsGeometry>.fromMap({
                WidgetState.any: EdgeInsets.symmetric(horizontal: 10),
              })
            : Theme.of(context).filledButtonTheme.style!.padding,
        backgroundColor: backgroundColor != null
            ? WidgetStateProperty.all(backgroundColor)
            : Theme.of(context).filledButtonTheme.style!.backgroundColor,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: !isLoading,
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
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
            visible: isLoading,
            child: const ActivityIndicator(radius: 11),
          ),
        ],
      ),
    );
  }
}
