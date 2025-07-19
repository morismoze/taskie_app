import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/color.dart';

/// [AppAvatar.imageUrl] takes precedence over text
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.text,
    this.imageUrl,
    this.radius = 20,
  });

  final String text;
  final double radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ColorGenerator.generateColorFromString(text);
    final firstNameFirstLetter = text.split(' ')[0][0];
    final textFontSize = radius <= 20 ? radius * 1.2 : radius * 0.95;

    return CircleAvatar(
      radius: radius,
      foregroundImage: imageUrl != null
          ? CachedNetworkImageProvider(imageUrl!)
          : null,
      backgroundColor: backgroundColor,
      child: imageUrl == null
          ? Text(
              firstNameFirstLetter,
              style: TextStyle(
                fontSize: textFontSize,
                color: AppColors.white1,
                fontWeight: FontWeight.w500,
                height: 1.0,
                textBaseline: TextBaseline.alphabetic,
              ),
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            )
          : null,
    );
  }
}
