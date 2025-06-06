import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityIndicator extends StatelessWidget {
  const ActivityIndicator({super.key, required this.radius, this.color});

  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color ?? Theme.of(context).colorScheme.onPrimary,
      radius: radius,
    );
  }
}
