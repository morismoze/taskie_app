import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredCircle extends StatelessWidget {
  final Color color;
  final double radius;
  final double blurSigma; // Blur strength

  const BlurredCircle({
    super.key,
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
