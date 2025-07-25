import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../config/assets.dart';
import 'workspace_image_status.dart';

class WorkspaceImage extends StatelessWidget {
  const WorkspaceImage({
    super.key,
    required this.isActive,
    this.url,
    this.size = 56,
  });

  final bool isActive;
  final double size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return url != null
        ? WorkspaceImageStatus(
            isActive: isActive,
            imageSize: size,
            child: CachedNetworkImage(
              imageUrl: url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          )
        : WorkspaceImageStatus(
            isActive: isActive,
            imageSize: size,
            child: Image(
              image: const AssetImage(Assets.appIcon),
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          );
  }
}
