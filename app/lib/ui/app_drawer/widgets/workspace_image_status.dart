import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkspaceImageStatus extends StatelessWidget {
  const WorkspaceImageStatus({
    super.key,
    required this.isActive,
    required this.child,
  });

  final bool isActive;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const iconSize = 15.0;
    const borderThickness = 2.5;
    const iconTopPaddingAdjustment = 0.25;
    const containerTotalSize = iconSize + (2 * borderThickness);
    const containerBorderRadius = containerTotalSize / 2;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(15), child: child),
        Positioned.fill(
          right: -10,
          // If we would put AnimatedSwitcher before Align, it would also animate
          // the alignment from middle to the right, which is not wanted.
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isActive
                  ? Container(
                      width: containerTotalSize,
                      height: containerTotalSize,
                      key: const ValueKey('activeStatus'),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: borderThickness,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: iconTopPaddingAdjustment,
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.solidCircleCheck,
                            color: Theme.of(context).colorScheme.primary,
                            size: iconSize,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('emptyPlaceholder')),
            ),
          ),
        ),
      ],
    );
  }
}
