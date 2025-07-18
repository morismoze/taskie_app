import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/color.dart';

/// [AppAvatar.imageUrl] takes precedence over text
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.text, this.imageUrl});

  final String text;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ColorGenerator.generateColorFromString(text);
    final firstNameFirstLetter = text.split(' ')[0][0];

    return CircleAvatar(
      foregroundImage: imageUrl != null
          ? CachedNetworkImageProvider(imageUrl!)
          : null,
      backgroundColor: backgroundColor,
      child: imageUrl == null
          ? Text(
              firstNameFirstLetter,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: AppColors.white1,
                fontWeight: FontWeight.normal,
              ),
            )
          : null,
    );
  }
}
