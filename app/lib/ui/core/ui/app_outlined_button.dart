import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.onPress,
    required this.label,
    this.disabled = false,
    this.color,
    this.leadingIcon,
  });

  final void Function() onPress;
  final String label;
  final bool disabled;
  final Color? color;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: disabled ? null : onPress,
      style: ButtonStyle(
        side: WidgetStatePropertyAll(
          BorderSide(
            color: color ?? Theme.of(context).colorScheme.primary,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            FaIcon(leadingIcon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: color ?? Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
