import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPress,
    required this.label,
    this.disabled = false,
    this.shrinkWrap = false,
    this.underline = false,
    this.leadingIcon,
    this.color,
    this.minimumSize,
    this.tapTargetSize,
  });

  final void Function() onPress;
  final String label;
  final bool disabled;
  final bool shrinkWrap;
  final bool underline;
  final IconData? leadingIcon;
  final Color? color;
  final Size? minimumSize;
  final MaterialTapTargetSize? tapTargetSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? null : onPress,
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
        padding: EdgeInsets.zero,
        minimumSize: minimumSize,
        tapTargetSize: tapTargetSize,
      ),
      child: Row(
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
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
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: color ?? Theme.of(context).colorScheme.secondary,
                fontSize: 16,
                decoration: underline ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
