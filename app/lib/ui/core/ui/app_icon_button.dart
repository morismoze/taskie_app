import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPress,
    this.color,
  });

  final Widget icon;
  final void Function() onPress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPress, icon: icon);
  }
}
