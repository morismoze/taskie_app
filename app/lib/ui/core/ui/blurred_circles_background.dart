import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredCirclesBackground extends StatelessWidget {
  const BlurredCirclesBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -10,
          child: _BlurredCircle(
            color: Colors.yellow.withValues(alpha: 0.15),
            radius: 80,
            blurSigma: 40,
          ),
        ),
        Positioned(
          top: 100,
          left: -50,
          child: _BlurredCircle(
            color: Colors.greenAccent.withValues(alpha: 0.15),
            radius: 80,
            blurSigma: 30,
          ),
        ),
        Positioned(
          top: 250,
          right: -40,
          child: _BlurredCircle(
            color: Colors.blue.withValues(alpha: 0.15),
            radius: 80,
            blurSigma: 45,
          ),
        ),
        Positioned(
          top: 500,
          left: 50,
          child: _BlurredCircle(
            color: Colors.lightBlue.withValues(alpha: 0.1),
            radius: 75,
            blurSigma: 45,
          ),
        ),
        Positioned(
          bottom: 50,
          right: -20,
          child: _BlurredCircle(
            color: Colors.yellow.withValues(alpha: 0.15),
            radius: 50,
            blurSigma: 35,
          ),
        ),
        child,
      ],
    );
  }
}

class _BlurredCircle extends StatelessWidget {
  final Color color;
  final double radius;
  final double blurSigma; // Blur strength

  const _BlurredCircle({
    required this.color,
    required this.radius,
    this.blurSigma = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
