import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/assets.dart';

class WorkspaceImage extends StatelessWidget {
  const WorkspaceImage({super.key, this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: url != null
          ? CachedNetworkImage(imageUrl: url!)
          : const Image(image: AssetImage(Assets.appIcon)),
    );
  }
}
