import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/constants.dart';

class WorkspaceImageStatus extends StatelessWidget {
  const WorkspaceImageStatus({
    super.key,
    required this.isActive,
    required this.imageSize,
    required this.child,
  });

  final bool isActive;
  final double imageSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final iconSize = imageSize * 0.3;
    final iconBorderThickness = 2.5;
    final iconContainerTotalSize = iconSize + (2 * iconBorderThickness);
    final imageBorderRadius =
        imageSize * MiscConstants.appIconBorderRadiusSizePercentage;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(imageBorderRadius),
          child: child,
        ),
        if (isActive)
          Positioned.fill(
            right: -10,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: iconContainerTotalSize,
                height: iconContainerTotalSize,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: iconBorderThickness,
                  ),
                ),
                child: Center(
                  child: Transform.translate(
                    // For some reason the icon is vertically half a pixel to
                    // the bottom. This translation compensates for that.
                    offset: const Offset(0, -0.5),
                    child: FaIcon(
                      FontAwesomeIcons.solidCircleCheck,
                      color: Theme.of(context).colorScheme.primary,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
