import 'package:flutter/material.dart';

import 'blurred_circle.dart';

class BlurredCirclesBackground extends StatelessWidget {
  const BlurredCirclesBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return (Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: BlurredCircle(
            color: Colors.yellow.withValues(alpha: 0.15),
            radius: 100,
            blurSigma: 40,
          ),
        ),
        Positioned(
          top: 100,
          left: -50,
          child: BlurredCircle(
            color: Colors.greenAccent.withValues(alpha: 0.15),
            radius: 100,
            blurSigma: 45,
          ),
        ),
        Positioned(
          top: 200,
          right: -100,
          child: BlurredCircle(
            color: Colors.blue.withValues(alpha: 0.15),
            radius: 100,
            blurSigma: 45,
          ),
        ),
        Positioned(
          top: 400,
          left: 50,
          child: BlurredCircle(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            radius: 75,
            blurSigma: 45,
          ),
        ),
        Positioned(
          bottom: 150,
          right: 50,
          child: BlurredCircle(
            color: Colors.purple.withValues(alpha: 0.1),
            radius: 100,
            blurSigma: 45,
          ),
        ),
        child,
      ],
    ));
  }
}
