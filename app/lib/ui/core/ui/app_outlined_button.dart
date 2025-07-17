import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'activity_indicator.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.onPress,
    required this.label,
    this.isLoading = false,
    this.borderColor,
    this.leadingIcon,
  });

  final void Function() onPress;
  final String label;
  final bool isLoading;
  final Color? borderColor;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? () {} : onPress,
      style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
        side: WidgetStateProperty.all(
          BorderSide(
            color: borderColor ?? Theme.of(context).colorScheme.primary,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
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
                if (leadingIcon != null) ...[
                  FaIcon(
                    leadingIcon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
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
