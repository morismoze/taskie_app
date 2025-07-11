import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../util/color.dart';

/// [AppAvatar.imageUrl] takes precedence over text
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.text, this.imageUrl});

  final String text;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ColorGenerator.generateColorFromString(text);
    final firstLetters = text.split(' ').map((word) => word[0]).join(' ');

    return CircleAvatar(
      foregroundImage: imageUrl != null
          ? CachedNetworkImageProvider(imageUrl!)
          : null,
      backgroundColor: backgroundColor,
      child: imageUrl == null
          ? Padding(
              padding: const EdgeInsets.all(4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  firstLetters,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
