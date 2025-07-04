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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(15), child: child),
        if (isActive)
          Positioned.fill(
            left: -10,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2.5,
                  ),
                ),
                child: FaIcon(
                  FontAwesomeIcons.solidCircleCheck,
                  color: Theme.of(context).colorScheme.primary,
                  size: 15,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
