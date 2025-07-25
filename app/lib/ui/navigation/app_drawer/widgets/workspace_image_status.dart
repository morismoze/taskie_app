import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final iconBorderThickness = imageSize * 0.05;
    const iconBottomPaddingAdjustment = 0.0;
    final iconContainerTotalSize = iconSize + (2 * iconBorderThickness);
    final iconContainerBorderRadius = iconContainerTotalSize / 2;
    final imageBorderRadius = imageSize * 0.225;

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
                  borderRadius: BorderRadius.circular(
                    iconContainerBorderRadius,
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: iconBorderThickness,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: iconBottomPaddingAdjustment,
                    ),
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
