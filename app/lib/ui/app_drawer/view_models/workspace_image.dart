import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/assets.dart';

class WorkspaceImage extends StatelessWidget {
  const WorkspaceImage({super.key, this.url, this.size});

  final String? url;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: url != null
          ? CachedNetworkImage(imageUrl: url!, width: size, height: size)
          : Image(
              image: const AssetImage(Assets.appIcon),
              width: size,
              height: size,
            ),
    );
  }
}
