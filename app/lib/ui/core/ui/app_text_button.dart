import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPress,
    required this.label,
    this.leadingIcon,
    this.color,
    this.disabled = false,
  });

  final void Function() onPress;
  final String label;
  final IconData? leadingIcon;
  final Color? color;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? () {} : onPress,
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            SizedBox(
              width:
                  18, // FaIcon.size gives weird diffs on icons with different widths
              height:
                  18, // FaIcon.size gives weird diffs on icons with different widths
              child: Align(
                alignment: Alignment.center,
                child: FaIcon(
                  leadingIcon,
                  color: color ?? Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: color ?? Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
