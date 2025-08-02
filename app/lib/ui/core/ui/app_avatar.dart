import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/color.dart';

const kAppAvatarRadius = 20.0;
const kAppAvatarSize = kAppAvatarRadius * 2;

/// [AppAvatar.imageUrl] takes precedence over text
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.hashString,
    required this.firstName,
    this.imageUrl,
    this.radius = kAppAvatarRadius,
  });

  /// This is used for generating unique color out of a string, in
  /// most cases this will be user's ID (workspace user ID).
  final String hashString;
  final String firstName;
  final double radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ColorGenerator.generateColorFromString(hashString);
    final firstNameFirstLetter = firstName[0];
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
