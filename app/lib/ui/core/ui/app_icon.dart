import 'package:flutter/material.dart';

import '../../../config/assets.dart';

const appIconSize = 90.0;
const appIconBorderRadiusSizePercentage = 0.2;

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, this.size = appIconSize})
    : borderRadius = size * appIconBorderRadiusSizePercentage;

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: Image(
        image: const AssetImage(Assets.appIcon),
        height: size,
        width: size,
      ),
    );
  }
}
