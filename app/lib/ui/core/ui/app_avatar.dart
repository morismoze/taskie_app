import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/color.dart';

const kAppAvatarDefaultSize = 40.0;

/// [AppAvatar.imageUrl] takes precedence over text
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.hashString,
    required this.firstName,
    this.imageUrl,
    this.size = kAppAvatarDefaultSize,
  });

  /// This is used for generating unique color out of a string, in
  /// most cases this will be user's ID (workspace user ID).
  final String hashString;
  final String firstName;
  final double size;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ColorGenerator.generateColorFromString(hashString);
    final firstNameFirstLetter = firstName[0];
    final radius = size / 2;
    final textFontSize = radius / 2 <= 20 ? radius * 1.2 : radius * 0.95;
    final isGoogleImage =
        imageUrl != null && imageUrl!.contains('googleusercontent');
    final resizedImage = isGoogleImage
        ? resizeGoogleImage(imageUrl!, size.toInt())
        : imageUrl;

    return CircleAvatar(
      radius: radius,
      foregroundImage: resizedImage != null
          ? CachedNetworkImageProvider(resizedImage)
          : null,
      backgroundColor: backgroundColor,
      child: resizedImage == null
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

  String resizeGoogleImage(String imageUrl, int size) {
    // In Google Image API URL parameters start after `=` sign and it
    // should contain size parameter (e.g. `s96` - meaning the size
    // is set to 96 pixels).

    final googleImageUrlSizeParameterPattern = RegExp(r's\d+');
    // Multipled by two for better quality
    final effectiveSize = size * 2;

    if (!imageUrl.contains(googleImageUrlSizeParameterPattern)) {
      // If the image URL doesn't contain size parameter, then add one.
      // `c` defines that Image API should return square crop.
      return imageUrl + ('s-$effectiveSize-c');
    }

    // Replace the existing set size
    return imageUrl.replaceFirst(
      googleImageUrlSizeParameterPattern,
      's$effectiveSize',
    );
  }
}
