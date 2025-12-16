import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

const kProgressBarHeight = 12.0;
const kProgressBadgePadding = 12.0;

class GoalProgress extends StatelessWidget {
  const GoalProgress({
    super.key,
    required this.requiredPoints,
    required this.accumulatedPoints,
  });

  final int requiredPoints;
  final int accumulatedPoints;

  @override
  Widget build(BuildContext context) {
    final progress = (accumulatedPoints / requiredPoints).clamp(0.0, 1.0);

    return Column(
      spacing: 8,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final badgeText = accumulatedPoints.toString();
            final trackWidth = constraints.maxWidth;
            // End of the green progress track - x-coordinate of the end
            final progressTrackEnd = trackWidth * progress;
            // Badge width: text + padding
            final estimatedBadgeWidth = _estimateBadgeWidth(context, badgeText);
            // Represents the ideal position of the left border of the badge since we want
            // its center to be on the progress track end.
            final baseBadgeLeftBorderPosition =
                progressTrackEnd - estimatedBadgeWidth / 2;
            // Position represents position of the left border of the badge
            final position = baseBadgeLeftBorderPosition.clamp(
              0.0,
              trackWidth - estimatedBadgeWidth,
            );

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // Clipping only the track and progress track because
                // we want to keep the progress badge as whole.
                ClipRRect(
                  borderRadius: BorderRadius.circular(kProgressBarHeight),
                  child: SizedBox(
                    height: kProgressBarHeight,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        const _Track(),
                        _Progress(progress: progress),
                      ],
                    ),
                  ),
                ),
                _ProgressBadge(position: position, text: badgeText),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.grey2,
              ),
            ),
            Text(
              requiredPoints.toString(),
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.grey2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _estimateBadgeWidth(BuildContext context, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Text width + horizontal padding (12 * 2)
    return textPainter.width + kProgressBadgePadding * 2;
  }
}

class _Track extends StatelessWidget {
  const _Track();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: kProgressBarHeight,
      color: AppColors.grey1,
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: progress,
      child: Container(height: kProgressBarHeight, color: AppColors.green2),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.text, required this.position});

  final String text;
  final double position;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 12,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Badge(
          backgroundColor: AppColors.green2,
          padding: const EdgeInsets.symmetric(
            horizontal: kProgressBadgePadding,
          ),
          label: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.white1,
            ),
          ),
        ),
      ),
    );
  }
}
