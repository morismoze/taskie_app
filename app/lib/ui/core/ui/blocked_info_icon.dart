import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BlockedInfoIcon extends StatelessWidget {
  const BlockedInfoIcon({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      richMessage: WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
      showDuration: const Duration(seconds: 4),
      triggerMode: TooltipTriggerMode.tap,
      child: FaIcon(
        FontAwesomeIcons.circleInfo,
        color: Theme.of(context).colorScheme.secondary,
        size: 15,
      ),
    );
  }
}
