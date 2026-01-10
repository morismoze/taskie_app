import 'package:flutter/material.dart';

import '../../../../config/assets.dart';

const kUnassignedAvatarDefaultSize = 40.0;

class UnassignedAvatar extends StatelessWidget {
  const UnassignedAvatar({super.key, this.size = kUnassignedAvatarDefaultSize});

  final double size;

  @override
  Widget build(BuildContext context) {
    final radius = size / 2;

    return CircleAvatar(
      radius: radius,
      foregroundImage: const AssetImage(Assets.unassignedIcon),
    );
  }
}
