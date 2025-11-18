import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

const kProgressBarHeight = 12.0;

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
    final progress = accumulatedPoints / requiredPoints;

    return Column(
      spacing: 8,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            final badgePosition = trackWidth * progress;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                const _Track(),
                _Progress(progress: progress),
                _ProgressBadge(
                  position: badgePosition,
                  accumulatedPoints: accumulatedPoints,
                ),
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
}

class _Track extends StatelessWidget {
  const _Track();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: kProgressBarHeight,
      decoration: BoxDecoration(
        color: AppColors.grey1,
        borderRadius: BorderRadius.circular(kProgressBarHeight),
      ),
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
      child: Container(
        height: kProgressBarHeight,
        decoration: BoxDecoration(
          color: AppColors.green2,
          borderRadius: BorderRadius.circular(kProgressBarHeight),
        ),
      ),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({
    required this.accumulatedPoints,
    required this.position,
  });

  final int accumulatedPoints;
  final double position;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            label: Text(
              accumulatedPoints.toString(),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
