import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// [AppAvatar.imageUrl] takes precedence over text if not null
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.imageUrl,
  });

  final String text;
  final Color backgroundColor;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
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
                  text,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
