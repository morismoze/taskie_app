import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../config/assets.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/app_icon.dart';

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

  static const _outerBorderW = 3.0;
  static const _innerBorderW = 3.0;

  @override
  Widget build(BuildContext context) {
    final r = size * appIconBorderRadiusSizePercentage;
    final total = _outerBorderW + _innerBorderW;

    final image = url != null
        ? CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover)
        : const Image(image: AssetImage(Assets.appIcon), fit: BoxFit.cover);

    if (!isActive) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(borderRadius: BorderRadius.circular(r), child: image),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none, // Allow borders to paint outside
        fit: StackFit.expand,
        children: [
          // Outer border
          Positioned(
            left: -total,
            top: -total,
            right: -total,
            bottom: -total,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r + total),
                border: Border.all(
                  color: AppColors.black1,
                  width: _outerBorderW,
                ),
              ),
            ),
          ),
          // Inner border
          Positioned(
            left: -_innerBorderW,
            top: -_innerBorderW,
            right: -_innerBorderW,
            bottom: -_innerBorderW,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r + _innerBorderW),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: _innerBorderW,
                ),
              ),
            ),
          ),
          ClipRRect(borderRadius: BorderRadius.circular(r), child: image),
        ],
      ),
    );
  }
}
