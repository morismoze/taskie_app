import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPress,
    this.color,
    this.iconSize,
  });

  final Widget icon;
  final void Function() onPress;
  final Color? color;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: icon,
      iconSize: iconSize,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
