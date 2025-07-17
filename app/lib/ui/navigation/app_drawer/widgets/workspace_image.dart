import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../config/assets.dart';
import 'workspace_image_status.dart';

class WorkspaceImage extends StatelessWidget {
  const WorkspaceImage({
    super.key,
    required this.isActive,
    this.url,
    this.size,
  });

  final bool isActive;
  final String? url;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return url != null
        ? WorkspaceImageStatus(
            isActive: isActive,
            child: CachedNetworkImage(
              imageUrl: url!,
              width: size,
              height: size,
            ),
          )
        : WorkspaceImageStatus(
            isActive: isActive,
            child: Image(
              image: const AssetImage(Assets.appIcon),
              width: size,
              height: size,
            ),
          );
  }
}
