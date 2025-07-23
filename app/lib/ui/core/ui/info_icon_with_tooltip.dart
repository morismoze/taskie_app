import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoIconWithTooltip extends StatelessWidget {
  const InfoIconWithTooltip({
    super.key,
    required this.message,
    this.tooltipShowDuration = 4,
  });

  final String message;
  final int tooltipShowDuration;

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
      showDuration: Duration(seconds: tooltipShowDuration),
      triggerMode: TooltipTriggerMode.tap,
      child: FaIcon(
        FontAwesomeIcons.circleInfo,
        color: Theme.of(context).colorScheme.secondary,
        size: 17,
      ),
    );
  }
}
