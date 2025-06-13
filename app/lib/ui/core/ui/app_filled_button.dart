import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'activity_indicator.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.onPress,
    required this.label,
    this.isLoading = false,
    this.backgroundColor,
    this.leadingIcon,
  });

  final void Function() onPress;
  final String label;
  final bool isLoading;
  final Color? backgroundColor;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPress,
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
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
              children: [
                if (leadingIcon != null)
                  FaIcon(
                    leadingIcon,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
